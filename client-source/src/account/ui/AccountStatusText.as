package account.ui {
import account.Account;
import account.AccountTextEvent;
import account.AccountTextView;

import com.company.ui.SimpleText;

import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import client.ui.screens.MenuButton;

public class AccountStatusText extends AccountTextView {

    private static const FONT_SIZE:int = 18;

    private var statusText:SimpleText = null;
    private var primaryLink:MenuButton = null;
    private var separatorText:SimpleText = null;
    private var secondaryLink:MenuButton = null;

    public function AccountStatusText() {
        refresh();
    }

    override public function refresh():void {
        removeParts();
        statusText = new SimpleText(FONT_SIZE, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        if (!Account.getInstance().isRegistered()) {
            statusText.text = "guest account - ";
            primaryLink = new MenuButton("register", FONT_SIZE, false);
            primaryLink.addEventListener(MouseEvent.CLICK, onRegisterClick);
            secondaryLink = new MenuButton("log in", FONT_SIZE, false);
            secondaryLink.addEventListener(MouseEvent.CLICK, onLogInClick);
        } else {
            statusText.text = "logged in as " + Account.getInstance().guid() + " - ";
            primaryLink = new MenuButton("log out", FONT_SIZE, false);
            primaryLink.addEventListener(MouseEvent.CLICK, onLogOutClick);
        }
        statusText.updateMetrics();
        statusText.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4)];
        addChild(statusText);
        primaryLink.x = width;
        addChild(primaryLink);
        if (secondaryLink != null) {
            separatorText = new SimpleText(FONT_SIZE, 0xB3B3B3, false, 0, 0, "Myriad Pro");
            separatorText.text = " - ";
            separatorText.x = width;
            separatorText.updateMetrics();
            separatorText.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4)];
            addChild(separatorText);
            secondaryLink.x = width;
            addChild(secondaryLink);
        }
    }

    private function removeParts():void {
        if (statusText != null) {
            removeChild(statusText);
            statusText = null;
        }
        if (primaryLink != null) {
            removeChild(primaryLink);
            primaryLink = null;
        }
        if (separatorText != null) {
            removeChild(separatorText);
            separatorText = null;
        }
        if (secondaryLink != null) {
            removeChild(secondaryLink);
            secondaryLink = null;
        }
    }

    private function onRegisterClick(event:MouseEvent):void {
        dispatchEvent(new AccountTextEvent(new AccountOverlay(false)));
    }

    private function onLogOutClick(event:MouseEvent):void {
        Account.getInstance().clear();
        dispatchEvent(new AccountTextEvent(null));
    }

    private function onLogInClick(event:MouseEvent):void {
        dispatchEvent(new AccountTextEvent(new AccountOverlay(true)));
    }

}
}
