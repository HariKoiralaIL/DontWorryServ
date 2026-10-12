package account.ui {
import client.ui.frames.Frame;
import client.ui.frames.TextInput;

import com.company.assembleegameclient.appengine.AppEngineClient;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.TextButton;
import com.company.util._H_V_;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import events.GenericDataEvent;
import events.TextErrorEvent;

internal class ForgotPasswordFrame extends Frame {

    public var emailInput:TextInput;
    public var registerButton:TextButton;
    public var emailPattern:RegExp = /(^[a-zA-Z0-9_\.-]+@[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[a-zA-Z]{2,6})/;

    public function ForgotPasswordFrame() {
        super("Forgot your password?  We'll email it.", "Cancel", "Submit", "/forgotPassword");
        emailInput = new TextInput("Email", false, "");
        addInput(emailInput);
        registerButton = new TextButton(12, false, "New user?  Click here to Register");
        addLinkButton(registerButton);
        Button1.addEventListener(MouseEvent.CLICK, onCancel);
        Button2.addEventListener(MouseEvent.CLICK, onSubmit);
        registerButton.addEventListener(MouseEvent.CLICK, onRegisterClick);
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
    }

    private function onCancel(event:MouseEvent):void {
        dispatchEvent(new AccountFrameEvent(AccountFrameEvent.SIGN_IN));
    }

    private function onSubmit(event:MouseEvent):void {
        if (!emailPattern.test(emailInput.text())) {
            emailInput.setError("Not a valid email address");
            return;
        }
        var request:AppEngineClient = new AppEngineClient(Parameters._fK_(), "/account", true);
        request.addEventListener(GenericDataEvent.GENERIC_DATA, onSent);
        request.addEventListener(TextErrorEvent.TEXT_ERROR, onError);
        request.sendRequest("forgotPassword", {"email": emailInput.text()});
        disableInput();
    }

    private function onSent(event:GenericDataEvent):void {
        dispatchEvent(new AccountFrameEvent(AccountFrameEvent.SIGN_IN));
    }

    private function onError(event:TextErrorEvent):void {
        emailInput.setError(event.text);
        enableInput();
    }

    private function onRegisterClick(event:MouseEvent):void {
        dispatchEvent(new AccountFrameEvent(AccountFrameEvent.REGISTER));
    }

    private function onAdded(event:Event):void {
        addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
    }

    private function onRemoved(event:Event):void {
        removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
    }

    private function onKeyPressed(event:KeyboardEvent):void {
        if (event.keyCode == _H_V_.ENTER) {
            onSubmit(null);
        }
    }

}
}
