package com.company.assembleegameclient.util {
import flash.display.BitmapData;
import flash.utils.Dictionary;

/** Builds the list of pixel colors used for an object's hit/death particles. */
public class BloodComposition {

    private static var compositionById_:Dictionary = new Dictionary();
    private static var colorsByBitmap_:Dictionary = new Dictionary();

    /**
     * @param id           cache key for the composition
     * @param bitmapData   source sprite whose pixel colors are sampled
     * @param bloodChance  probability (0-1) that a particle uses bloodColor instead of a sampled pixel
     * @param bloodColor   color used for "blood" particles
     */
    public static function getBloodComposition(id:int, bitmapData:BitmapData, bloodChance:Number, bloodColor:uint):Vector.<uint> {
        var composition:Vector.<uint> = compositionById_[id];
        if (composition != null) {
            return composition;
        }
        composition = new Vector.<uint>();
        var colors:Vector.<uint> = getColors(bitmapData);
        var i:int = 0;
        while (i < colors.length) {
            if (Math.random() < bloodChance) {
                composition.push(bloodColor);
            } else {
                composition.push(colors[int(colors.length * Math.random())]);
            }
            i++;
        }
        return composition;
    }

    /** Returns every non-transparent pixel color of the bitmap (cached per bitmap). */
    public static function getColors(bitmapData:BitmapData):Vector.<uint> {
        var colors:Vector.<uint> = colorsByBitmap_[bitmapData];
        if (colors == null) {
            colors = extractColors(bitmapData);
            colorsByBitmap_[bitmapData] = colors;
        }
        return colors;
    }

    private static function extractColors(bitmapData:BitmapData):Vector.<uint> {
        var y:int;
        var pixel:uint;
        var colors:Vector.<uint> = new Vector.<uint>();
        var x:int = 0;
        while (x < bitmapData.width) {
            y = 0;
            while (y < bitmapData.height) {
                pixel = bitmapData.getPixel32(x, y);
                if ((pixel & 0xFF000000) != 0) {
                    colors.push(pixel);
                }
                y++;
            }
            x++;
        }
        return colors;
    }

}
}
