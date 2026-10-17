package client.ui.panels {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.ui.RoundedButton;
import com.company.ui.SimpleText;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

/**
 * Base for "someone asked you something" panels: Reject / Accept buttons and
 * a 20 second timeout. Dispatches Event.COMPLETE when the request is answered
 * or times out. Subclasses add their text with addLine() and override onAccept().
 */
public class InvitePanel extends Panel {

    private static const TIMEOUT_MS:int = 20 * 1000;

    private var rejectButton:RoundedButton;
    private var acceptButton:RoundedButton;
    private var timeoutTimer:Timer;

    public function InvitePanel(gs:GameSprite) {
        super(gs);
        this.rejectButton = new RoundedButton(16, "Reject");
        this.rejectButton.addEventListener(MouseEvent.CLICK, this.onRejectClick);
        this.rejectButton.x = (WIDTH / 4) - (this.rejectButton.width / 2);
        this.rejectButton.y = (HEIGHT - this.rejectButton.height) - 4;
        addChild(this.rejectButton);
        this.acceptButton = new RoundedButton(16, "Accept");
        this.acceptButton.addEventListener(MouseEvent.CLICK, this.onAcceptClick);
        this.acceptButton.x = ((3 * WIDTH) / 4) - (this.acceptButton.width / 2);
        this.acceptButton.y = (HEIGHT - this.acceptButton.height) - 4;
        addChild(this.acceptButton);
        this.timeoutTimer = new Timer(TIMEOUT_MS, 1);
        this.timeoutTimer.addEventListener(TimerEvent.TIMER, this.onTimeout);
        this.timeoutTimer.start();
    }

    /** Called when the player presses Accept. */
    protected function onAccept():void {
    }

    /** Adds a text line behind the buttons. */
    protected function addLine(text:SimpleText, y:Number):void {
        text.y = y;
        addChildAt(text, 0);
    }

    private function onTimeout(event:TimerEvent):void {
        this.finish();
    }

    private function onRejectClick(event:MouseEvent):void {
        this.finish();
    }

    private function onAcceptClick(event:MouseEvent):void {
        this.onAccept();
        this.finish();
    }

    private function finish():void {
        this.timeoutTimer.stop();
        this.timeoutTimer.removeEventListener(TimerEvent.TIMER, this.onTimeout);
        dispatchEvent(new Event(Event.COMPLETE));
    }
}
}
