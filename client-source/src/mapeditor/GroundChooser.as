package mapeditor {
import com.company.assembleegameclient.map._pf;
import com.company.util._L_2;

internal class GroundChooser extends Chooser {

    public function GroundChooser() {
        var id:String;
        var type:int;
        super(MapLayer.GROUND);
        var sortedIds:Vector.<String> = new Vector.<String>();
        for (id in _pf._pb) {
            sortedIds.push(id);
        }
        sortedIds.sort(_L_2._L_O_);
        for each (id in sortedIds) {
            type = _pf._pb[id];
            addElement(new GroundElement(_pf._Q_F_[type]));
        }
    }
}
}
