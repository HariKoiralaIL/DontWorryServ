// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_D_d._4g

package _D_d {
import com.company.assembleegameclient.map._sn;

public class _4g extends _E_m {

    public function _4g() {
        var _local1:XML;
        var _local2:RegionElement;
        super(MapLayer.REGION);
        for each (_local1 in _sn._Q_F_) {
            _local2 = new RegionElement(_local1);
            _08M_(_local2);
        }
    }
}
}//package _D_d

