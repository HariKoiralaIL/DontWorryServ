package optionsscreen {

import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import com.company.ui.SimpleText;
import com.company.util.GraphicHelper;

/**
 * Button that cycles through a fixed list of choices each time it is clicked.
 * Dispatches Event.CHANGE when the selection changes.
 */
public class Chooser extends Sprite {

    public static const WIDTH:int = 80;
    public static const HEIGHT:int = 32;

    /** Text shown for each choice. */
    public var labels:Vector.<String>;

    /** The value represented by each choice (same order as labels). */
    public var values:Array;

    public var selectedIndex:int = -1;

    private var labelText_:SimpleText = null;
    private var over_:Boolean = false;

    // The order of these initialisers matters: later ones refer to earlier ones.
    private var internalFill_:GraphicsSolidFill = new GraphicsSolidFill(0x2a2a2a, 1);
    private var hoverFill:GraphicsSolidFill = new GraphicsSolidFill(0xB3B3B3, 1);
    private var normalFill:GraphicsSolidFill = new GraphicsSolidFill(0x4c4c4c, 1);
    private var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
    private var stroke:GraphicsStroke = new GraphicsStroke(2, false, LineScaleMode.NORMAL,
            CapsStyle.NONE, JointStyle.ROUND, 3, normalFill);
    private var graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[
            internalFill_, stroke, path_, GraphicHelper.NO_STROKE, GraphicHelper.END_FILL];

    public function Chooser(labels:Vector.<String>, values:Array, initialValue:Object) {
        this.labels = labels;
        this.values = values;
        this.labelText_ = new SimpleText(16, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.labelText_.setBold(true);
        this.labelText_.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        addChild(this.labelText_);
        this.setValue(initialValue);
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
        addEventListener(MouseEvent.CLICK, this.onClick);
    }

    /** Selects the choice whose value equals the given one (dispatches CHANGE unless already selected). */
    public function setValue(value:*):void {
        var i:int;
        while (i < this.values.length) {
            if (value == this.values[i]) {
                if (i == this.selectedIndex) {
                    return;
                }
                this.selectedIndex = i;
                break;
            }
            i++;
        }
        this.setSelected(this.selectedIndex);
        dispatchEvent(new Event(Event.CHANGE));
    }

    public function value() {
        return this.values[this.selectedIndex];
    }

    private function redraw():void {
        GraphicHelper.clearPath(this.path_);
        GraphicHelper.drawUI(0, 0, WIDTH, HEIGHT, 4, [1, 1, 1, 1], this.path_);
        this.stroke.fill = this.over_ ? this.hoverFill : this.normalFill;
        var g:Graphics = graphics;
        g.clear();
        g.drawGraphicsData(this.graphicsData_);
    }

    private function setSelected(index:int):void {
        this.selectedIndex = index;
        this.setLabel(this.labels[this.selectedIndex]);
    }

    private function setLabel(text:String):void {
        this.labelText_.text = text;
        this.labelText_.updateMetrics();
        this.labelText_.x = (WIDTH / 2) - (this.labelText_.width / 2);
        this.labelText_.y = ((HEIGHT / 2) - (this.labelText_.height / 2)) - 2;
        this.redraw();
    }

    private function onMouseOver(event:MouseEvent):void {
        this.over_ = true;
        this.redraw();
    }

    private function onRollOut(event:MouseEvent):void {
        this.over_ = false;
        this.redraw();
    }

    private function onClick(event:MouseEvent):void {
        this.setSelected((this.selectedIndex + 1) % this.values.length);
        dispatchEvent(new Event(Event.CHANGE));
    }

}
}//package optionsscreen
