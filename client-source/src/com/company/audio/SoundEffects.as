package com.company.audio {
import com.company.assembleegameclient.parameters.Parameters;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;
import flash.utils.Dictionary;

// Formerly _vf._5T_. Loads, caches and plays sound effects.
public class SoundEffects {

    public static var sounds:Dictionary = new Dictionary();                    // formerly _0H_k
    private static var volumes:Dictionary = new Dictionary(true);              // formerly _04b; channel -> base volume
    private static var channels:Dictionary = new Dictionary(true);

    public static function load(name:String):Sound {
        var sound:Sound = sounds[name];
        if (sound != null) {
            return sound;
        }
        var request:URLRequest = new URLRequest("http://" + Parameters.musicUrl_ + "/sfx/" + name + ".mp3");
        sound = new Sound();
        sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
        sound.load(request);
        sounds[name] = sound;
        return sound;
    }

    public static function play(name:String, volume:Number = 1, isFX:Boolean = true):void {
        var actualVolume:Number;
        var trans:SoundTransform;
        var channel:SoundChannel;
        var sound:Sound = load(name);
        try {
            actualVolume = ((Parameters.data_.playSFX && isFX) || (!isFX && Parameters.data_.playPewPew)) ? volume : 0;
            trans = new SoundTransform(actualVolume);
            channel = sound.play(0, 0, trans);
            channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete, false, 0, true);
            volumes[channel] = volume;
            channels[channel] = channel;
        } catch (error:Error) {
        }
    }

    // Formerly _02r. Re-applies the SFX setting to every channel still playing.
    public static function updateVolumes():void {
        var channel:SoundChannel;
        var trans:SoundTransform;
        for each (channel in channels) {
            trans = channel.soundTransform;
            trans.volume = Parameters.data_.playSFX ? volumes[channel] : 0;
            channel.soundTransform = trans;
        }
    }

    public static function onIOError(e:IOErrorEvent):void {
    }

    // Formerly _J_M_
    private static function onSoundComplete(e:Event):void {
        var channel:SoundChannel = e.target as SoundChannel;
        delete volumes[channel];
        delete channels[channel];
    }

}
}
