package mapeditor {

public class RegionToolTip extends ChooserToolTip {

    public function RegionToolTip(regionXml:XML) {
        super(0x363636, String(regionXml.@id));
    }
}
}
