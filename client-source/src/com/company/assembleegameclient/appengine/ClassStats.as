package com.company.assembleegameclient.appengine {
import com.company.assembleegameclient.util._Z_B_;

public class ClassStats {

    public var xml_:XML;

    public function ClassStats(xml:XML) {
        this.xml_ = xml;
    }

    public function bestLevel():int {
        return int(this.xml_.BestLevel);
    }

    public function bestFame():int {
        return int(this.xml_.BestFame);
    }

    public function numStars():int {
        return _Z_B_._lr(this.bestFame());
    }

}
}
