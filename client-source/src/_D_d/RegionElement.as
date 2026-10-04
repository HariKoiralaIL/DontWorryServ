// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_D_d.RegionElement

package _D_d {
import flash.display.Shape;

import com.company.assembleegameclient.map._sn;

import com.company.assembleegameclient.ui.tooltip.ToolTip;

public class RegionElement extends ChooserElement {

    public function RegionElement(regionXml:XML) {
        super(int(regionXml.@type));
        this.regionXml_ = regionXml;
        var swatch:Shape = new Shape();
        swatch.graphics.beginFill(_sn.getColor(type_), 0.5);
        swatch.graphics.drawRect(0, 0, (WIDTH - 8), (HEIGHT - 8));
        swatch.graphics.endFill();
        swatch.x = ((WIDTH / 2) - (swatch.width / 2));
        swatch.y = ((HEIGHT / 2) - (swatch.height / 2));
        addChild(swatch);
    }
    public var regionXml_:XML;

    override protected function getToolTip():ToolTip {
        return (new RegionToolTip(this.regionXml_));
    }

}
}//package _D_d

