package account.ui {
import account.Account;

import client.ui.frames.CheckBoxInput;
import client.ui.frames.Frame;
import client.ui.frames.TextInput;

import com.company.assembleegameclient.appengine._0B_u;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.TextButton;
import com.company.util._9S_;
import com.company.util._H_V_;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import events.GenericDataEvent;
import events.TextErrorEvent;

internal class RegisterFrame extends Frame {

    public var usernameInput:TextInput;
    public var emailInput:TextInput;
    public var passwordInput:TextInput;
    public var confirmPasswordInput:TextInput;
    public var termsCheckbox:CheckBoxInput;
    public var signInButton:TextButton;

    public function RegisterFrame(showSignIn:Boolean = true) {
        super("Register in order to save your progress", "Cancel", "Register", "/registerAccount");
        usernameInput = new TextInput("Username", false, "");
        addInput(usernameInput);
        emailInput = new TextInput("Email", false, "");
        addInput(emailInput);
        passwordInput = new TextInput("Password", true, "");
        addInput(passwordInput);
        confirmPasswordInput = new TextInput("Retype Password", true, "");
        addInput(confirmPasswordInput);
        termsCheckbox = new CheckBoxInput('I agree to the <font color="#7777EE"><a href="' + Parameters.ToS_Url_ + '" target="_blank">Terms of Use</a></font>.', false, "");
        addCheckBox(termsCheckbox);
        if (showSignIn) {
            signInButton = new TextButton(12, false, "Already Registered?  Click here to Sign In");
            addLinkButton(signInButton);
        }
        Button1.addEventListener(MouseEvent.CLICK, onCancel);
        Button2.addEventListener(MouseEvent.CLICK, onRegister);
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
        if (showSignIn) {
            signInButton.addEventListener(MouseEvent.CLICK, onSignInClick);
        }
    }

    private function onCancel(event:MouseEvent):void {
        dispatchEvent(new AccountFrameEvent(AccountFrameEvent.DONE));
    }

    private function onRegister(event:MouseEvent):void {
        if (!_9S_._02A_(usernameInput.text())) {
            usernameInput.setError("Not a valid username");
            return;
        }
        if (!_9S_.isEmail(emailInput.text())) {
            emailInput.setError("Not a valid email address");
            return;
        }
        if (passwordInput.text().length < 5) {
            passwordInput.setError("Password too short");
            return;
        }
        if (passwordInput.text() != confirmPasswordInput.text()) {
            confirmPasswordInput.setError("Password does not match");
            return;
        }
        if (!termsCheckbox.isChecked()) {
            termsCheckbox.setError("Must agree to register");
            return;
        }
        var request:_0B_u = new _0B_u(Parameters._fK_(), "/account", true);
        request.addEventListener(GenericDataEvent.GENERIC_DATA, onRegisterSuccess);
        request.addEventListener(TextErrorEvent.TEXT_ERROR, onRegisterError);
        request.sendRequest("register", {
            "guid": Account.getInstance().guid(),
            "newGUID": usernameInput.text(),
            "email": emailInput.text(),
            "newPassword": passwordInput.text(),
            "entrytag": Account.getInstance().entrytag()
        });
        disableInput();
    }

    private function onRegisterSuccess(event:GenericDataEvent):void {
        Account.getInstance().modify(usernameInput.text(), passwordInput.text(), null);
        dispatchEvent(new AccountFrameEvent(AccountFrameEvent.CURRENT));
    }

    private function onRegisterError(event:TextErrorEvent):void {
        usernameInput.setError(event.text);
        enableInput();
    }

    private function onSignInClick(event:MouseEvent):void {
        dispatchEvent(new AccountFrameEvent(AccountFrameEvent.SIGN_IN));
    }

    private function onAdded(event:Event):void {
        addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
    }

    private function onRemoved(event:Event):void {
        removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
    }

    private function onKeyPressed(event:KeyboardEvent):void {
        if (event.keyCode == _H_V_.ENTER) {
            onRegister(null);
        }
    }

}
}
