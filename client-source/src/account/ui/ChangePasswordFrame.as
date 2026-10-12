package account.ui {
import account.Account;

import client.ui.frames.Frame;
import client.ui.frames.TextInput;

import com.company.assembleegameclient.appengine.AppEngineClient;
import com.company.assembleegameclient.parameters.Parameters;

import flash.events.MouseEvent;

import events.GenericDataEvent;
import events.TextErrorEvent;

internal class ChangePasswordFrame extends Frame {

    public var currentPasswordInput:TextInput;
    public var newPasswordInput:TextInput;
    public var confirmPasswordInput:TextInput;

    public function ChangePasswordFrame() {
        super("Change your password", "Cancel", "Submit", "/changePassword");
        currentPasswordInput = new TextInput("Password", true, "");
        addInput(currentPasswordInput);
        newPasswordInput = new TextInput("New Password", true, "");
        addInput(newPasswordInput);
        confirmPasswordInput = new TextInput("Retype New Password", true, "");
        addInput(confirmPasswordInput);
        Button1.addEventListener(MouseEvent.CLICK, onCancel);
        Button2.addEventListener(MouseEvent.CLICK, onSubmit);
    }

    private function onCancel(event:MouseEvent):void {
        dispatchEvent(new AccountFrameEvent(AccountFrameEvent.CURRENT));
    }

    private function onSubmit(event:MouseEvent):void {
        if (currentPasswordInput.text().length < 5) {
            currentPasswordInput.setError("Incorrect password");
            return;
        }
        if (newPasswordInput.text().length < 5) {
            newPasswordInput.setError("Password too short");
            return;
        }
        if (newPasswordInput.text() != confirmPasswordInput.text()) {
            confirmPasswordInput.setError("Password does not match");
            return;
        }
        var request:AppEngineClient = new AppEngineClient(Parameters.serverAddress(), "/account", true);
        request.addEventListener(GenericDataEvent.GENERIC_DATA, onChanged);
        request.addEventListener(TextErrorEvent.TEXT_ERROR, onError);
        request.sendRequest("changePassword", {
            "guid": Account.getInstance().guid(),
            "password": currentPasswordInput.text(),
            "newPassword": newPasswordInput.text()
        });
        disableInput();
    }

    private function onChanged(event:GenericDataEvent):void {
        Account.getInstance().modify(Account.getInstance().guid(), newPasswordInput.text(), null);
        dispatchEvent(new AccountFrameEvent(AccountFrameEvent.CURRENT));
    }

    private function onError(event:TextErrorEvent):void {
        currentPasswordInput.setError(event.text);
        enableInput();
    }

}
}
