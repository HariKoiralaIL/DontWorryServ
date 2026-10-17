package com.company.assembleegameclient.util {
import com.company.util.AssetLibrary;
import com.company.util.PointUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.GradientType;
import flash.display.Shader;
import flash.display.Shape;
import flash.filters.BitmapFilterQuality;
import flash.filters.GlowFilter;
import flash.filters.ShaderFilter;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

public class TextureRedrawer {

    private static const BORDER:int = 4;
    private static const RESIZE_MARGIN:int = 12;
    private static const GRADIENT_SIZE:int = 0x0100;
    private static const GRADIENT_REFERENCE_SIZE:int = 0x0089;
    // End color of the gradient subtracted in outlineGlow(). It is 0 (black), which makes that step a visual no-op.
    private static const GRADIENT_END_COLOR:uint = 0;
    private static const OUTLINE_FILTER:GlowFilter = new GlowFilter(0, 0.8, 1.4, 1.4, 0xFF, BitmapFilterQuality.LOW, false, false);
    private static const GLOW_FILTER:GlowFilter = new GlowFilter(0, 0.4, 12, 12, 2, BitmapFilterQuality.LOW, false, false);

    /** Texture used for texture-type 0xFF (set externally). */
    public static var sharedTexture_:BitmapData = null;

    private static var cache_:Dictionary = new Dictionary();
    private static var brightnessCache_:Dictionary = new Dictionary();
    private static var gradient_:Shape = getGradient();
    private static var tempMatrix_:Matrix = new Matrix();
    private static var textureShaderClass_:Class = TextureShaderEmbed;
    private static var textureShaderData_:ByteArray = (new textureShaderClass_() as ByteArray);
    private static var colorTexture1:BitmapData = new BitmapData(1, 1, false);
    private static var colorTexture2:BitmapData = new BitmapData(1, 1, false);

    public static function redraw(texture:BitmapData, size:int, padBottom:Boolean, outlineColor:uint, glowColor:uint, useCache:Boolean = true, sizeMultiplier:Number = 5):BitmapData {
        var sizeCache:Dictionary;
        var result:BitmapData;
        if (useCache) {
            sizeCache = cache_[size];
            if (sizeCache == null) {
                sizeCache = new Dictionary();
                cache_[size] = sizeCache;
            }
            result = sizeCache[texture];
            if (result != null) {
                return result;
            }
        }
        result = resize(texture, null, size, padBottom, 0, 0, sizeMultiplier);
        result = outlineGlow(result, outlineColor, glowColor);
        if (useCache) {
            sizeCache[texture] = result;
        }
        return result;
    }

    public static function resize(texture:BitmapData, mask:BitmapData, size:int, padBottom:Boolean, textureId1:int, textureId2:int, sizeMultiplier:Number = 5):BitmapData {
        if (mask != null && (textureId1 != 0 || textureId2 != 0)) {
            texture = retexture(texture, mask, textureId1, textureId2);
            size = (size / 5);
        }
        var scaledWidth:int = ((sizeMultiplier * (size / 100)) * texture.width);
        var scaledHeight:int = ((sizeMultiplier * (size / 100)) * texture.height);
        var matrix:Matrix = new Matrix();
        matrix.scale((scaledWidth / texture.width), (scaledHeight / texture.height));
        matrix.translate(RESIZE_MARGIN, RESIZE_MARGIN);
        var result:BitmapData = new BitmapData(((scaledWidth + RESIZE_MARGIN) + RESIZE_MARGIN), ((scaledHeight + ((padBottom) ? RESIZE_MARGIN : 1)) + RESIZE_MARGIN), true, 0);
        result.draw(texture, matrix);
        return result;
    }

    public static function outlineGlow(source:BitmapData, outlineColor:uint, glowColor:uint):BitmapData {
        var result:BitmapData = source.clone();
        tempMatrix_.identity();
        tempMatrix_.scale((source.width / GRADIENT_REFERENCE_SIZE), (source.height / GRADIENT_REFERENCE_SIZE));
        result.draw(gradient_, tempMatrix_, null, BlendMode.SUBTRACT);
        var sourceBitmap:Bitmap = new Bitmap(source);
        result.draw(sourceBitmap, null, null, BlendMode.ALPHA);
        OUTLINE_FILTER.color = outlineColor;
        result.applyFilter(result, result.rect, PointUtil.ORIGIN, OUTLINE_FILTER);
        if (glowColor != 0xFFFFFFFF) {
            GLOW_FILTER.color = glowColor;
            result.applyFilter(result, result.rect, PointUtil.ORIGIN, GLOW_FILTER);
        }
        return result;
    }

    public static function redrawSolidSquare(color:uint, size:int):BitmapData {
        var sizeCache:Dictionary = cache_[size];
        if (sizeCache == null) {
            sizeCache = new Dictionary();
            cache_[size] = sizeCache;
        }
        var result:BitmapData = sizeCache[color];
        if (result != null) {
            return result;
        }
        result = new BitmapData(((size + BORDER) + BORDER), ((size + BORDER) + BORDER), true, 0);
        result.fillRect(new Rectangle(BORDER, BORDER, size, size), (0xFF000000 | color));
        result.applyFilter(result, result.rect, PointUtil.ORIGIN, OUTLINE_FILTER);
        sizeCache[color] = result;
        return result;
    }

    public static function clearCache():void {
        var bitmap:BitmapData;
        var sizeCache:Dictionary;
        var multiplierCache:Dictionary;
        for each (sizeCache in cache_) {
            for each (bitmap in sizeCache) {
                bitmap.dispose();
            }
        }
        cache_ = new Dictionary();
        for each (multiplierCache in brightnessCache_) {
            for each (bitmap in multiplierCache) {
                bitmap.dispose();
            }
        }
        brightnessCache_ = new Dictionary();
    }

    /** Returns a copy of the bitmap with its RGB channels multiplied by `multiplier` (cached). */
    public static function adjustBrightness(source:BitmapData, multiplier:Number):BitmapData {
        if (multiplier == 1) {
            return source;
        }
        var multiplierCache:Dictionary = brightnessCache_[multiplier];
        if (multiplierCache == null) {
            multiplierCache = new Dictionary();
            brightnessCache_[multiplier] = multiplierCache;
        }
        var result:BitmapData = multiplierCache[source];
        if (result != null) {
            return result;
        }
        result = source.clone();
        result.colorTransform(result.rect, new ColorTransform(multiplier, multiplier, multiplier));
        multiplierCache[source] = result;
        return result;
    }

    /**
     * Resolves a packed texture descriptor: the top byte is the texture type, the low 24 bits are its value.
     * Type 0 = unchanged, 1 = solid color, 4/5/9/10 = tile from the matching textile sheet, 0xFF = shared texture.
     */
    private static function getTexture(textureData:int, solidColorTexture:BitmapData):BitmapData {
        var type:int = ((textureData >> 24) & 0xFF);
        var value:int = (textureData & 0xFFFFFF);
        switch (type) {
            case 0:
                return solidColorTexture;
            case 1:
                solidColorTexture.setPixel(0, 0, value);
                return solidColorTexture;
            case 4:
                return AssetLibrary.getImageFromSet("textile4x4", value);
            case 5:
                return AssetLibrary.getImageFromSet("textile5x5", value);
            case 9:
                return AssetLibrary.getImageFromSet("textile9x9", value);
            case 10:
                return AssetLibrary.getImageFromSet("textile10x10", value);
            case 0xFF:
                return sharedTexture_;
        }
        return null;
    }

    private static function retexture(texture:BitmapData, mask:BitmapData, textureId1:int, textureId2:int):BitmapData {
        var scaleMatrix:Matrix = new Matrix();
        scaleMatrix.scale(5, 5);
        var scaled:BitmapData = new BitmapData((texture.width * 5), (texture.height * 5), true, 0);
        scaled.draw(texture, scaleMatrix);
        var texture1:BitmapData = getTexture(textureId1, colorTexture1);
        var texture2:BitmapData = getTexture(textureId2, colorTexture2);
        var shader:Shader = new Shader(textureShaderData_);
        shader.data.src.input = scaled;
        shader.data.mask.input = mask;
        shader.data.texture1.input = texture1;
        shader.data.texture2.input = texture2;
        shader.data.texture1Size.value = [((textureId1 == 0) ? 0 : texture1.width)];
        shader.data.texture2Size.value = [((textureId2 == 0) ? 0 : texture2.width)];
        scaled.applyFilter(scaled, scaled.rect, PointUtil.ORIGIN, new ShaderFilter(shader));
        return scaled;
    }

    private static function getGradient():Shape {
        var shape:Shape = new Shape();
        var matrix:Matrix = new Matrix();
        matrix.createGradientBox(GRADIENT_SIZE, GRADIENT_SIZE, (Math.PI / 2), 0, 0);
        shape.graphics.beginGradientFill(GradientType.LINEAR, [0, GRADIENT_END_COLOR], [1, 1], [127, 0xFF], matrix);
        shape.graphics.drawRect(0, 0, GRADIENT_SIZE, GRADIENT_SIZE);
        shape.graphics.endFill();
        return shape;
    }

}
}
