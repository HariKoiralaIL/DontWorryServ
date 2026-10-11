// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.account.web.WebAccount

package com.company.assembleegameclient.account.web {
import account.Account;

import flash.external.ExternalInterface;
import flash.net.NetworkInterface;
import flash.net.SharedObject;

import com.company.assembleegameclient.util.GUID;

import flash.display.Stage;

import com.company.assembleegameclient.parameters.Parameters;

import account.ui.AccountStatusText;

import account.AccountTextView;

import account.ui.AccountOverlay;

import flash.display.Sprite;

import account.ui.RegisterOverlay;

import com.company.assembleegameclient.appengine._02k;

import game.dialogs.NotRegisteredDialog;

import account.ui.PurchaseCreditsDialog;

import mx.utils.UIDUtil;

public class WebAccount extends Account {

    public static const GAME_NETWORK:String = "seraphsdominion";
    private static const GAME_NETWORK_USER_ID:String = "";
    private static const PLAY_PLATFORM:String = "seraphsdominion";

    public function WebAccount() {
        try {
            this.entryTag_ = ExternalInterface.call("rotmg.UrlLib.getParam", "entrypt");
        } catch (error:Error) {
        }
    }
    private var guid_:String = null;
    private var password_:String = null;
    private var entryTag_:String = "";

    override public function guid():String {
        return (this.guid_);
    }

    override public function password():String {
        return ((((this.password_) == null) ? "" : this.password_));
    }

    override public function credentials():Object {
        return ({
            "guid": this.guid(),
            "password": this.password()
        });
    }

    override public function isRegistered():Boolean {
        return (!((this.password() == "")));
    }

    override protected function internalLoad(stage:Stage, callback:Function):void {
        var sharedObject:SharedObject;
        this.guid_ = null;
        this.password_ = null;
        try {
            sharedObject = SharedObject.getLocal("SeraphsDominion", "/");
            if (sharedObject.data.hasOwnProperty("GUID")) {
                this.guid_ = sharedObject.data["GUID"];
            }
            if (sharedObject.data.hasOwnProperty("Password")) {
                this.password_ = sharedObject.data["Password"];
            }
        } catch (error:Error) {
        }
        if (this.guid_ == null) {
            this.modify(GUID.create(), null, null);
        }
        (callback());
    }

    override public function modify(guid:String, password:String, secret:String):void {
        var sharedObject:SharedObject;
        this.guid_ = guid;
        this.password_ = password;
        try {
            sharedObject = SharedObject.getLocal("SeraphsDominion", "/");
            sharedObject.data["GUID"] = this.guid_;
            sharedObject.data["Password"] = this.password_;
            sharedObject.flush();
        } catch (error:Error) {
        }
    }

    override public function clear():void {
        this.modify(GUID.create(), null, null);
        Parameters._hk = true;
        Parameters.data_.charIdUseMap = {};
        Parameters.save();
    }

    override public function reportIntStat(statName:String, value:int):void {
    }

    override public function newAccountText():AccountTextView {
        return (new AccountStatusText());
    }

    override public function newAccountManagement():Sprite {
        return (new AccountOverlay(false));
    }

    override public function showInGameRegister(stage:Stage):void {
        var registerDialog:RegisterOverlay = new RegisterOverlay();
        stage.addChild(registerDialog);
    }

    override public function cacheOffers():void {
        _02k._U_t("/credits", null);
    }

    override public function showMoneyManagement(stage:Stage):void {
        if (!this.isRegistered()) {
            stage.addChild(new NotRegisteredDialog(("In order to buy Gold " + ", you must be a registered user.")));
            return;
        }
        stage.addChild(new PurchaseCreditsDialog());
    }

    override public function gameNetworkUserId():String {
        return (GAME_NETWORK_USER_ID);
    }

    override public function gameNetwork():String {
        return (GAME_NETWORK);
    }

    override public function playPlatform():String {
        return (PLAY_PLATFORM);
    }

    override public function entrytag():String {
        return (this.entryTag_);
    }

}
}//package com.company.assembleegameclient.account.web

