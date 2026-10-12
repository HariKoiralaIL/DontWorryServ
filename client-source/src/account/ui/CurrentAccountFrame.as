package account.ui {
import account.Account;

import client.ui.frames.Frame;

import com.company.assembleegameclient.appengine.AppEngineClient;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.TextButton;
import com.company.ui.SimpleText;

import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import events.GenericDataEvent;
import events.TextErrorEvent;

internal class CurrentAccountFrame extends Frame {

    public var loggedInLabel:SimpleText;
    public var guidText:SimpleText;
    public var resendVerifyButton:TextButton;
    public var changePasswordButton:TextButton;
    public var notYouButton:TextButton;

    public function CurrentAccountFrame(accountXml:XML) {
        super("Current account", "", "Continue", "/currentLogin");
        var emailVerified:Boolean = accountXml.hasOwnProperty("VerifiedEmail");
        loggedInLabel = new SimpleText(18, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        loggedInLabel.setBold(true);
        loggedInLabel.text = "Currently logged in as:";
        loggedInLabel.updateMetrics();
        loggedInLabel.filters = [new DropShadowFilter(0, 0, 0)];
        loggedInLabel.y = h_ - 60;
        loggedInLabel.x = 17;
        addChild(loggedInLabel);
        guidText = new SimpleText(16, 0xB3B3B3, false, 238, 30, "Myriad Pro");
        guidText.text = Account.getInstance().guid();
        guidText.updateMetrics();
        guidText.y = h_ - 30;
        guidText.x = 17;
        addChild(guidText);
        h_ += 88;
        if (!emailVerified) {
            resendVerifyButton = new TextButton(12, false, "Email not verified.  Click here to resend email.");
            addLinkButton(resendVerifyButton);
            resendVerifyButton.addEventListener(MouseEvent.CLICK, onResendVerify);
        }
        changePasswordButton = new TextButton(12, false, "Click here to change password");
        addLinkButton(changePasswordButton);
        notYouButton = new TextButton(12, false, "Not you?  Click here");
        addLinkButton(notYouButton);
        Button2.addEventListener(MouseEvent.CLICK, onContinue);
        changePasswordButton.addEventListener(MouseEvent.CLICK, onChangePassword);
        notYouButton.addEventListener(MouseEvent.CLICK, onNotYou);
    }

    public function onChangePassword(event:MouseEvent):void {
        dispatchEvent(new AccountFrameEvent(AccountFrameEvent.CHANGE));
    }

    public function onNotYou(event:MouseEvent):void {
        Account.getInstance().clear();
        dispatchEvent(new AccountFrameEvent(AccountFrameEvent.SIGN_IN));
    }

    private function onResendVerify(event:MouseEvent):void {
        var request:AppEngineClient = new AppEngineClient(Parameters._fK_(), "/account", true);
        request.addEventListener(GenericDataEvent.GENERIC_DATA, onVerifySent);
        request.addEventListener(TextErrorEvent.TEXT_ERROR, onVerifyError);
        request.sendRequest("sendVerifyEmail", Account.getInstance().credentials());
        resendVerifyButton._bu("Sent...");
    }

    private function onVerifySent(event:GenericDataEvent):void {
    }

    private function onVerifyError(event:TextErrorEvent):void {
        Account.getInstance().clear();
        dispatchEvent(new AccountFrameEvent(AccountFrameEvent.SIGN_IN));
    }

    private function onContinue(event:MouseEvent):void {
        dispatchEvent(new AccountFrameEvent(AccountFrameEvent.DONE));
    }

}
}
