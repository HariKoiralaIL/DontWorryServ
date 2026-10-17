package com.company.assembleegameclient.util {
import flash.display.BitmapData;
import flash.utils.Dictionary;

public class AnimatedCharLibrary {

    private static var charsByName_:Dictionary = new Dictionary();

    public static function getAnimatedChar(name:String, index:int):AnimatedChar {
        var chars:Vector.<AnimatedChar> = charsByName_[name];
        if (chars == null || index >= chars.length) {
            return null;
        }
        return chars[index];
    }

    /**
     * @param charWidth   width of a single character frame
     * @param charHeight  height of a single character frame
     * @param stripWidth  width of one character's strip of frames in the sheet
     * @param stripHeight height of one character's strip of frames in the sheet
     * @param firstDir    direction stored first in the strip (AnimatedChar.RIGHT or DOWN)
     */
    public static function add(name:String, image:BitmapData, mask:BitmapData, charWidth:int, charHeight:int,
                               stripWidth:int, stripHeight:int, firstDir:int):void {
        var chars:Vector.<AnimatedChar> = new Vector.<AnimatedChar>();
        var strips:MaskedImageSet = new MaskedImageSet();
        strips.addFromBitmapData(image, mask, stripWidth, stripHeight);
        var strip:MaskedImage;
        for each (strip in strips.images_) {
            chars.push(new AnimatedChar(strip, charWidth, charHeight, firstDir));
        }
        charsByName_[name] = chars;
    }

}
}
