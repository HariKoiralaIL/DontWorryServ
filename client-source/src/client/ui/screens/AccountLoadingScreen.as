package client.ui.screens {
import account.Account;

import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.Event;
import flash.filters.DropShadowFilter;
import flash.text.TextFieldAutoSize;

import signals.Signal;

/** "Loading..." label that loads the account as soon as it reaches the stage. */
public class AccountLoadingScreen extends Sprite {

    /** Dispatched once Account.load has completed. */
    public var accountLoaded:Signal;

    private var loadingText:SimpleText;

    public function AccountLoadingScreen() {
        super();
        this.loadingText = new SimpleText(30, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.loadingText.setBold(true);
        this.loadingText.htmlText = '<p align="center">Loading...</p>';
        this.loadingText.autoSize = TextFieldAutoSize.CENTER;
        this.loadingText.updateMetrics();
        this.loadingText.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4)];
        addChild(this.loadingText);
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        this.accountLoaded = new Signal();
    }

    private function loadAccount():void {
        Account.load(stage, this.onAccountLoaded);
    }

    private function onAccountLoaded():void {
        this.accountLoaded.dispatch();
    }

    protected function onAddedToStage(event:Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        this.loadingText.x = ((800 / 2) - (this.loadingText.width / 2));
        this.loadingText.y = 524;
        this.loadAccount();
    }

}
}
