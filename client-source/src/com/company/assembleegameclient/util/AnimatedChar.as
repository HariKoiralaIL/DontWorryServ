package com.company.assembleegameclient.util {
import com.company.assembleegameclient.map.GameCamera;
import com.company.util.Trig;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

/**
 * A character's animation frames, organised as direction -> action -> frames.
 * Missing directions are derived from the first direction (mirroring) or fall back
 * to the closest available one.
 */
public class AnimatedChar {

    public static const RIGHT:int = 0;
    public static const LEFT:int = 1;
    public static const DOWN:int = 2;
    public static const UP:int = 3;
    public static const NUM_DIR:int = 4;

    public static const STAND:int = 0;
    public static const WALK:int = 1;
    public static const ATTACK:int = 2;
    public static const NUM_ACTION:int = 3;

    private static const FRAMES_PER_DIR:int = 7;

    /** For each of the 8 facing octants, the directions to try in priority order. */
    private static const OCTANT_DIRECTIONS:Vector.<Vector.<int>> = new <Vector.<int>>[
        new <int>[LEFT, UP, DOWN],
        new <int>[UP, LEFT, DOWN],
        new <int>[UP, RIGHT, DOWN],
        new <int>[RIGHT, UP, DOWN],
        new <int>[RIGHT, DOWN],
        new <int>[DOWN, RIGHT],
        new <int>[DOWN, LEFT],
        new <int>[LEFT, DOWN]
    ];
    private static const OCTANT_ANGLE:Number = (Math.PI / 4);

    public var origImage_:MaskedImage;
    private var width_:int;
    private var height_:int;
    private var firstDir_:int;
    private var imagesByDir_:Dictionary = new Dictionary();

    public function AnimatedChar(origImage:MaskedImage, width:int, height:int, firstDir:int) {
        this.origImage_ = origImage;
        this.width_ = width;
        this.height_ = height;
        this.firstDir_ = firstDir;
        var frames:MaskedImageSet = new MaskedImageSet();
        frames.addFromMaskedImage(origImage, width, height);
        if (firstDir == RIGHT) {
            this.imagesByDir_[RIGHT] = this.buildDirection(0, false, false, frames);
            this.imagesByDir_[LEFT] = this.buildDirection(0, true, false, frames);
            if (frames.images_.length >= FRAMES_PER_DIR * 2) {
                this.imagesByDir_[DOWN] = this.buildDirection(FRAMES_PER_DIR, false, true, frames);
                if (frames.images_.length >= FRAMES_PER_DIR * 3) {
                    this.imagesByDir_[UP] = this.buildDirection(FRAMES_PER_DIR * 2, false, true, frames);
                }
            }
        } else {
            if (firstDir == DOWN) {
                this.imagesByDir_[DOWN] = this.buildDirection(0, false, true, frames);
                if (frames.images_.length >= FRAMES_PER_DIR * 2) {
                    this.imagesByDir_[RIGHT] = this.buildDirection(FRAMES_PER_DIR, false, false, frames);
                    this.imagesByDir_[LEFT] = this.buildDirection(FRAMES_PER_DIR, true, false, frames);
                    if (frames.images_.length >= FRAMES_PER_DIR * 3) {
                        this.imagesByDir_[UP] = this.buildDirection(FRAMES_PER_DIR * 2, false, true, frames);
                    }
                }
            }
        }
    }

    /** Lays the first direction's stand/walk/attack frames out in a single row. */
    public function buildPreviewSheet():BitmapData {
        var sheet:BitmapData = new BitmapData((this.width_ * 7), this.height_, true, 0);
        var actions:Dictionary = this.imagesByDir_[this.firstDir_];
        var frames:Vector.<MaskedImage> = actions[STAND];
        if (frames.length > 0) {
            sheet.copyPixels(frames[0].image_, frames[0].image_.rect, new Point(0, 0));
        }
        frames = actions[WALK];
        if (frames.length > 0) {
            sheet.copyPixels(frames[0].image_, frames[0].image_.rect, new Point(this.width_, 0));
        }
        if (frames.length > 1) {
            sheet.copyPixels(frames[1].image_, frames[1].image_.rect, new Point((this.width_ * 2), 0));
        }
        frames = actions[ATTACK];
        if (frames.length > 0) {
            sheet.copyPixels(frames[0].image_, frames[0].image_.rect, new Point((this.width_ * 4), 0));
        }
        if (frames.length > 1) {
            sheet.copyPixels(frames[1].image_, new Rectangle(this.width_, 0, (this.width_ * 2), this.height_), new Point((this.width_ * 5), 0));
        }
        return sheet;
    }

    public function getImages(dir:int, action:int):Vector.<MaskedImage> {
        return this.imagesByDir_[dir][action];
    }

    /** @param progress animation progress in the range 0-1 */
    public function imageFromDir(dir:int, action:int, progress:Number):MaskedImage {
        var frames:Vector.<MaskedImage> = this.imagesByDir_[dir][action];
        progress = Math.max(0, Math.min(0.99999, progress));
        var index:int = (progress * frames.length);
        return frames[index];
    }

    /** @param angle facing angle in radians */
    public function imageFromAngle(angle:Number, action:int, progress:Number):MaskedImage {
        var octant:int = (int(((angle / OCTANT_ANGLE) + 4)) % 8);
        return this.imageForOctant(octant, action, progress);
    }

    /** Like imageFromAngle, but relative to the camera rotation. */
    public function imageFromFacing(facing:Number, camera:GameCamera, action:int, progress:Number):MaskedImage {
        var relativeAngle:Number = Trig._V_r((facing - camera.angleRad_));
        var octant:int = (int(((relativeAngle / OCTANT_ANGLE) + 4)) % 8);
        return this.imageForOctant(octant, action, progress);
    }

    private function imageForOctant(octant:int, action:int, progress:Number):MaskedImage {
        var priority:Vector.<int> = OCTANT_DIRECTIONS[octant];
        var actions:Dictionary = this.imagesByDir_[priority[0]];
        if (actions == null) {
            actions = this.imagesByDir_[priority[1]];
            if (actions == null) {
                actions = this.imagesByDir_[priority[2]];
            }
        }
        var frames:Vector.<MaskedImage> = actions[action];
        progress = Math.max(0, Math.min(0.99999, progress));
        var index:int = (progress * frames.length);
        return frames[index];
    }

    /**
     * Builds the stand/walk/attack frame lists for one direction.
     *
     * @param offset   index of the direction's first frame in the frame set
     * @param mirror   mirror every frame horizontally (used to derive LEFT from RIGHT)
     * @param flipDown synthesise a missing second walk frame by mirroring the first
     */
    private function buildDirection(offset:int, mirror:Boolean, flipDown:Boolean, frames:MaskedImageSet):Dictionary {
        var combinedImage:BitmapData;
        var combinedMask:BitmapData;
        var result:Dictionary = new Dictionary();

        var stand:MaskedImage = frames.images_[(offset + 0)];
        var walk0:MaskedImage = frames.images_[(offset + 1)];
        var walk1:MaskedImage = frames.images_[(offset + 2)];
        if (walk1.amountTransparent() == 1) {
            walk1 = null;
        }
        var attack0:MaskedImage = frames.images_[(offset + 4)];
        var attack1:MaskedImage = frames.images_[(offset + 5)];
        if (attack0.amountTransparent() == 1) {
            attack0 = null;
        }
        if (attack1.amountTransparent() == 1) {
            attack1 = null;
        }
        var attack2:MaskedImage = frames.images_[(offset + 6)];
        if (attack1 != null && attack2.amountTransparent() != 1) {
            // Merge the two trailing attack frames into one wide frame.
            combinedImage = new BitmapData((this.width_ * 3), this.height_, true, 0);
            combinedImage.copyPixels(attack1.image_, new Rectangle(0, 0, this.width_, this.height_), new Point(this.width_, 0));
            combinedImage.copyPixels(attack2.image_, new Rectangle(0, 0, this.width_, this.height_), new Point((this.width_ * 2), 0));
            combinedMask = null;
            if (attack1.mask_ != null || attack2.mask_ != null) {
                combinedMask = new BitmapData((this.width_ * 3), this.height_, true, 0);
            }
            if (attack1.mask_ != null) {
                combinedMask.copyPixels(attack1.mask_, new Rectangle(0, 0, this.width_, this.height_), new Point(this.width_, 0));
            }
            if (attack2.mask_ != null) {
                combinedMask.copyPixels(attack2.mask_, new Rectangle(0, 0, this.width_, this.height_), new Point((this.width_ * 2), 0));
            }
            attack1 = new MaskedImage(combinedImage, combinedMask);
        }

        var standFrames:Vector.<MaskedImage> = new Vector.<MaskedImage>();
        standFrames.push(mirror ? stand.mirror() : stand);
        result[STAND] = standFrames;

        var walkFrames:Vector.<MaskedImage> = new Vector.<MaskedImage>();
        walkFrames.push(mirror ? walk0.mirror() : walk0);
        if (walk1 != null) {
            walkFrames.push(mirror ? walk1.mirror() : walk1);
        } else {
            if (flipDown) {
                walkFrames.push(mirror ? walk0 : walk0.mirror(7));
            } else {
                walkFrames.push(mirror ? stand.mirror() : stand);
            }
        }
        result[WALK] = walkFrames;

        var attackFrames:Vector.<MaskedImage>;
        if (attack0 == null && attack1 == null) {
            attackFrames = walkFrames;
        } else {
            attackFrames = new Vector.<MaskedImage>();
            if (attack0 != null) {
                attackFrames.push(mirror ? attack0.mirror() : attack0);
            }
            if (attack1 != null) {
                attackFrames.push(mirror ? attack1.mirror() : attack1);
            }
        }
        result[ATTACK] = attackFrames;
        return result;
    }

}
}
