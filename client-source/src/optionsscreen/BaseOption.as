package optionsscreen {

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import com.company.assembleegameclient.ui.tooltip.TitleDescriptionToolTip;
import com.company.assembleegameclient.ui.tooltip.ToolTip;
import com.company.ui.SimpleText;

/**
 * Base class for one row on the options screen: a label with a hover tooltip,
 * plus a control supplied by the subclass (ChoiceOption, KeyCodeOption).
 */
public class BaseOption extends Sprite {

    /** The tooltip currently on screen (shared, since only one is visible at a time). */
    private static var toolTip:ToolTip;

    /** Key in Parameters.data_ that this option reads and writes. */
    public var paramName:String;

    /** Text shown in the tooltip when hovering over the label. */
    public var description:String;

    private var labelText:SimpleText;

    public function BaseOption(paramName:String, label:String, description:String) {
        this.paramName = paramName;
        this.description = description;
        this.labelText = new SimpleText(18, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        this.labelText.text = label;
        this.labelText.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        this.labelText.updateMetrics();
        // The control (button/chooser) sits at the left; the label goes to its right.
        this.labelText.x = KeyMapper.WIDTH + 24;
        this.labelText.y = (KeyMapper.HEIGHT / 2 - this.labelText.height / 2) - 2;
        this.labelText.mouseEnabled = true;
        this.labelText.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        this.labelText.addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
        addChild(this.labelText);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    /** Re-reads the current value from Parameters.data_ (overridden by subclasses). */
    public function refresh():void {
    }

    private function removeToolTip():void {
        if (toolTip != null && stage.contains(toolTip)) {
            stage.removeChild(toolTip);
            toolTip = null;
        }
    }

    private function onMouseOver(event:MouseEvent):void {
        toolTip = new TitleDescriptionToolTip(0x2D2D2D, 0x828282, null, this.description, 150);
        stage.addChild(toolTip);
    }

    private function onRollOut(event:MouseEvent):void {
        this.removeToolTip();
    }

    private function onRemovedFromStage(event:Event):void {
        this.removeToolTip();
    }

}
}//package optionsscreen
