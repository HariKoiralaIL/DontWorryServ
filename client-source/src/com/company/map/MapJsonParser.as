package com.company.map {
import com.company.json.IJsonParser;
import com.company.json.JsonParserLocator;

import com.company.assembleegameclient.map.GameMap;
import com.company.util.IntPoint;
import com.company.assembleegameclient.objects.GameObject;
import com.hurlant.util.Base64;

import flash.utils.ByteArray;

import com.company.assembleegameclient.map.GroundLibrary;
import com.company.assembleegameclient.objects.BasicObject;
import com.company.assembleegameclient.objects.ObjectLibrary;

// Formerly _K_D_._mapdetails. Parses map JSON (base64 + zlib tile data) into a map.
// Still-obfuscated externals: _throw (JSON codec), _P_I_._dJ_(), _X_l (map class),
// _pf._pb (ground type lookup), ObjectLibrary._pb/_075, props_._0M_t(), BasicObject._7y().
public class MapJsonParser {

    private static const json:IJsonParser = JsonParserLocator.getInstance();

    // Formerly _0L_k
    public static function loadMap(jsonStr:String):GameMap {
        var data:Object = json.parse(jsonStr);
        var map:GameMap = new GameMap(null);
        map.setProps(data["width"], data["height"], data["name"], data["back"], false, false, "Menu", 0);
        map.initialize();
        applyMapData(data, map, 0, 0);
        return map;
    }

    // Formerly _T_6. Stamps the JSON map onto an existing map at (offsetX, offsetY).
    public static function mergeInto(jsonStr:String, map:GameMap, offsetX:int, offsetY:int):void {
        var data:Object = json.parse(jsonStr);
        applyMapData(data, map, offsetX, offsetY);
    }

    // Formerly _0M_t
    public static function getMapSize(jsonStr:String):IntPoint {
        var data:Object = json.parse(jsonStr);
        return new IntPoint(data["width"], data["height"]);
    }

    // Formerly _A_s
    public static function createObject(objData:Object):GameObject {
        var objectType:int = ObjectLibrary._pb[objData["id"]];
        var obj:GameObject = ObjectLibrary._075(objectType);
        obj.size_ = objData.hasOwnProperty("size") ? objData["size"] : obj.props_._0M_t();
        return obj;
    }

    // Formerly _4q
    private static function applyMapData(data:Object, map:GameMap, offsetX:int, offsetY:int):void {
        var x:int;
        var y:int;
        var tile:Object;
        var objs:Array;
        var groundType:int;
        var objData:Object;
        var obj:GameObject;
        var tileData:ByteArray = Base64.decodeToByteArray(data["data"]);
        tileData.uncompress();
        var dict:Array = data["dict"];
        y = offsetY;
        while (y < offsetY + data["height"]) {
            x = offsetX;
            while (x < offsetX + data["width"]) {
                tile = dict[tileData.readShort()];
                if (x >= 0 && x < map.width_ && y >= 0 && y < map.height_) {
                    if (tile.hasOwnProperty("ground")) {
                        groundType = GroundLibrary.idToType_[tile["ground"]];
                        map.setGroundTile(x, y, groundType);
                    }
                    objs = tile["objs"];
                    if (objs != null) {
                        for each (objData in objs) {
                            obj = createObject(objData);
                            obj.objectId_ = BasicObject._7y();
                            map.addObj(obj, x + 0.5, y + 0.5);
                        }
                    }
                }
                x++;
            }
            y++;
        }
    }

}
}
