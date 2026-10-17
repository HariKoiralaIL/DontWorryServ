package com.company.assembleegameclient.appengine {
import account.Account;

import com.company.assembleegameclient.parameters.Parameters;
import com.company.util.PropertyUtil;

import events.GenericDataEvent;

import flash.events.Event;

public class CharacterClient extends AppEngineClient {

    private static const DELETE_REASON:int = 1;

    public function CharacterClient(maxRetries:int = 0) {
        super(Parameters.serverAddress(), "/char", true, maxRetries);
    }

    public function requestCharList():void {
        addEventListener(GenericDataEvent.GENERIC_DATA, this.onCharListLoaded);
        var acct:Account = Account.getInstance();
        var params:Object = {
            "game_net_user_id": acct.gameNetworkUserId(),
            "game_net": acct.gameNetwork(),
            "play_platform": acct.playPlatform(),
            "do_login": Parameters._hk
        };
        PropertyUtil.copyProperties(params, acct.credentials());
        sendRequest("list", params);
        Parameters._hk = false;
    }

    public function deleteCharacter(charId:int):void {
        addEventListener(GenericDataEvent.GENERIC_DATA, this.onDeleteComplete);
        var params:Object = {
            "charId": charId,
            "reason": DELETE_REASON
        };
        PropertyUtil.copyProperties(params, Account.getInstance().credentials());
        sendRequest("delete", params);
    }

    private function onCharListLoaded(event:GenericDataEvent):void {
        dispatchEvent(new CharListEvent(event.data.toString()));
    }

    private function onDeleteComplete(event:GenericDataEvent):void {
        dispatchEvent(new Event(Event.COMPLETE));
    }

}
}
