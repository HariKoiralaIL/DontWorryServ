package mapeditor {
import com.company.assembleegameclient.map.GameCamera;
import com.company.assembleegameclient.map.AnimateProperties;
import com.company.assembleegameclient.map.SquareFace;
import com.company.assembleegameclient.map.GroundLibrary;
import com.company.assembleegameclient.ui.tooltip.ToolTip;

import flash.display.BitmapData;
import flash.display.IGraphicsData;
import flash.display.Shape;
import flash.geom.Rectangle;

internal class GroundElement extends ChooserElement {

    private static const UV_COORDS:Vector.<Number> = new <Number>[0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0];
    private static const PREVIEW_SCALE:Number = 0.6;

    public function GroundElement(groundXml:XML) {
        super(int(groundXml.@type));
        this.groundXml_ = groundXml;
        var graphicsData:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
        var camera:GameCamera = new GameCamera();
        camera.configure(0.5, 0.5, 12, (Math.PI / 4), new Rectangle(-100, -100, 200, 200), false);
        var texture:BitmapData = GroundLibrary.getBitmapData(type_);
        var squareFace:SquareFace = new SquareFace(texture, UV_COORDS, 0, 0, AnimateProperties.NONE, 0, 0);
        squareFace.draw(graphicsData, camera, 0);
        this.preview_ = new Shape();
        this.preview_.graphics.drawGraphicsData(graphicsData);
        this.preview_.scaleX = (this.preview_.scaleY = PREVIEW_SCALE);
        this.preview_.x = (WIDTH / 2);
        this.preview_.y = (HEIGHT / 2);
        addChild(this.preview_);
    }
    public var groundXml_:XML;
    private var preview_:Shape;

    override protected function getToolTip():ToolTip {
        return (new GroundToolTip(this.groundXml_));
    }

}
}
