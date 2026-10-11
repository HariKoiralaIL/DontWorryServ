// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_zD_.__for

package _zD_ {
import spriteeditor.SpriteEditorScreen;

import robotlegs.bender.bundles.mvcs.Mediator;

import _F_1._C_Q_;

import env.ServerListState;

import game.signals.SpriteSignal2;

import client.signals.typed.GameInitSignal;

import constants.Buttons;

import game.dialogs.Dialog;

import client.game.GameInitData;

import com.company.assembleegameclient.parameters.Parameters;

import _F_1.CurrentCharacterScreen;
import _F_1._0H_h;
import _F_1._01_;
import _F_1._3V_;

import mapeditor.MapEditorScreen;

import flash.events.Event;
import flash.net.URLRequest;
import flash.net.navigateToURL;

public class __for extends Mediator {

    [Inject]
    public var view:_C_Q_;
    [Inject]
    public var _eJ_:ServerListState;
    [Inject]
    public var _T__:SpriteSignal2;
    [Inject]
    public var _D_u:GameInitSignal;

    override public function initialize():void {
        this.view._ft.add(this._F_A_);
        this.view.initialize(this._eJ_.servers);
    }

    override public function destroy():void {
        this.view._ft.remove(this._F_A_);
    }

    public function _F_A_(_arg1:String):void {
        switch (_arg1) {
            case Buttons.PLAY:
                this._04P_();
                return;
            case Buttons.SERVERS:
                this._0B_M_();
                return;
            case Buttons.CREDITS:
                this._C_0();
                return;
            case Buttons.ACCOUNT:
                this._0A_3();
                return;
            case Buttons.LEGENDS:
                this._N_E_();
                return;
            case Buttons.EDITOR:
                this._0E_r();
                return;
            case Buttons.SPRITE:
                this._1E_r();
                return;
            case Buttons.FORUMS:
                this._uz();
                return;
        }
    }

    private function _04P_():void {
        var _local1:Dialog;
        var _local2:GameInitData;
        if (((Parameters.isTesting) && ((this._eJ_.servers.servers_.length == 0)))) {
            if (Parameters._I_O_()) {
                _local1 = new Dialog(((("Your account doesn't exist anymore, please make a new.  " + 'Please play on <font color="#7777EE">') + '<a href="bledixon.com/webclient">') + "bledixon.com/webclient</a></font>."), "No Testing Servers", null, null, "/noTestingServers");
            } else {
                _local1 = new Dialog((((("Project B is currently offline.\n\n" + "Go here for more information:\n") + '<font color="#7777EE">') + '<a href="http://bledixon.com/forums">') + "http://bledixon.com/forums</a></font>."), "The Angelics are Sleeping", null, null, "/offLine");
            }
            this.view.stage.addChild(_local1);
            return;
        }
        if (((Parameters.data_.needsTutorial) && ((this._eJ_.servers.nextCharId_ == 1)))) {
            Parameters.data_.playerObjectType = 770;
            Parameters.save();
            _local2 = new GameInitData();
            _local2.createCharacter = true;
            _local2.charId = this._eJ_.servers.nextCharId_;
            _local2.keyTime = -1;
            _local2.isNewGame = true;
            this._D_u.dispatch(_local2);
        } else {
            this._T__.dispatch(new CurrentCharacterScreen());
        }
    }

    private function _C_0():void {
        this._T__.dispatch(new _0H_h());
    }

    private function _0B_M_():void {
        this._T__.dispatch(new _01_());
    }

    private function _0A_3():void {
        this.view._0j();
    }

    private function _N_E_():void {
        this._T__.dispatch(new _3V_());
    }

    private function _0E_r():void {
        this._T__.dispatch(new MapEditorScreen());
    }

    private function _1E_r():void {
        this._T__.dispatch(new SpriteEditorScreen());
    }

    private function _uz():void {
        navigateToURL(new URLRequest("http://bledixon.com/forums"), "_blank");
    }

}
}//package _zD_

