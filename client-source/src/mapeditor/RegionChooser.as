package mapeditor {
import com.company.assembleegameclient.map._sn;

public class RegionChooser extends Chooser {

    public function RegionChooser() {
        var regionXml:XML;
        super(MapLayer.REGION);
        for each (regionXml in _sn._Q_F_) {
            addElement(new RegionElement(regionXml));
        }
    }
}
}
