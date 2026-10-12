package account.ui {
import account.Account;

import client.ui.frames.Frame;

import com.company.assembleegameclient.appengine.AppEngineClient;
import com.company.assembleegameclient.parameters.Parameters;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;

import events.GenericDataEvent;
import events.TextErrorEvent;

public class AccountOverlay extends Sprite {

    private var currentFrame:Frame = null;
    private var verifyRequest:AppEngineClient = null;
    private var background:Shape;

    public function AccountOverlay(showSignIn:Boolean) {
        background = new Shape();
        var g:Graphics = background.graphics;
        g.clear();
        g.beginFill(0, 0.8);
        g.drawRect(0, 0, 800, 600);
        g.endFill();
        addChild(background);
        if (showSignIn) {
            showFrame(new SignInFrame());
        } else {
            start();
        }
    }

    private function start():void {
        if (!Account.getInstance().isRegistered()) {
            register();
        } else {
            verifyCredentials();
        }
    }

    private function verifyCredentials():void {
        removeCurrentFrame();
        verifyRequest = new AppEngineClient(Parameters.serverAddress(), "/account", true);
        verifyRequest.addEventListener(GenericDataEvent.GENERIC_DATA, onVerified);
        verifyRequest.addEventListener(TextErrorEvent.TEXT_ERROR, onVerifyError);
        verifyRequest.sendRequest("verify", Account.getInstance().credentials());
    }

    private function register():void {
        showFrame(new RegisterFrame());
    }

    private function showFrame(frame:Frame):void {
        removeCurrentFrame();
        frame.addEventListener(AccountFrameEvent.DONE, onDone);
        frame.addEventListener(AccountFrameEvent.CURRENT, onCurrent);
        frame.addEventListener(AccountFrameEvent.REGISTER, onRegister);
        frame.addEventListener(AccountFrameEvent.SIGN_IN, onSignIn);
        frame.addEventListener(AccountFrameEvent.FORGOT, onForgot);
        frame.addEventListener(AccountFrameEvent.CHANGE, onChange);
        addChild(frame);
        currentFrame = frame;
    }

    private function removeCurrentFrame():void {
        if (currentFrame != null && contains(currentFrame)) {
            removeChild(currentFrame);
        }
    }

    private function onVerified(event:GenericDataEvent):void {
        showFrame(new CurrentAccountFrame(XML(event.data)));
    }

    private function onVerifyError(event:TextErrorEvent):void {
        Account.getInstance().clear();
        showFrame(new SignInFrame());
    }

    private function onDone(event:AccountFrameEvent):void {
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function onCurrent(event:AccountFrameEvent):void {
        verifyCredentials();
    }

    private function onRegister(event:AccountFrameEvent):void {
        showFrame(new RegisterFrame());
    }

    private function onSignIn(event:AccountFrameEvent):void {
        showFrame(new SignInFrame());
    }

    private function onForgot(event:AccountFrameEvent):void {
        showFrame(new ForgotPasswordFrame());
    }

    private function onChange(event:AccountFrameEvent):void {
        showFrame(new ChangePasswordFrame());
    }

}
}
