package client.ui.screens {
import com.company.assembleegameclient.appengine.SavedCharacter;
import com.company.assembleegameclient.appengine.CharListEvent;
import com.company.assembleegameclient.appengine.ClassStats;
import com.company.assembleegameclient.ui.tooltip.ClassToolTip;
import com.company.assembleegameclient.ui.tooltip.ToolTip;
import com.company.assembleegameclient.util.FameUtil;
import com.company.assembleegameclient.util.AnimatedChar;
import com.company.rotmg.graphics.FullCharBoxGraphic;
import com.company.rotmg.graphics.LockedCharBoxGraphic;
import com.company.rotmg.graphics.StarGraphic;
import com.company.ui.SimpleText;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;
import flash.text.TextFieldAutoSize;

/**
 * Tile for one playable class on the new-character screen: animated preview,
 * class name, and either a star row (available) or a "Locked" label.
 */
public class CharacterBox extends Sprite {

    public static const DELETE_CHAR:String = "DELETE_CHAR";
    public static const ENTER_NAME:String = "ENTER_NAME";

    private static const STAR_EARNED_TRANSFORM:ColorTransform = new ColorTransform(0.8, 0.8, 0.8);
    private static const STAR_UNEARNED_TRANSFORM:ColorTransform = new ColorTransform(0.2, 0.2, 0.2);
    private static const SPIN_FRAMES_PER_STEP:int = 20;
    /** Facing order while the mouse is over the box. */
    private static const SPIN_DIRECTIONS:Array = [AnimatedChar.DOWN, AnimatedChar.RIGHT, AnimatedChar.UP, AnimatedChar.LEFT];

    public var playerXML_:XML = null;
    public var charStats_:ClassStats;
    public var charList_:CharListEvent;
    /** True when the class is unlocked for this account. */
    public var available:Boolean;
    public var curSpinPos:int = 0;
    public var spinFramesElapsed:int = 0;
    public var selectedOver:Boolean = false;

    private var boxGraphic:Sprite;
    private var bitmap_:Bitmap;
    private var lockedText:SimpleText;
    private var classNameText_:SimpleText;

    public function CharacterBox(playerXML:XML, charStats:ClassStats, charList:CharListEvent) {
        super();
        this.playerXML_ = playerXML;
        this.charStats_ = charStats;
        this.charList_ = charList;
        this.available = this.charList_.isAvailable(this.objectType());
        if (!this.available) {
            this.boxGraphic = new LockedCharBoxGraphic();
        } else {
            this.boxGraphic = new FullCharBoxGraphic();
        }
        addChild(this.boxGraphic);
        this.bitmap_ = new Bitmap(null);
        this.setImage(AnimatedChar.DOWN, AnimatedChar.STAND, 0);
        addChild(this.bitmap_);
        this.classNameText_ = new SimpleText(14, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.classNameText_.setBold(true);
        this.classNameText_.htmlText = (('<p align="center">' + this.playerXML_.@id) + "</p>");
        this.classNameText_.autoSize = TextFieldAutoSize.CENTER;
        this.classNameText_.updateMetrics();
        this.classNameText_.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4)];
        addChild(this.classNameText_);
        if (!this.available) {
            this.lockedText = new SimpleText(14, 0xFF0000, false, 0, 0, "Myriad Pro");
            this.lockedText.htmlText = '<p align="center">Locked</p>';
            this.lockedText.setBold(true);
            this.lockedText.autoSize = TextFieldAutoSize.CENTER;
            this.lockedText.updateMetrics();
            this.lockedText.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4)];
            this.lockedText.y = 58;
            addChild(this.lockedText);
            this.classNameText_.y = 78;
        } else {
            var stars:Sprite = this.buildStars(FameUtil.numStars(this.charList_.bestFame(this.objectType())), FameUtil.STAR_THRESHOLDS.length);
            stars.y = 60;
            stars.x = ((this.boxGraphic.width / 2) - (stars.width / 2));
            stars.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4)];
            addChild(stars);
            this.classNameText_.y = 74;
        }
    }

    public function objectType():int {
        return int(this.playerXML_.@type);
    }

    public function getTooltip():ToolTip {
        return new ClassToolTip(this.playerXML_, this.charList_, this.charStats_);
    }

    public function setHighlighted(highlighted:Boolean):void {
        if (!this.available) {
            return;
        }
        if (highlighted) {
            transform.colorTransform = new ColorTransform(1.2, 1.2, 1.2);
        } else {
            transform.colorTransform = new ColorTransform(1, 1, 1);
        }
    }

    /** Called every frame: spins the preview while hovered, otherwise resets to facing down. */
    public function tryUpdateSpin():void {
        if (!this.selectedOver) {
            this.setImage(AnimatedChar.DOWN, AnimatedChar.STAND, 0);
            this.spinFramesElapsed = 0;
            this.curSpinPos = 0;
            return;
        }
        this.spinFramesElapsed++;
        if (this.spinFramesElapsed % SPIN_FRAMES_PER_STEP == 0) {
            this.spinFramesElapsed = 0;
            this.curSpinPos = ((this.curSpinPos + 1) % SPIN_DIRECTIONS.length);
            this.setImage(SPIN_DIRECTIONS[this.curSpinPos], AnimatedChar.STAND, 0);
        }
    }

    public function setImage(direction:int, action:int, progress:Number):void {
        this.bitmap_.bitmapData = SavedCharacter.getImage(null, this.playerXML_, direction, action, progress, this.available, false);
        this.bitmap_.x = ((this.boxGraphic.width / 2) - (this.bitmap_.bitmapData.width / 2));
    }

    /** Row of `total` stars, the first `earned` bright and the rest dim. */
    private function buildStars(earned:int, total:int):Sprite {
        var row:Sprite = new Sprite();
        var count:int = 0;
        var offsetX:int = 0;
        var star:Sprite;
        while (count < earned) {
            star = new StarGraphic();
            star.x = offsetX;
            star.transform.colorTransform = STAR_EARNED_TRANSFORM;
            row.addChild(star);
            offsetX = (offsetX + star.width);
            count++;
        }
        while (count < total) {
            star = new StarGraphic();
            star.x = offsetX;
            star.transform.colorTransform = STAR_UNEARNED_TRANSFORM;
            row.addChild(star);
            offsetX = (offsetX + star.width);
            count++;
        }
        return row;
    }

}
}
