// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_D_d.ObjectElement

package _D_d {
import _D_d.ChooserElement;

import com.company.assembleegameclient.objects.ObjectLibrary;

import flash.display.BitmapData;
import flash.display.Bitmap;

import _D_d.ObjectToolTip;

import com.company.assembleegameclient.ui.tooltip.ToolTip;

import _D_d.*;

internal class ObjectElement extends ChooserElement {

    public function ObjectElement(objectXml:XML) {
        super(int(objectXml.@type));
        this.objectXml_ = objectXml;
        var texture:BitmapData = ObjectLibrary.getRedrawnTextureFromType(type_, 100, true, false);
        var bitmap:Bitmap = new Bitmap(texture);
        var scale:Number = ((WIDTH - 4) / Math.max(bitmap.width, bitmap.height));
        bitmap.scaleX = (bitmap.scaleY = scale);
        bitmap.x = ((WIDTH / 2) - (bitmap.width / 2));
        bitmap.y = ((HEIGHT / 2) - (bitmap.height / 2));
        addChild(bitmap);
    }
    public var objectXml_:XML;

    override protected function getToolTip():ToolTip {
        return (new ObjectToolTip(this.objectXml_));
    }

}
}//package _D_d

