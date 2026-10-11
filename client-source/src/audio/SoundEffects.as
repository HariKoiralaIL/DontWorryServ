package audio {
import com.company.assembleegameclient.parameters.Parameters;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;
import flash.utils.Dictionary;

// Formerly _5T_. Loads, caches and plays sound effects (sfx/<name>.mp3).
public class SoundEffects {

    // Loaded sounds by name. (formerly _0H_k; public, so other code may touch it)
    public static var soundCache_:Dictionary = new Dictionary();
    // Requested volume per playing channel (formerly _04b). Weak keys so finished channels are collected.
    private static var baseVolumes:Dictionary = new Dictionary(true);
    private static var channels:Dictionary = new Dictionary(true);

    public static function load(name:String):Sound {
        var sound:Sound = soundCache_[name];
        if (sound != null) {
            return sound;
        }
        sound = new Sound();
        sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
        sound.load(new URLRequest("http://" + Parameters.musicUrl_ + "/sfx/" + name + ".mp3"));
        soundCache_[name] = sound;
        return sound;
    }

    // isFX = true for normal effects (controlled by playSFX), false for weapon fire
    // sounds (controlled by playPewPew).
    public static function play(name:String, volume:Number = 1, isFX:Boolean = true):void {
        var sound:Sound = load(name);
        try {
            var enabled:Boolean = isFX ? Parameters.data_.playSFX : Parameters.data_.playPewPew;
            var channel:SoundChannel = sound.play(0, 0, new SoundTransform(enabled ? volume : 0));
            channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete, false, 0, true);
            baseVolumes[channel] = volume;
            channels[channel] = channel;
        } catch (error:Error) {
            // Sound failed to start (e.g. no sound card or channel limit); ignore.
        }
    }

    // Re-applies the SFX on/off setting to every channel still playing. (formerly _02r)
    public static function refreshVolumes():void {
        for each (var channel:SoundChannel in channels) {
            var transform:SoundTransform = channel.soundTransform;
            transform.volume = Parameters.data_.playSFX ? baseVolumes[channel] : 0;
            channel.soundTransform = transform;
        }
    }

    public static function onIOError(e:IOErrorEvent):void {
    }

    private static function onSoundComplete(e:Event):void {
        var channel:SoundChannel = e.target as SoundChannel;
        delete baseVolumes[channel];
        delete channels[channel];
    }
}
}
