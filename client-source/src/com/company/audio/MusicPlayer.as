package com.company.audio {
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.net.URLRequest;

import com.company.assembleegameclient.parameters.Parameters;

import flash.media.SoundTransform;

// Formerly _vf._gs. Plays looping music with a crossfade when the track changes.
public class MusicPlayer {

    private static const MAX_VOLUME:Number = 0.65;
    private static const FADE_STEP:Number = 0.0065;

    public static const menuMusic:Vector.<String> = new <String>["sorc", "Menu", "Menu2"];
    public static var fadeIn:Number = 0.65;
    public static var fadeOut:Number = 0;
    public static var music_:String = "Menu";
    private static var currentSoundChannel:SoundChannel = null;
    private static var currentSoundTransform:SoundTransform = null;
    private static var newSound:Sound = null;
    private static var newSoundChannel:SoundChannel = null;
    private static var newSoundTransform:SoundTransform = null;

    public static function load():void {
        var currentSound:Sound = new Sound();
        currentSound.load(new URLRequest("http://" + Parameters.musicUrl_ + "/sfx/music/" + randomMenu() + ".mp3"));
        currentSoundTransform = new SoundTransform(Parameters.data_.playMusic ? MAX_VOLUME : 0);
        currentSoundChannel = currentSound.play(0, int.MAX_VALUE, currentSoundTransform);
    }

    // Formerly _continue. Saves the music on/off setting and applies it.
    public static function setPlayMusic(enabled:Boolean):void {
        Parameters.data_.playMusic = enabled;
        Parameters.save();
        currentSoundChannel.soundTransform = new SoundTransform(Parameters.data_.playMusic ? MAX_VOLUME : 0);
    }

    public static function randomMenu():String {
        return menuMusic[Math.round(Math.random() * (menuMusic.length - 1))];
    }

    public static function reload(name:String):void {
        if (music_ == name) {
            return;
        }
        music_ = name;
        try {
            if (fadeIn < MAX_VOLUME && newSoundChannel != null) {
                endFade();
            }
            newSound = new Sound();
            newSound.load(new URLRequest("http://" + Parameters.musicUrl_ + "/sfx/music/" + (name == "Menu" ? randomMenu() : name) + ".mp3"));
            newSoundTransform = new SoundTransform(Parameters.data_.playMusic ? MAX_VOLUME : 0);
            newSoundChannel = newSound.play(0, int.MAX_VALUE, newSoundTransform);
        } catch (e:Error) {
            trace(e);
        }
        fadeIn = 0;
        fadeOut = MAX_VOLUME;
    }

    public static function endFade():void {
        try {
            currentSoundChannel.stop();
        } catch (er:Error) {
            trace(er);
        }
        currentSoundChannel = newSoundChannel;
        currentSoundTransform = newSoundTransform;
        currentSoundTransform.volume = Parameters.data_.playMusic ? MAX_VOLUME : 0;
        fadeIn = MAX_VOLUME;
        fadeOut = 0;
    }

    public static function updateFade():void {
        if (fadeIn >= MAX_VOLUME) {
            return;
        }
        if (!Parameters.data_.playMusic) {
            endFade();
            return;
        }
        try {
            fadeIn += FADE_STEP;
            fadeOut -= FADE_STEP;
            if (fadeOut < 0) {
                fadeOut = 0;
            }
            currentSoundTransform.volume = fadeOut;
            newSoundTransform.volume = fadeIn;
            currentSoundChannel.soundTransform = currentSoundTransform;
            newSoundChannel.soundTransform = newSoundTransform;
        } catch (e:Error) {
            trace(e);
        }
        if (fadeIn >= MAX_VOLUME) {
            endFade();
        }
    }

}
}
