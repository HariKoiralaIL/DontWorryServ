package client.ui.screens {
import com.company.assembleegameclient.ui.tooltip.TitleDescriptionToolTip;
import com.company.ui.SimpleText;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.utils.getTimer;

/**
 * One row of the death-screen stats list: right-aligned label, a value that
 * counts up from zero, an optional icon, and a hover tooltip.
 */
public class StatRow extends Sprite {

    private static const COUNT_UP_DURATION_MS:int = 500;
    private static const LABEL_RIGHT_EDGE:int = 410;
    private static const VALUE_X:int = 450;

    /** Single tooltip instance shared by all rows. */
    public static var sharedTooltip:TitleDescriptionToolTip = new TitleDescriptionToolTip(0x2A2A2A, 0x9B9B9B, null, "", 150);

    public var name_:String;
    public var tooltipText:String;
    public var value:int;
    public var valuePrefix:String;
    public var valueSuffix:String;

    private var startTime_:int = 0;
    private var nameText_:SimpleText;
    private var valueText:SimpleText;
    private var icon:DisplayObject;

    public function StatRow(fontSize:int, labelColor:uint, valueColor:uint, label:String, tooltipText:String, value:int, valuePrefix:String, valueSuffix:String, icon:DisplayObject) {
        this.name_ = label;
        this.tooltipText = tooltipText;
        this.value = value;
        this.valuePrefix = valuePrefix;
        this.valueSuffix = valueSuffix;
        this.nameText_ = new SimpleText(fontSize, labelColor, false, 0, 0, "Myriad Pro");
        this.nameText_.setBold(true);
        this.nameText_.text = this.name_;
        this.nameText_.updateMetrics();
        this.nameText_.x = (LABEL_RIGHT_EDGE - this.nameText_.textWidth);
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        addChild(this.nameText_);
        if (this.value != -1) {
            this.valueText = new SimpleText(fontSize, valueColor, false, 0, 0, "Myriad Pro");
            this.valueText.setBold(true);
            this.valueText.text = (((valuePrefix + "0") + " ") + valueSuffix);
            this.valueText.updateMetrics();
            this.valueText.x = VALUE_X;
            this.valueText.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
            addChild(this.valueText);
        }
        if (icon != null) {
            this.icon = icon;
            if (this.valueText != null) {
                this.icon.x = ((this.valueText.x + this.valueText.width) - 4);
                icon.y = (((this.valueText.height / 2) - (this.icon.height / 2)) + 2);
            } else {
                this.icon.x = VALUE_X;
                icon.y = (((this.nameText_.height / 2) - (this.icon.height / 2)) + 2);
            }
            addChild(this.icon);
        }
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    /** Jump straight to the final value on the next frame. */
    public function skipAnimation():void {
        this.startTime_ = -1000000;
    }

    public function onEnterFrame(event:Event):void {
        var progress:Number = Math.min(1, ((getTimer() - this.startTime_) / COUNT_UP_DURATION_MS));
        if (this.valueText != null) {
            var shown:int = (this.value * progress);
            this.valueText.text = (((this.valuePrefix + shown.toString()) + " ") + this.valueSuffix);
            this.valueText.updateMetrics();
            if (this.icon != null) {
                this.icon.x = ((this.valueText.x + this.valueText.width) - 4);
                this.icon.y = (((this.valueText.height / 2) - (this.icon.height / 2)) + 2);
            }
        }
        if (progress == 1) {
            removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        }
    }

    public function onMouseOver(event:Event):void {
        this.removeTooltip();
        if (this.tooltipText == null) {
            return;
        }
        sharedTooltip.setDescription(this.tooltipText);
        stage.addChild(sharedTooltip);
    }

    public function onRollOut(event:Event):void {
        this.removeTooltip();
    }

    private function removeTooltip():void {
        if (sharedTooltip.parent != null) {
            sharedTooltip.parent.removeChild(sharedTooltip);
        }
    }

    private function onAddedToStage(event:Event):void {
        if (this.startTime_ == 0) {
            this.startTime_ = getTimer();
        }
        addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
    }

    private function onRemovedFromStage(event:Event):void {
        this.removeTooltip();
        removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        removeEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
    }

}
}
