package client.ui.panels {
import com.company.assembleegameclient.game.GameSprite;

import flash.events.Event;
import flash.events.MouseEvent;

public class ChangeCharactersPanel extends ButtonPanel {

    public function ChangeCharactersPanel(gs:GameSprite) {
        super(gs, "Change Characters", "Change");
    }

    override protected function onButtonClick(event:MouseEvent):void {
        gs_.dispatchEvent(new Event(Event.COMPLETE));
    }
}
}
