package com.company.assembleegameclient.map {
import flash.utils.Dictionary;

public class RegionLibrary {

    public static const xmlLibrary_:Dictionary = new Dictionary();
    public static var idToType_:Dictionary = new Dictionary();

    public static function parseFromXML(xml:XML):void {
        for each (var regionXML:XML in xml.Region) {
            var type:int = int(regionXML.@type);
            xmlLibrary_[type] = regionXML;
            idToType_[String(regionXML.@id)] = type;
        }
    }

    public static function getIdFromType(type:int):String {
        var regionXML:XML = xmlLibrary_[type];
        if (regionXML == null) {
            return null;
        }
        return String(regionXML.@id);
    }

    public static function getColor(type:int):uint {
        var regionXML:XML = xmlLibrary_[type];
        if (regionXML == null) {
            return 0;
        }
        return uint(regionXML.Color);
    }

}
}
