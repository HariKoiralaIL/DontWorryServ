// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_zD_._B_9

package _zD_ {
import robotlegs.bender.bundles.mvcs.Mediator;

import com.company.assembleegameclient.ui.InvTabs;

public class _B_9 extends Mediator {

    public function _B_9() {
        this._06G_ = ["Apple", "Tortilla", "Chainsaw", "Monkey", "Flotilla", "Zephyr", "Ghost", "Tupac", "Alluvial", "Dante", "Soprano", "Godzilla", "Hate", "Freebird", "Desire", "Good", "Nightie", "Osprey"];
        super();
    }
    [Inject]
    public var view:InvTabs;
    private var name:String;
    private var _06G_:Array;

    override public function initialize():void {
    }

    override public function destroy():void {
        super.destroy();
    }

}
}//package _zD_

