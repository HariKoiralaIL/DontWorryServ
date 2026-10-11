package client.ui.panels {
import com.company.assembleegameclient.game.GameSprite;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

/**
 * A ButtonPanel whose action can also be triggered with the interact key.
 * Subclasses implement onInteract(); the button click calls it too.
 */
public class InteractButtonPanel extends ButtonPanel {

    public function InteractButtonPanel(gs:GameSprite, title:String, buttonLabel:String) {
        super(gs, title, buttonLabel);
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    protected function onInteract():void {
    }

    override protected function onButtonClick(event:MouseEvent):void {
        this.onInteract();
    }

    protected function onAddedToStage(event:Event):void {
        stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
    }

    protected function onRemovedFromStage(event:Event):void {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
    }

    private function onKeyDown(event:KeyboardEvent):void {
        if (PanelUtil.isInteractKey(event)) {
            this.onInteract();
        }
    }
}
}
