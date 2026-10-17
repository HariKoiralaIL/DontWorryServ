package com.company.assembleegameclient.map {
import com.company.assembleegameclient.objects.TextureData;
import com.company.util.BitmapUtil;

import flash.display.BitmapData;
import flash.utils.Dictionary;

public class GroundLibrary {

    public static const propsLibrary_:Dictionary = new Dictionary();
    public static const xmlLibrary_:Dictionary = new Dictionary();
    public static const typeToTextureData_:Dictionary = new Dictionary();
    public static var idToType_:Dictionary = new Dictionary();
    public static var defaultProps_:GroundProperties;
    private static var typeToColor_:Dictionary = new Dictionary();

    public static function parseFromXML(xml:XML):void {
        for each (var groundXML:XML in xml.Ground) {
            var type:int = int(groundXML.@type);
            propsLibrary_[type] = new GroundProperties(groundXML);
            xmlLibrary_[type] = groundXML;
            typeToTextureData_[type] = new TextureData(groundXML);
            idToType_[String(groundXML.@id)] = type;
        }
        defaultProps_ = propsLibrary_[0xFF];
    }

    public static function getIdFromType(type:int):String {
        var props:GroundProperties = propsLibrary_[type];
        if (props == null) {
            return null;
        }
        return props.id_;
    }

    public static function getBitmapData(type:int, seed:int = 0):BitmapData {
        return typeToTextureData_[type].getTexture(seed);
    }

    public static function getColor(type:int):uint {
        if (!typeToColor_.hasOwnProperty(String(type))) {
            var groundXML:XML = xmlLibrary_[type];
            var color:uint;
            if (groundXML.hasOwnProperty("Color")) {
                color = uint(groundXML.Color);
            } else {
                color = BitmapUtil.getDominantColor(getBitmapData(type));
            }
            typeToColor_[type] = color;
        }
        return typeToColor_[type];
    }

}
}
