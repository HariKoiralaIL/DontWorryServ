package com.company.util {
import flash.display.BitmapData;
import flash.media.Sound;
import flash.media.SoundTransform;
import flash.utils.Dictionary;

public class AssetLibrary {

    private static var images_:Dictionary = new Dictionary();
    private static var imageSets_:Dictionary = new Dictionary();
    private static var sounds_:Dictionary = new Dictionary();
    private static var imageKeys_:Dictionary = new Dictionary();

    public static function addImage(id:String, bitmapData:BitmapData):void {
        images_[id] = bitmapData;
        imageKeys_[bitmapData] = id;
    }

    public static function addImageSet(id:String, bitmapData:BitmapData, tileWidth:int, tileHeight:int):void {
        images_[id] = bitmapData;
        var imageSet:ImageSet = new ImageSet();
        imageSet.addFromBitmapData(bitmapData, tileWidth, tileHeight);
        imageSets_[id] = imageSet;
        var i:int = 0;
        while (i < imageSet.images.length) {
            imageKeys_[imageSet.images[i]] = [id, i];
            i++;
        }
    }

    public static function addToImageSet(id:String, bitmapData:BitmapData):void {
        var imageSet:ImageSet = imageSets_[id];
        if (imageSet == null) {
            imageSet = new ImageSet();
            imageSets_[id] = imageSet;
        }
        imageSet.add(bitmapData);
        var index:int = imageSet.images.length - 1;
        imageKeys_[imageSet.images[index]] = [id, index];
    }

    public static function addSound(id:String, soundClass:Class):void {
        if (sounds_[id] == null) {
            sounds_[id] = [];
        }
        sounds_[id].push(soundClass);
    }

    /** Returns the id (String) or [id, index] (Array) the bitmap was registered under. */
    public static function getImageKey(bitmapData:BitmapData):Object {
        return imageKeys_[bitmapData];
    }

    public static function getImage(id:String):BitmapData {
        return images_[id];
    }

    public static function getImageSet(id:String):ImageSet {
        return imageSets_[id];
    }

    public static function getImageFromSet(id:String, index:int):BitmapData {
        var imageSet:ImageSet = imageSets_[id];
        return imageSet.images[index];
    }

    public static function getSound(id:String):Sound {
        var soundClasses:Array = sounds_[id];
        var index:int = Math.random() * soundClasses.length;
        var soundClass:Class = soundClasses[index];
        return new soundClass();
    }

    public static function playSound(id:String, volume:Number = 1):void {
        var sound:Sound = getSound(id);
        var transform:SoundTransform;
        if (volume != 1) {
            transform = new SoundTransform(volume);
        }
        sound.play(0, 0, transform);
    }

    public function AssetLibrary(enforcer:StaticEnforcer) {
    }

}
}//package com.company.util

class StaticEnforcer {

}
