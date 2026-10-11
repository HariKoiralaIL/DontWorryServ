// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.ui.frames.PaymentMethodSelector

package client.ui.frames {
import flash.display.Sprite;

import client.ui.controls.SelectionGroup;

import flash.events.MouseEvent;

import client.ui.controls.ISelectableItem;

import flash.events.Event;
import flash.display.DisplayObject;

import layout.HorizontalLayout;
import layout.ILayout;


public class PaymentMethodSelector extends Sprite {

    public function PaymentMethodSelector(_arg1:Vector.<String>) {
        this.methods = _arg1;
        this.createItems();
        this.layoutItems();
        this.createSelectionGroup();
    }
    private var methods:Vector.<String>;
    private var items:Vector.<PaymentMethodItem>;
    private var group:SelectionGroup;

    public function setSelected(_arg1:String):void {
        this.group.setSelected(_arg1);
    }

    public function getSelected():String {
        return (this.group.getSelected().getValue());
    }

    private function createItems():void {
        var _local1:int = this.methods.length;
        this.items = new Vector.<PaymentMethodItem>(_local1, true);
        var _local2:int;
        while (_local2 < _local1) {
            this.items[_local2] = this.createItem(this.methods[_local2]);
            _local2++;
        }
    }

    private function createItem(_arg1:String):PaymentMethodItem {
        var _local2:PaymentMethodItem = new PaymentMethodItem(_arg1);
        _local2.addEventListener(MouseEvent.CLICK, this.onItemClick);
        addChild(_local2);
        return (_local2);
    }

    private function layoutItems():void {
        var _local1:Vector.<DisplayObject> = this.getDisplayObjects();
        var _local2:ILayout = new HorizontalLayout(20);
        _local2.layout(_local1);
    }

    private function getDisplayObjects():Vector.<DisplayObject> {
        var _local1:int = this.items.length;
        var _local2:Vector.<DisplayObject> = new <DisplayObject>[];
        var _local3:int;
        while (_local3 < _local1) {
            _local2[_local3] = this.items[_local3];
            _local3++;
        }
        return (_local2);
    }

    private function createSelectionGroup():void {
        var _local1:Vector.<ISelectableItem> = this.getSelectableItems();
        this.group = new SelectionGroup(_local1);
        this.group.setSelected(this.items[0].getValue());
    }

    private function getSelectableItems():Vector.<ISelectableItem> {
        var _local1:int = this.items.length;
        var _local2:Vector.<ISelectableItem> = new <ISelectableItem>[];
        var _local3:int;
        while (_local3 < _local1) {
            _local2[_local3] = this.items[_local3];
            _local3++;
        }
        return (_local2);
    }

    private function onItemClick(_arg1:Event):void {
        var _local2:ISelectableItem = (_arg1.currentTarget as ISelectableItem);
        this.group.setSelected(_local2.getValue());
    }

}
}//package client.ui.frames

