package mapeditor {
import client.events.ClientUpdateEvent;
import client.events.DeathEvent;
import client.events.ReconnectEvent;

import com.company.assembleegameclient.appengine.Server_list;
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.parameters.Parameters;

import flash.display.Sprite;
import flash.events.Event;

/**
 * Top-level container: shows the MapEditor, and swaps it for a GameSprite
 * (in editor mode) while a map is being tested.
 */
public class MapEditorScreen extends Sprite {

    public function MapEditorScreen() {
        this.editor_ = new MapEditor();
        this.editor_.addEventListener(MapTestEvent.MAP_TEST_EVENT, this.onMapTest);
        addChild(this.editor_);
    }
    private var serverList_:Server_list;
    private var editor_:MapEditor;
    private var testGame_:GameSprite;

    public function initialize(serverList:Server_list):void {
        this.serverList_ = serverList;
    }

    private function onMapTest(event:MapTestEvent):void {
        removeChild(this.editor_);
        this.testGame_ = new GameSprite(this.serverList_._04D_(), Parameters.TEST_ID, false, this.serverList_.savedChars_[0].charId(), -1, null, this.serverList_, event.mapJson_);
        this.testGame_.isEditor = true;
        this.testGame_.addEventListener(Event.COMPLETE, this.onTestGameEnded);
        this.testGame_.addEventListener(ReconnectEvent.RECONNECT, this.onTestGameEnded);
        this.testGame_.addEventListener(DeathEvent.DEATH, this.onTestGameEnded);
        this.testGame_.addEventListener(ClientUpdateEvent.CLIENT_UPDATE, this.onTestGameEnded);
        addChild(this.testGame_);
    }

    /** Test finished (completed, reconnect, death or client update): go back to the editor. */
    private function onTestGameEnded(event:Event):void {
        this.closeTestGame();
        addChild(this.editor_);
    }

    private function closeTestGame():void {
        this.testGame_.removeEventListener(Event.COMPLETE, this.onTestGameEnded);
        this.testGame_.removeEventListener(ReconnectEvent.RECONNECT, this.onTestGameEnded);
        this.testGame_.removeEventListener(DeathEvent.DEATH, this.onTestGameEnded);
        this.testGame_.removeEventListener(ClientUpdateEvent.CLIENT_UPDATE, this.onTestGameEnded);
        removeChild(this.testGame_);
        this.testGame_ = null;
    }

}
}
