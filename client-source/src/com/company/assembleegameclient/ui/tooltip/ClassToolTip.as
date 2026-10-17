package com.company.assembleegameclient.ui.tooltip {
import com.company.assembleegameclient.appengine.CharListEvent;
import com.company.assembleegameclient.appengine.ClassStats;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.ui.LineSeparator;
import com.company.assembleegameclient.util.AnimatedChar;
import com.company.assembleegameclient.util.AnimatedCharLibrary;
import com.company.assembleegameclient.util.MaskedImage;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.ui.SimpleText;
import com.company.util.BitmapEffectCache;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

public class ClassToolTip extends ToolTip {

    private static const DIVIDER_COLOR:uint = 0x2D2D2D;
    private static const STATS_COLOR:uint = 0x5EB531;
    private static const GOAL_COLOR:uint = 0xFC8642;

    private var portrait_:Bitmap;
    private var nameText_:SimpleText;
    private var desc_:SimpleText;
    private var divider_:LineSeparator;
    private var statsText_:SimpleText;
    private var unlockText_:SimpleText;
    private var nextGoalText_:SimpleText;

    public function ClassToolTip(classXML:XML, charList:CharListEvent, classStats:ClassStats) {
        super(0x2A2A2A, 1, 0xFFFFFF, 1);
        var available:Boolean = charList.isAvailable(int(classXML.@type));

        addPortrait(classXML, available);
        addName(classXML);
        addDescription(classXML);

        divider_ = new LineSeparator(100, DIVIDER_COLOR);
        divider_.x = 6;
        divider_.y = height;
        addChild(divider_);

        if (available) {
            addStats(classXML, classStats);
        } else {
            addUnlockRequirements(classXML, charList);
        }
    }

    override public function draw():void {
        divider_.drawHorizontal(width - 10, DIVIDER_COLOR);
        super.draw();
    }

    private function addPortrait(classXML:XML, available:Boolean):void {
        var animatedChar:AnimatedChar = AnimatedCharLibrary.getAnimatedChar(
                String(classXML.AnimatedTexture.File), int(classXML.AnimatedTexture.Index));
        var maskedImage:MaskedImage = animatedChar.imageFromDir(AnimatedChar.RIGHT, AnimatedChar.STAND, 0);
        var scale:int = (4 / maskedImage.width()) * 100;
        var bitmapData:BitmapData = TextureRedrawer.redraw(maskedImage.image_, scale, true, 0, 0);
        if (!available) {
            bitmapData = BitmapEffectCache.getColorTransformed(bitmapData, new ColorTransform(0, 0, 0, 0.5, 0, 0, 0, 0));
        }
        portrait_ = new Bitmap();
        portrait_.bitmapData = bitmapData;
        portrait_.x = -4;
        portrait_.y = -4;
        addChild(portrait_);
    }

    private function addName(classXML:XML):void {
        nameText_ = new SimpleText(13, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        nameText_.setBold(true);
        nameText_.text = classXML.@id;
        nameText_.updateMetrics();
        nameText_.filters = [new DropShadowFilter(0, 0, 0)];
        nameText_.x = 32;
        nameText_.y = 6;
        addChild(nameText_);
    }

    private function addDescription(classXML:XML):void {
        desc_ = new SimpleText(13, 0xB3B3B3, false, 174, 0, "Myriad Pro");
        desc_.wordWrap = true;
        desc_.multiline = true;
        desc_.text = classXML.Description;
        desc_.updateMetrics();
        desc_.filters = [new DropShadowFilter(0, 0, 0)];
        desc_.x = 8;
        desc_.y = 40;
        addChild(desc_);
    }

    private function addStats(classXML:XML, classStats:ClassStats):void {
        statsText_ = new SimpleText(12, STATS_COLOR, false, 0, 0, "Myriad Pro");
        statsText_.text = ClassStatsText.summary(classStats);
        statsText_.updateMetrics();
        statsText_.filters = [new DropShadowFilter(0, 0, 0)];
        statsText_.x = 8;
        statsText_.y = height - 2;
        addChild(statsText_);

        var goal:String = ClassStatsText.nextGoal(classStats, String(classXML.@id));
        if (goal != null) {
            nextGoalText_ = new SimpleText(10, GOAL_COLOR, false, 174, 0, "Myriad Pro");
            nextGoalText_.text = goal;
            nextGoalText_.updateMetrics();
            nextGoalText_.filters = [new DropShadowFilter(0, 0, 0)];
            nextGoalText_.x = 8;
            nextGoalText_.y = height - 2;
            addChild(nextGoalText_);
        }
    }

    private function addUnlockRequirements(classXML:XML, charList:CharListEvent):void {
        var label:SimpleText = new SimpleText(13, 0xB3B3B3, false, 174, 0, "Myriad Pro");
        label.setBold(true);
        label.text = "To Unlock:";
        label.updateMetrics();
        label.filters = [new DropShadowFilter(0, 0, 0)];
        label.x = 8;
        label.y = height - 2;
        addChild(label);

        var requirements:String = "";
        for each (var unlock:XML in classXML.UnlockLevel) {
            var requiredType:int = ObjectLibrary.idToType_[unlock.toString()];
            var requiredLevel:int = int(unlock.@level);
            if (charList.bestLevel(requiredType) < requiredLevel) {
                if (requirements != "") {
                    requirements += "\n";
                }
                requirements += "Reach Level " + requiredLevel + " with " + ObjectLibrary.typeToDisplayId_[requiredType];
            }
        }
        unlockText_ = new SimpleText(13, GOAL_COLOR, false, 174, 0, "Myriad Pro");
        unlockText_.wordWrap = false;
        unlockText_.multiline = true;
        unlockText_.text = requirements;
        unlockText_.border = false;
        unlockText_.updateMetrics();
        unlockText_.filters = [new DropShadowFilter(0, 0, 0)];
        unlockText_.x = 12;
        unlockText_.y = height - 4;
        addChild(unlockText_);
    }

}
}
