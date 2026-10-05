// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_D_d.RegionChooser

package _D_d {
import com.company.assembleegameclient.map._sn;

public class RegionChooser extends Chooser {

    public function RegionChooser() {
        var regionXml:XML;
        var regionElement:RegionElement;
        super(MapLayer.REGION);
        for each (regionXml in _sn._Q_F_) {
            regionElement = new RegionElement(regionXml);
            addElement(regionElement);
        }
    }
}
}//package _D_d

