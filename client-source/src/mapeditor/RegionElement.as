package mapeditor {
import com.company.assembleegameclient.map.RegionLibrary;
import com.company.assembleegameclient.ui.tooltip.ToolTip;

import flash.display.Shape;

public class RegionElement extends ChooserElement {

    public function RegionElement(regionXml:XML) {
        super(int(regionXml.@type));
        this.regionXml_ = regionXml;
        var swatch:Shape = new Shape();
        swatch.graphics.beginFill(RegionLibrary.getColor(type_), 0.5);
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
}
