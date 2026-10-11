// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.ui.frames.GoldOfferSelector

package client.ui.frames {
import flash.display.Sprite;

import com.company.assembleegameclient.util.offer.Offers;

import client.ui.controls.SelectionGroup;

import flash.events.MouseEvent;

import com.company.assembleegameclient.util.offer.Offer;

import client.ui.controls.ISelectableItem;

import flash.display.DisplayObject;

import layout.VerticalLayout;
import layout.ILayout;


public class GoldOfferSelector extends Sprite {

    public function GoldOfferSelector(_arg1:Offers, _arg2:String, _arg3:String) {
        this.offers = _arg1;
        this.currencyPrefix = _arg2;
        this.currencySuffix = _arg3;
        this.createItems();
        this.layoutItems();
        this.createSelectionGroup();
    }
    private var offers:Offers;
    private var currencyPrefix:String;
    private var currencySuffix:String;
    private var items:Vector.<GoldOfferItem>;
    private var group:SelectionGroup;

    public function getSelectedItem():GoldOfferItem {
        return ((this.group.getSelected() as GoldOfferItem));
    }

    public function showBonus(_arg1:Boolean):void {
        var _local2:int = this.items.length;
        while (_local2--) {
            this.items[_local2].showBonus(_arg1);
        }
    }

    private function createItems():void {
        var _local1:int = this.offers.offerList.length;
        this.items = new Vector.<GoldOfferItem>(_local1, true);
        var _local2:int;
        while (_local2 < _local1) {
            this.items[_local2] = this.createItem(this.offers.offerList[_local2]);
            _local2++;
        }
    }

    private function createItem(_arg1:Offer):GoldOfferItem {
        var _local2:GoldOfferItem = new GoldOfferItem(_arg1, this.currencyPrefix, this.currencySuffix);
        _local2.addEventListener(MouseEvent.CLICK, this.onItemClick);
        addChild(_local2);
        return (_local2);
    }

    private function layoutItems():void {
        var _local1:Vector.<DisplayObject> = this.getDisplayObjects();
        var _local2:ILayout = new VerticalLayout(5);
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

    private function onItemClick(_arg1:MouseEvent):void {
        var _local2:ISelectableItem = (_arg1.currentTarget as ISelectableItem);
        this.group.setSelected(_local2.getValue());
    }

}
}//package client.ui.frames

