package mapeditor {
import com.company.assembleegameclient.map.GroundLibrary;
import com.company.util._L_2;

internal class GroundChooser extends Chooser {

    public function GroundChooser() {
        var id:String;
        var type:int;
        super(MapLayer.GROUND);
        var sortedIds:Vector.<String> = new Vector.<String>();
        for (id in GroundLibrary.idToType_) {
            sortedIds.push(id);
        }
        sortedIds.sort(_L_2._L_O_);
        for each (id in sortedIds) {
            type = GroundLibrary.idToType_[id];
            addElement(new GroundElement(GroundLibrary.xmlLibrary_[type]));
        }
    }
}
}
