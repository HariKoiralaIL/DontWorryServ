package services {

import flash.events.TimerEvent;
import flash.utils.Timer;

import com.company.assembleegameclient.appengine.CharListEvent;
import com.company.assembleegameclient.appengine.CharacterClient;

import account.Account;
import env.ServerListState;

import client.tasks.Task;
import game.signals.StringSignal2;
import events.TextErrorEvent;

/**
 * Task that requests the account's server/character list and stores it in
 * the ServerListState. On errors it keeps retrying every second; when the
 * server says the credentials are invalid, the cached account is cleared
 * first and the request is repeated immediately.
 *
 * NOTE: the base class _zU_ provides startTask() and the completion method
 * _C_t(success, errorText); both keep their obfuscated names for now.
 */
public class LoadCharacterListTask extends Task {

    private static const RETRY_DELAY_MS:int = 1000;
    private static const OFFLINE_MESSAGE:String = '<p align="center">Server is currently offline...</p>';
    private static const INVALID_CREDENTIALS_ERROR:String = "Account credentials not valid";

    [Inject]
    public var serverListState:ServerListState;
    [Inject]
    public var messageSignal:StringSignal2;

    private var retryTimer:Timer;
    private var client:CharacterClient;

    override protected function startTask():void {
        this.client = new CharacterClient();
        this.client.addEventListener(TextErrorEvent.TEXT_ERROR, this.handleError);
        this.client.addEventListener(CharListEvent.SAVED_CHARS_LIST, this.handleListLoaded);
        this.requestList();
    }

    private function requestList():void {
        this.client.requestCharList();
    }

    private function clearAccountAndRetry():void {
        Account.getInstance().clear();
        this.requestList();
    }

    private function startRetryTimer():void {
        this.retryTimer = new Timer(RETRY_DELAY_MS, 1);
        this.retryTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.handleRetryTimer);
        this.retryTimer.start();
    }

    private function stopRetryTimer():void {
        this.retryTimer.stop();
        this.retryTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.handleRetryTimer);
        this.retryTimer = null;
    }

    private function handleError(event:TextErrorEvent):void {
        this.messageSignal.dispatch(OFFLINE_MESSAGE);
        if (event.text == INVALID_CREDENTIALS_ERROR) {
            this.clearAccountAndRetry();
        } else {
            this.startRetryTimer();
        }
    }

    private function handleRetryTimer(event:TimerEvent):void {
        this.requestList();
    }

    private function handleListLoaded(list:CharListEvent):void {
        this.serverListState.servers = new CharListEvent(list.xml_);
        this.serverListState.enabled = false;
        complete(true);
        if (this.retryTimer != null) {
            this.stopRetryTimer();
        }
    }

}
}
