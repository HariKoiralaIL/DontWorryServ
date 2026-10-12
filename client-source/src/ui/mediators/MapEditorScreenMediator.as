package ui.mediators {
import env.ServerListState;

import mapeditor.MapEditorScreen;

import robotlegs.bender.bundles.mvcs.Mediator;

/** Mediator for the map editor screen. */
public class MapEditorScreenMediator extends Mediator {

    [Inject]
    public var view:MapEditorScreen;
    [Inject]
    public var serverList:ServerListState;

    override public function initialize():void {
        this.view.initialize(this.serverList.servers);
    }

}
}
