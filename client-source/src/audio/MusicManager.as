package audio {
import com.company.assembleegameclient.parameters.Parameters;

import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;

// Formerly _gs. Plays looping background music and crossfades between tracks.
public class MusicManager {

    private static const MUSIC_VOLUME:Number = 0.65;
    private static const FADE_STEP:Number = 0.0065;   // volume change per updateFade() call

    public static const menuMusic:Vector.<String> = new <String>["sorc", "Menu", "Menu2"];

    // Crossfade state: fadeIn is the new track's volume, fadeOut the old track's.
    public static var fadeIn:Number = MUSIC_VOLUME;
    public static var fadeOut:Number = 0;
    public static var music_:String = "Menu";

    private static var currentSoundChannel:SoundChannel = null;
    private static var currentSoundTransform:SoundTransform = null;
    private static var newSound:Sound = null;
    private static var newSoundChannel:SoundChannel = null;
    private static var newSoundTransform:SoundTransform = null;

    // Starts the initial menu track.
    public static function load():void {
        var sound:Sound = new Sound();
        sound.load(trackRequest(randomMenu()));
        currentSoundTransform = new SoundTransform(musicVolume());
        currentSoundChannel = sound.play(0, int.MAX_VALUE, currentSoundTransform);
    }

    // Turns music on/off and saves the setting. (formerly _continue)
    public static function setMusicEnabled(enabled:Boolean):void {
        Parameters.data_.playMusic = enabled;
        Parameters.save();
        currentSoundChannel.soundTransform = new SoundTransform(musicVolume());
    }

    public static function randomMenu():String {
        return menuMusic[Math.round(Math.random() * (menuMusic.length - 1))];
    }

    // Starts crossfading to the named track. "Menu" picks a random menu track.
    public static function reload(name:String):void {
        if (music_ == name) {
            return;
        }
        music_ = name;
        try {
            if (fadeIn < MUSIC_VOLUME && newSoundChannel != null) {
                endFade();
            }
            newSound = new Sound();
            newSound.load(trackRequest(name == "Menu" ? randomMenu() : name));
            newSoundTransform = new SoundTransform(musicVolume());
            newSoundChannel = newSound.play(0, int.MAX_VALUE, newSoundTransform);
        } catch (e:Error) {
            trace(e);
        }
        fadeIn = 0;
        fadeOut = MUSIC_VOLUME;
    }

    // Finishes the crossfade: stops the old track and makes the new one current.
    public static function endFade():void {
        try {
            currentSoundChannel.stop();
        } catch (e:Error) {
            trace(e);
        }
        currentSoundChannel = newSoundChannel;
        currentSoundTransform = newSoundTransform;
        currentSoundTransform.volume = musicVolume();
        fadeIn = MUSIC_VOLUME;
        fadeOut = 0;
    }

    // Call once per frame/tick to advance the crossfade.
    public static function updateFade():void {
        if (fadeIn >= MUSIC_VOLUME) {
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
        if (fadeIn >= MUSIC_VOLUME) {
            endFade();
        }
    }

    private static function musicVolume():Number {
        return Parameters.data_.playMusic ? MUSIC_VOLUME : 0;
    }

    private static function trackRequest(track:String):URLRequest {
        return new URLRequest("http://" + Parameters.musicUrl_ + "/sfx/music/" + track + ".mp3");
    }
}
}
