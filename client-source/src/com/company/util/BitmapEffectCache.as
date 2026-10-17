package com.company.util {
import flash.display.BitmapData;
import flash.filters.BitmapFilter;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.utils.Dictionary;

/** Caches color-transformed / filtered copies of bitmaps. */
public class BitmapEffectCache {

    private static var cache_:Dictionary = new Dictionary();

    public static function getColorTransformed(source:BitmapData, transform:ColorTransform):BitmapData {
        var result:BitmapData;
        var variants:Object = cache_[source];
        if (variants != null) {
            result = variants[transform];
        } else {
            variants = {};
            cache_[source] = variants;
        }
        if (result == null) {
            result = source.clone();
            result.colorTransform(result.rect, transform);
            variants[transform] = result;
        }
        return result;
    }

    public static function getFiltered(source:BitmapData, filter:BitmapFilter):BitmapData {
        var result:BitmapData;
        var variants:Object = cache_[source];
        if (variants != null) {
            result = variants[filter];
        } else {
            variants = {};
            cache_[source] = variants;
        }
        if (result == null) {
            result = source.clone();
            result.applyFilter(result, result.rect, new Point(), filter);
            variants[filter] = result;
        }
        return result;
    }

    /** Alpha is quantized to 1/100 steps to limit cache entries. */
    public static function getWithAlpha(source:BitmapData, alpha:Number):BitmapData {
        var alphaPercent:int = int(alpha * 100);
        var transform:ColorTransform = new ColorTransform(1, 1, 1, alphaPercent / 100);
        return getColorTransformed(source, transform);
    }

    /** Disposes every cached bitmap and empties the cache. */
    public static function clear():void {
        for each (var variants:Object in cache_) {
            for each (var bitmap:BitmapData in variants) {
                bitmap.dispose();
            }
        }
        cache_ = new Dictionary();
    }

}
}//package com.company.util
