// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_D_d.GroundElement

package _D_d {
import _D_d.ChooserElement;

import flash.display.Shape;
import flash.display.IGraphicsData;

import com.company.assembleegameclient.map._0D_v;

import flash.geom.Rectangle;

import com.company.assembleegameclient.map._pf;

import flash.display.BitmapData;

import com.company.assembleegameclient.map._ik;
import com.company.assembleegameclient.map._M_X_;

import _D_d.GroundToolTip;

import com.company.assembleegameclient.ui.tooltip.ToolTip;

import _D_d.*;

internal class GroundElement extends ChooserElement {

    private static const UV_COORDS:Vector.<Number> = new <Number>[0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0];
    private static const PREVIEW_SCALE:Number = 0.6;

    public function GroundElement(groundXml:XML) {
        super(int(groundXml.@type));
        this.groundXml_ = groundXml;
        var graphicsData:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
        var camera:_0D_v = new _0D_v();
        camera._K_(0.5, 0.5, 12, (Math.PI / 4), new Rectangle(-100, -100, 200, 200), false);
        var texture:BitmapData = _pf.getBitmapData(type_);
        var squareFace:_ik = new _ik(texture, UV_COORDS, 0, 0, _M_X_._0I_7, 0, 0);
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
}//package _D_d

