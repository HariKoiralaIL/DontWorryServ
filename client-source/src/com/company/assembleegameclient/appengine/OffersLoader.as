package com.company.assembleegameclient.appengine {
import account.Account;

import com.company.assembleegameclient.parameters.Parameters;
import com.company.util._H_U_;

import events.GenericDataEvent;

import flash.utils.getTimer;

public class OffersLoader {

    private static const SESSION_TIMEOUT_MS:int = 5 * 60 * 1000;
    private static const MAX_RETRIES:int = 2;

    private static var sessionStart:int = -SESSION_TIMEOUT_MS;
    private static var lastGuid:String = null;

    public static function load(path:String, callback:Function):void {
        var acct:Account = Account.getInstance();
        var guid:String = acct.guid();
        var now:int = getTimer();
        if (guid != lastGuid || now - sessionStart > SESSION_TIMEOUT_MS) {
            lastGuid = guid;
            sessionStart = now;
        }
        var client:AppEngineClient = new AppEngineClient(Parameters._fK_(), path, true, MAX_RETRIES);
        if (callback != null) {
            client.addEventListener(GenericDataEvent.GENERIC_DATA, callback);
        }
        var params:Object = {
            "time": sessionStart,
            "game_net_user_id": acct.gameNetworkUserId(),
            "game_net": acct.gameNetwork(),
            "play_platform": acct.playPlatform()
        };
        _H_U_._t2(params, acct.credentials());
        client.sendRequest("getoffers", params);
    }

}
}
