package account.ui {
import account.Account;

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

internal class SignInFrame extends Frame {

    public var usernameInput:TextInput;
    public var passwordInput:TextInput;
    public var forgotButton:TextButton;
    public var registerButton:TextButton;

    public function SignInFrame() {
        super("Sign in", "Cancel", "Sign in", "/signIn");
        usernameInput = new TextInput("Username", false, "");
        addInput(usernameInput);
        passwordInput = new TextInput("Password", true, "");
        addInput(passwordInput);
        forgotButton = new TextButton(12, false, "Forgot your password?  Click here");
        addLinkButton(forgotButton);
        registerButton = new TextButton(12, false, "New user?  Click here to Register");
        addLinkButton(registerButton);
        Button1.addEventListener(MouseEvent.CLICK, onCancel);
        Button2.addEventListener(MouseEvent.CLICK, onSignIn);
        forgotButton.addEventListener(MouseEvent.CLICK, onForgotClick);
        registerButton.addEventListener(MouseEvent.CLICK, onRegisterClick);
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
    }

    private function onCancel(event:MouseEvent):void {
        dispatchEvent(new AccountFrameEvent(AccountFrameEvent.DONE));
    }

    private function onSignIn(event:MouseEvent):void {
        if (usernameInput.text() == "") {
            usernameInput.setError("Not a valid username");
            return;
        }
        if (passwordInput.text() == "") {
            passwordInput.setError("Password too short");
            return;
        }
        var request:AppEngineClient = new AppEngineClient(Parameters._fK_(), "/account", true);
        request.addEventListener(GenericDataEvent.GENERIC_DATA, onSignInSuccess);
        request.addEventListener(TextErrorEvent.TEXT_ERROR, onSignInError);
        request.sendRequest("verify", {
            "guid": usernameInput.text(),
            "password": passwordInput.text()
        });
        disableInput();
    }

    private function onSignInSuccess(event:GenericDataEvent):void {
        Account.getInstance().modify(usernameInput.text(), passwordInput.text(), null);
        dispatchEvent(new AccountFrameEvent(AccountFrameEvent.CURRENT));
    }

    private function onSignInError(event:TextErrorEvent):void {
        passwordInput.setError(event.text);
        enableInput();
    }

    private function onForgotClick(event:MouseEvent):void {
        dispatchEvent(new AccountFrameEvent(AccountFrameEvent.FORGOT));
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
            onSignIn(null);
        }
    }

}
}
