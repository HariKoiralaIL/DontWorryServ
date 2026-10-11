// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_zD_._0D_L_

package _zD_ {
import robotlegs.bender.bundles.mvcs.Mediator;

import mapeditor.MapEditorScreen;

import env.ServerListState;

public class _0D_L_ extends Mediator {

    [Inject]
    public var view:MapEditorScreen;
    [Inject]
    public var _0I_s:ServerListState;

    override public function initialize():void {
        this.view.initialize(this._0I_s.servers);
    }

}
}//package _zD_

