package mapeditor {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.ui.tooltip.ToolTip;

import flash.display.Bitmap;
import flash.display.BitmapData;

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
}
