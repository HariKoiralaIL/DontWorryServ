package com.company.assembleegameclient.util {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.rotmg.graphics.StarGraphic;
import com.company.util.AssetLibrary;

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

public class FameUtil {

    /** Fame required for each successive star tier. */
    public static const STAR_THRESHOLDS:Vector.<int> = new <int>[20, 150, 400, 800, 2000, 6500];

    private static const LIGHT_BLUE:ColorTransform = new ColorTransform((138 / 0xFF), (152 / 0xFF), (222 / 0xFF));
    private static const DARK_BLUE:ColorTransform = new ColorTransform((49 / 0xFF), (77 / 0xFF), (219 / 0xFF));
    private static const RED:ColorTransform = new ColorTransform((193 / 0xFF), (39 / 0xFF), (45 / 0xFF));
    private static const ORANGE:ColorTransform = new ColorTransform((247 / 0xFF), (147 / 0xFF), (30 / 0xFF));
    private static const YELLOW:ColorTransform = new ColorTransform((0xFF / 0xFF), (0xFF / 0xFF), (0 / 0xFF));
    private static const WHITE:ColorTransform = new ColorTransform();
    private static const MAGENTA:ColorTransform = new ColorTransform((0xFF / 0xFF), (0 / 0xFF), (0xFF / 0xFF));

    /** Star color for each tier (one tier per full set of player classes). */
    public static const STAR_COLORS:Vector.<ColorTransform> = new <ColorTransform>[LIGHT_BLUE, DARK_BLUE, RED, ORANGE, YELLOW, WHITE];

    public static function maxStars():int {
        return ObjectLibrary.playerChars_.length * STAR_THRESHOLDS.length;
    }

    /** Number of stars earned for the given fame. */
    public static function numStars(fame:int):int {
        var stars:int;
        while (stars < STAR_THRESHOLDS.length && fame >= STAR_THRESHOLDS[stars]) {
            stars++;
        }
        return stars;
    }

    /** Fame needed for the next star beyond the higher of the two values, or -1 if maxed. */
    public static function nextStarFame(fameA:int, fameB:int):int {
        var best:int = Math.max(fameA, fameB);
        var i:int = 0;
        while (i < STAR_THRESHOLDS.length) {
            if (STAR_THRESHOLDS[i] > best) {
                return STAR_THRESHOLDS[i];
            }
            i++;
        }
        return -1;
    }

    public static function numStarsToBigImage(stars:int):Sprite {
        var star:Sprite = numStarsToImage(stars);
        star.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        star.scaleX = 1.4;
        star.scaleY = 1.4;
        return star;
    }

    public static function numStarsToImage(stars:int):Sprite {
        var star:Sprite = new StarGraphic();
        var starsPerTier:int = ObjectLibrary.playerChars_.length;
        var tier:int = 0;
        while (tier < STAR_COLORS.length && stars >= starsPerTier * (tier + 1)) {
            tier++;
        }
        star.transform.colorTransform = (tier < STAR_COLORS.length) ? STAR_COLORS[tier] : MAGENTA;
        return star;
    }

    /** A star on a translucent dark circle with a drop shadow. */
    public static function numStarsToIcon(stars:int):Sprite {
        var star:Sprite = numStarsToImage(stars);
        var icon:Sprite = new Sprite();
        icon.graphics.beginFill(0, 0.4);
        var radiusX:int = ((star.width / 2) + 2);
        var radiusY:int = ((star.height / 2) + 2);
        icon.graphics.drawCircle(radiusX, radiusY, radiusX);
        star.x = 2;
        star.y = 1;
        icon.addChild(star);
        icon.filters = [new DropShadowFilter(0, 0, 0, 0.5, 6, 6, 1)];
        return icon;
    }

    public static function getFameIcon():BitmapData {
        var icon:BitmapData = AssetLibrary._xK_("lofiObj3", 224);
        return TextureRedrawer.redraw(icon, 40, true, 0, 0);
    }

}
}
