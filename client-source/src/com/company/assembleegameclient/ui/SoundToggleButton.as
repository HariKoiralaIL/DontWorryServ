package com.company.assembleegameclient.ui {
import audio.MusicManager;
import audio.SfxSettings;

import com.company.assembleegameclient.parameters.Parameters;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;

/**
 * Speaker icon that mutes / unmutes music and sound effects when clicked.
 *
 * Formerly: _zX_
 */
public class SoundToggleButton extends Sprite {

    private static const SOUND_ON_ICON:int = 3;
    private static const SOUND_OFF_ICON:int = 4;

    private var bitmap_:Bitmap = new Bitmap();

    public function SoundToggleButton() {
        super();
        addChild(this.bitmap_);
        this.updateIcon();
        addEventListener(MouseEvent.CLICK, this.onClick);
        filters = [new GlowFilter(0, 1, 4, 4, 2, 1)];
    }

    private function updateIcon():void {
        var soundOn:Boolean = Parameters.data_.playMusic || Parameters.data_.playSFX;
        this.bitmap_.bitmapData = AssetLibrary.getImageFromSet("lofiInterfaceBig", soundOn ? SOUND_ON_ICON : SOUND_OFF_ICON);
    }

    private function onClick(event:MouseEvent):void {
        var enable:Boolean = !(Parameters.data_.playMusic || Parameters.data_.playSFX);
        MusicManager.setMusicEnabled(enable);
        SfxSettings.setSfxEnabled(enable);
        Parameters.data_.playPewPew = enable;
        Parameters.save();
        this.updateIcon();
    }
}
}
