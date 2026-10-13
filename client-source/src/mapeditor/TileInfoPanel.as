package mapeditor {
import com.company.assembleegameclient.map.GroundLibrary;
import com.company.assembleegameclient.map.RegionLibrary;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.ui.SimpleText;
import com.company.util.GraphicHelper;

import flash.display.CapsStyle;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.DropShadowFilter;
import flash.geom.Rectangle;
import flash.text.StyleSheet;

/** Small panel showing the hovered/selected tile position and what is placed on it. */
public class TileInfoPanel extends Sprite {

    public static const WIDTH:int = 134;
    public static const HEIGHT:int = 150;
    private static const HANGING_INDENT_CSS:String = ".in { margin-left:10px; text-indent: -10px; }";

    public function TileInfoPanel(map:MapCanvas) {
        this.outlineFill_ = new GraphicsSolidFill(0xFFFFFF, 1);
        this.outlineStroke_ = new GraphicsStroke(1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, this.outlineFill_);
        this.backgroundFill_ = new GraphicsSolidFill(0x2A2A2A, 1);
        this.path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        this.graphicsData_ = new <IGraphicsData>[outlineStroke_, backgroundFill_, path_, GraphicHelper.END_FILL, GraphicHelper._H_B_];
        super();
        this.map_ = map;
        this.drawBackground();
        this.positionText_ = new SimpleText(12, 0xFFFFFF, false, (WIDTH - 10), 0, "Myriad Pro");
        this.positionText_.filters = [new DropShadowFilter(0, 0, 0)];
        this.positionText_.y = 4;
        this.positionText_.x = 4;
        addChild(this.positionText_);
        var styleSheet:StyleSheet = new StyleSheet();
        styleSheet.parseCSS(HANGING_INDENT_CSS);
        this.tileText_ = new SimpleText(12, 0xFFFFFF, false, (WIDTH - 10), 0, "Myriad Pro");
        this.tileText_.styleSheet = styleSheet;
        this.tileText_.wordWrap = true;
        this.tileText_.filters = [new DropShadowFilter(0, 0, 0)];
        this.tileText_.x = 4;
        this.tileText_.y = 36;
        addChild(this.tileText_);
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }
    private var graphicsData_:Vector.<IGraphicsData>;
    private var map_:MapCanvas;
    private var positionText_:SimpleText;
    private var tileText_:SimpleText;
    private var outlineFill_:GraphicsSolidFill;
    private var outlineStroke_:GraphicsStroke;
    private var backgroundFill_:GraphicsSolidFill;
    private var path_:GraphicsPath;

    private function drawBackground():void {
        GraphicHelper._0L_6(this.path_);
        GraphicHelper.drawUI(0, 0, WIDTH, HEIGHT, 4, [1, 1, 1, 1], this.path_);
        graphics.drawGraphicsData(this.graphicsData_);
    }

    private function onAddedToStage(event:Event):void {
        addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onRemovedFromStage(event:Event):void {
        removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onEnterFrame(event:Event):void {
        var selection:Rectangle = this.map_.getSelection();
        this.positionText_.text = (((("Position: " + selection.x) + ", ") + selection.y));
        if (((selection.width > 1) || (selection.height > 1))) {
            this.positionText_.text = (this.positionText_.text + (((("\nRect: " + selection.width) + ", ") + selection.height)));
        }
        this.positionText_._08S_();
        var tile:MapTile = this.map_.getTile(selection.x, selection.y);
        var types:Vector.<int> = ((tile == null) ? MapLayer.EMPTY_TYPES : tile.types_);
        var groundName:String = ((types[MapLayer.GROUND] == -1) ? "None" : GroundLibrary.getIdFromType(types[MapLayer.GROUND]));
        var objectName:String = ((types[MapLayer.OBJECT] == -1) ? "None" : ObjectLibrary.getIdFromType(types[MapLayer.OBJECT]));
        var regionName:String = ((types[MapLayer.REGION] == -1) ? "None" : RegionLibrary.getIdFromType(types[MapLayer.REGION]));
        var customName:String = (((tile == null) || (tile.objectName_ == null)) ? "" : ((" (" + tile.objectName_) + ")"));
        this.tileText_.text = ((((((((("<span class='in'>" + "Ground: ") + groundName) + "\nObject: ") + objectName) + customName) + "\nRegion: ") + regionName) + "</span>"));
        this.tileText_._08S_();
    }

}
}
