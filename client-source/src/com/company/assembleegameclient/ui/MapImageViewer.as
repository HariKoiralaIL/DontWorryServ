package com.company.assembleegameclient.ui {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.FileReference;

import pngencoder.PNGEncoder;

/**
 * Overlay that shows a map screenshot with "Save" (as map.png) and "Close" buttons.
 *
 * Formerly: _B_N_
 */
public class MapImageViewer extends Sprite {

    private static const SCREEN_SIZE:int = 600;
    private static const BUTTON_SPACING:int = 10;

    private var bitmap_:Bitmap;
    private var saveButton_:RoundedButton;
    private var closeButton_:RoundedButton;

    public function MapImageViewer(mapImage:BitmapData) {
        super();
        this.bitmap_ = new Bitmap(mapImage);
        addChild(this.bitmap_);
        this.saveButton_ = new RoundedButton(16, "Save");
        addChild(this.saveButton_);
        this.closeButton_ = new RoundedButton(16, "Close");
        addChild(this.closeButton_);
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    private function onAddedToStage(event:Event):void {
        this.saveButton_.addEventListener(MouseEvent.CLICK, this.onSaveClick);
        this.closeButton_.addEventListener(MouseEvent.CLICK, this.onCloseClick);
        this.bitmap_.x = (SCREEN_SIZE / 2) - (this.bitmap_.width / 2);
        this.bitmap_.y = (SCREEN_SIZE / 2) - (this.bitmap_.height / 2);
        var buttonY:Number = this.bitmap_.y + this.bitmap_.height + BUTTON_SPACING;
        this.closeButton_.x = (this.bitmap_.x + this.bitmap_.width) - this.closeButton_.width;
        this.closeButton_.y = buttonY;
        this.saveButton_.x = (this.closeButton_.x - this.saveButton_.width) - BUTTON_SPACING;
        this.saveButton_.y = buttonY;
    }

    private function onRemovedFromStage(event:Event):void {
        this.saveButton_.removeEventListener(MouseEvent.CLICK, this.onSaveClick);
        this.closeButton_.removeEventListener(MouseEvent.CLICK, this.onCloseClick);
    }

    private function onSaveClick(event:Event):void {
        new FileReference().save(PNGEncoder.encode(this.bitmap_.bitmapData), "map.png");
    }

    private function onCloseClick(event:Event):void {
        if (parent != null) {
            parent.removeChild(this);
        }
    }
}
}
