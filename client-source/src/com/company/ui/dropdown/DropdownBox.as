package com.company.ui.dropdown {
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

// Formerly _01c. A dropdown selector: shows the current value, and on click
// expands a list of all options on the stage until one is picked or the mouse leaves.
public class DropdownBox extends Sprite {

    private static const LABEL_GAP:int = 5;

    protected var options_:Vector.<String>;   // formerly _03Z_
    protected var w_:int;
    protected var h_:int;
    protected var labelText_:SimpleText;
    protected var itemOffsetX_:int = 0;       // formerly _zT_ (x offset past the label)
    protected var selected_:DropdownItem;
    protected var popup_:Sprite = new Sprite(); // formerly _2s

    public function DropdownBox(options:Vector.<String>, width:int, height:int, label:String = null) {
        super();
        this.options_ = options;
        this.w_ = width;
        this.h_ = height;
        if (label != null) {
            this.labelText_ = new SimpleText(16, 0xFFFFFF, false, 0, 0, "Myriad Pro");
            this.labelText_.setBold(true);
            this.labelText_.text = label + ":";
            this.labelText_.updateMetrics();
            addChild(this.labelText_);
            this.itemOffsetX_ = this.labelText_.width + LABEL_GAP;
        }
        this.setIndex(0);
    }

    public function getValue():String {
        return this.selected_.getValue();
    }

    public function setValue(value:String):void {
        var i:int = this.options_.indexOf(value);
        if (i >= 0) {
            this.setIndex(i);
        }
    }

    // formerly _0L_M_
    public function setIndex(index:int):void {
        this.setSelected(this.options_[index]);
    }

    // formerly _0K_M_
    public function getIndex():int {
        return this.options_.indexOf(this.selected_.getValue());
    }

    private function setSelected(value:String):void {
        var previous:String = (this.selected_ != null) ? this.selected_.getValue() : null;
        this.selected_ = new DropdownItem(value, this.w_, this.h_);
        this.selected_.x = this.itemOffsetX_;
        this.selected_.y = 0;
        addChild(this.selected_);
        this.selected_.addEventListener(MouseEvent.CLICK, this.onSelectedClick);
        if (value != previous) {
            dispatchEvent(new Event(Event.CHANGE));
        }
    }

    // formerly _022
    private function openPopup():void {
        var origin:Point = parent.localToGlobal(new Point(x, y));
        this.popup_.x = origin.x;
        this.popup_.y = origin.y;
        var yOffset:int = 0;
        for each (var option:String in this.options_) {
            var item:DropdownItem = new DropdownItem(option, this.w_, this.h_);
            item.addEventListener(MouseEvent.CLICK, this.onOptionClick);
            item.x = this.itemOffsetX_;
            item.y = yOffset;
            this.popup_.addChild(item);
            yOffset += item.h_;
        }
        this.popup_.addEventListener(MouseEvent.ROLL_OUT, this.onPopupRollOut);
        stage.addChild(this.popup_);
    }

    // formerly _1c
    private function closePopup():void {
        this.popup_.removeEventListener(MouseEvent.ROLL_OUT, this.onPopupRollOut);
        stage.removeChild(this.popup_);
        this.popup_.removeChildren(); // original leaked a fresh set of items on every open
    }

    private function onSelectedClick(e:MouseEvent):void {
        e.stopImmediatePropagation();
        this.selected_.removeEventListener(MouseEvent.CLICK, this.onSelectedClick);
        if (contains(this.selected_)) {
            removeChild(this.selected_);
        }
        this.openPopup();
    }

    private function onOptionClick(e:MouseEvent):void {
        e.stopImmediatePropagation();
        this.closePopup();
        this.setSelected((e.target as DropdownItem).getValue());
    }

    private function onPopupRollOut(e:MouseEvent):void {
        this.closePopup();
        this.setSelected(this.selected_.getValue());
    }
}
}
