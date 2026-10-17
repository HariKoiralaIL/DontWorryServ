package mapeditor {
import com.company.assembleegameclient.ui.Scrollbar;
import com.company.util.GraphicHelper;

import flash.display.CapsStyle;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

/** Scrollable two-column palette of ChooserElements for one map layer. */
internal class Chooser extends Sprite {

    public static const WIDTH:int = 136;
    public static const HEIGHT:int = 480;
    private static const SCROLLBAR_WIDTH:int = 20;

    public function Chooser(layer:int) {
        this.elements_ = new Vector.<ChooserElement>();
        this.outlineFill_ = new GraphicsSolidFill(0xFFFFFF, 1);
        this.outlineStroke_ = new GraphicsStroke(1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, this.outlineFill_);
        this.backgroundFill_ = new GraphicsSolidFill(0x363636, 1);
        this.path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        this.graphicsData_ = new <IGraphicsData>[outlineStroke_, backgroundFill_, path_, GraphicHelper.END_FILL, GraphicHelper.NO_STROKE];
        super();
        this.layer_ = layer;
        this.drawBackground();
        this.content_ = new Sprite();
        this.content_.x = 4;
        this.content_.y = 6;
        addChild(this.content_);
        this.scrollBar_ = new Scrollbar(SCROLLBAR_WIDTH, (HEIGHT - 8));
        this.scrollBar_.x = ((WIDTH - SCROLLBAR_WIDTH) - 6);
        this.scrollBar_.y = 4;
        this.scrollBar_.addEventListener(Event.CHANGE, this.onScroll);
        var maskShape:Shape = new Shape();
        maskShape.graphics.beginFill(0);
        maskShape.graphics.drawRect(0, 2, ((WIDTH - SCROLLBAR_WIDTH) - 4), (HEIGHT - 4));
        addChild(maskShape);
        this.content_.mask = maskShape;
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }
    /** Which MapLayer this chooser edits. */
    public var layer_:int;
    public var selectedElement_:ChooserElement;
    private var graphicsData_:Vector.<IGraphicsData>;
    private var content_:Sprite;
    private var scrollBar_:Scrollbar;
    private var elements_:Vector.<ChooserElement>;
    private var outlineFill_:GraphicsSolidFill;
    private var outlineStroke_:GraphicsStroke;
    private var backgroundFill_:GraphicsSolidFill;
    private var path_:GraphicsPath;

    public function getSelectedType():int {
        return (this.selectedElement_.type_);
    }

    public function selectType(type:int):void {
        var element:ChooserElement;
        for each (element in this.elements_) {
            if (element.type_ == type) {
                this.setSelected(element);
                return;
            }
        }
    }

    protected function addElement(element:ChooserElement):void {
        var index:int = this.elements_.length;
        element.x = (((index % 2) == 0) ? 0 : (2 + ChooserElement.WIDTH));
        element.y = ((int((index / 2)) * ChooserElement.HEIGHT) + 6);
        this.content_.addChild(element);
        if (index == 0) {
            this.setSelected(element);
        }
        element.addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
        this.elements_.push(element);
    }

    protected function setSelected(element:ChooserElement):void {
        if (this.selectedElement_ != null) {
            this.selectedElement_.setSelected(false);
        }
        this.selectedElement_ = element;
        this.selectedElement_.setSelected(true);
    }

    private function drawBackground():void {
        GraphicHelper.clearPath(this.path_);
        GraphicHelper.drawUI(0, 0, WIDTH, HEIGHT, 4, [1, 1, 1, 1], this.path_);
        graphics.drawGraphicsData(this.graphicsData_);
    }

    protected function onMouseDown(mouseEvent:MouseEvent):void {
        var element:ChooserElement = (mouseEvent.currentTarget as ChooserElement);
        this.setSelected(element);
    }

    protected function onScroll(event:Event):void {
        this.content_.y = (6 - (this.scrollBar_.getPosition() * ((this.content_.height + 12) - HEIGHT)));
    }

    protected function onAddedToStage(event:Event):void {
        addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
        this.scrollBar_.setIndicatorSize(HEIGHT, this.content_.height);
        addChild(this.scrollBar_);
    }

    protected function onRemovedFromStage(event:Event):void {
        removeEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
    }

    protected function onMouseWheel(mouseEvent:MouseEvent):void {
        if (mouseEvent.delta > 0) {
            this.scrollBar_.pageUp();
        } else if (mouseEvent.delta < 0) {
            this.scrollBar_.pageDown();
        }
    }

}
}
