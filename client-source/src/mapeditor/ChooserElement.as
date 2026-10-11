package mapeditor {
import com.company.assembleegameclient.ui.tooltip.ToolTip;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

/** One selectable cell in a Chooser. Subclasses draw a preview and supply a tooltip. */
public class ChooserElement extends Sprite {

    public static const WIDTH:int = 50;
    public static const HEIGHT:int = 50;

    /** Only one tooltip is shown at a time across all elements. */
    protected static var toolTip_:ToolTip = null;

    public function ChooserElement(type:int) {
        this.type_ = type;
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }
    public var type_:int;
    protected var selected_:Boolean = false;
    protected var hovered_:Boolean = false;

    public function setSelected(selected:Boolean):void {
        this.selected_ = selected;
        this.draw();
    }

    protected function showToolTip(toolTip:ToolTip):void {
        this.hideToolTip();
        toolTip_ = toolTip;
        if (toolTip_ != null) {
            stage.addChild(toolTip_);
        }
    }

    protected function hideToolTip():void {
        if (toolTip_ != null) {
            if (toolTip_.parent != null) {
                toolTip_.parent.removeChild(toolTip_);
            }
            toolTip_ = null;
        }
    }

    /** Overridden by subclasses to return the tooltip for this element. */
    protected function getToolTip():ToolTip {
        return (null);
    }

    private function draw():void {
        graphics.clear();
        if (this.selected_) {
            graphics.lineStyle(1, 0xFFFFFF);
        }
        graphics.beginFill(((this.hovered_) ? 0x565656 : 0x363636), 1);
        graphics.drawRect(2, 2, (WIDTH - 4), (HEIGHT - 4));
        if (this.selected_) {
            graphics.lineStyle();
        }
        graphics.endFill();
    }

    private function onAddedToStage(event:Event):void {
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
    }

    private function onRemovedFromStage(event:Event):void {
        removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        removeEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
    }

    private function onMouseOver(event:Event):void {
        this.hovered_ = true;
        this.draw();
        this.showToolTip(this.getToolTip());
    }

    private function onRollOut(event:Event):void {
        this.hovered_ = false;
        this.draw();
        this.hideToolTip();
    }

}
}
