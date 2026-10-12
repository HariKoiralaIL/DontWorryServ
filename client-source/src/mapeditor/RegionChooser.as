package mapeditor {
import com.company.assembleegameclient.map.RegionLibrary;

public class RegionChooser extends Chooser {

    public function RegionChooser() {
        var regionXml:XML;
        super(MapLayer.REGION);
        for each (regionXml in RegionLibrary.xmlLibrary_) {
            addElement(new RegionElement(regionXml));
        }
    }
}
}
