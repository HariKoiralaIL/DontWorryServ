// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_D_d.GroundChooser

package _D_d {
import _D_d.MapLayer;

import com.company.assembleegameclient.map._pf;
import com.company.util._L_2;

import _D_d.*;

internal class GroundChooser extends Chooser {

    public function GroundChooser() {
        var id:String;
        var type:int;
        var groundElement:GroundElement;
        super(MapLayer.GROUND);
        var sortedIds:Vector.<String> = new Vector.<String>();
        for (id in _pf._pb) {
            sortedIds.push(id);
        }
        sortedIds.sort(_L_2._L_O_);
        for each (id in sortedIds) {
            type = _pf._pb[id];
            groundElement = new GroundElement(_pf._Q_F_[type]);
            addElement(groundElement);
        }
    }
}
}//package _D_d

