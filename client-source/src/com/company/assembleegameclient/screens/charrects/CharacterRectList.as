// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.screens.charrects.CharacterRectList

package com.company.assembleegameclient.screens.charrects {
import game.dialogs.NotEnoughFameDialog;

import flash.display.Sprite;

import com.company.assembleegameclient.appengine.Server_list;

import client.ui.screens.BaseScreen;

import signals.Signal;

import com.company.assembleegameclient.appengine.SavedCharacter;

import flash.events.MouseEvent;

import game.dialogs.Dialog;

import flash.events.Event;

import game.dialogs.CharSlotNeedsRegistrationDialog;

import account.Account;

import game.dialogs.CharSlotNotEnoughGoldDialog;
import game.dialogs.BuyingCharSlotDialog;

import events.TextErrorEvent;

import game.dialogs.ErrorDialog;

public class CharacterRectList extends Sprite {

    public function CharacterRectList(_arg1:Server_list, _arg2:BaseScreen) {
        var _local5:SavedCharacter;
        var _local6:BuyCharacterRect;
        var _local7:CurrentCharacterRect;
        var _local8:int;
        var _local9:CreateNewCharacterRect;
        super();
        this.charList_ = _arg1;
        this.screen_ = _arg2;
        this.newCharacter = new Signal();
        var _local3:int = 4;
        var _local4:int = 4;
        for each (_local5 in _arg1.savedChars_) {
            _local7 = new CurrentCharacterRect(this.charList_.name_, _local5, this.charList_.charStats_[_local5.objectType()]);
            _local7.x = _local3;
            _local7.y = _local4;
            addChild(_local7);
            _local4 = (_local4 + (CharacterRect.HEIGHT + 4));
        }
        if (_arg1.hasAvailableCharSlot() && _arg1.servers_.length != 0) {
            _local8 = 0;
            while (_local8 < _arg1._rv()) {
                _local9 = new CreateNewCharacterRect(_arg1);
                _local9.addEventListener(MouseEvent.MOUSE_DOWN, this.onNewChar);
                _local9.x = _local3;
                _local9.y = _local4;
                addChild(_local9);
                _local4 = (_local4 + (CharacterRect.HEIGHT + 4));
                _local8++;
            }
        }
        _local6 = new BuyCharacterRect(_arg1);
        _local6.addEventListener(MouseEvent.MOUSE_DOWN, this.onBuyCharSlot);
        _local6.x = _local3;
        _local6.y = _local4;
        addChild(_local6);
    }
    public var newCharacter:Signal;
    public var deleteCharacter:Signal;
    private var charList_:Server_list;
    private var screen_:BaseScreen;

    private function onCancel(_arg1:Event):void {
        var _local2:Dialog = (_arg1.currentTarget as Dialog);
        this.screen_.removeChild(_local2);
    }

    private function onNewChar(_arg1:Event):void {
        this.newCharacter.dispatch();
    }

    private function onBuyCharSlot(_arg1:Event):void {
        var _local3:CharSlotNeedsRegistrationDialog;
        if (!Account.getInstance().isRegistered()) {
            _local3 = new CharSlotNeedsRegistrationDialog();
            _local3.addEventListener(Dialog.BUTTON1_EVENT, this.onCancel);
            _local3.addEventListener(Dialog.BUTTON2_EVENT, this.onDialogRegister);
            this.screen_.addChild(_local3);
            return;
        }
        if (this.charList_.fame_ < this.charList_.nextCharSlotPrice_) {
            this.screen_.addChild(new NotEnoughFameDialog());
            return;
        }
        var _local2:BuyingCharSlotDialog = new BuyingCharSlotDialog(this.charList_.nextCharSlotPrice_);
        _local2.addEventListener(TextErrorEvent.TEXT_ERROR, this.onDialogError);
        this.screen_.addChild(_local2);
    }

    private function onDialogRegister(_arg1:Event):void {
        var _local2:Dialog = (_arg1.currentTarget as Dialog);
        ((_local2.parent) && (_local2.parent.removeChild(_local2)));
        this.screen_.openAccountManagement();
    }

    private function onDialogError(_arg1:TextErrorEvent):void {
        var _local2:Dialog = (_arg1.currentTarget as Dialog);
        this.screen_.removeChild(_local2);
        var _local3:ErrorDialog = new ErrorDialog(_arg1.text);
        this.screen_.addChild(_local3);
    }

}
}//package com.company.assembleegameclient.screens.charrects

