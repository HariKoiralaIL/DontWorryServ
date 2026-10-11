package maploading
{
    import jsonserializer.JsonSerializerProvider;
    import jsonserializer.IJsonSerializer;

    import com.company.assembleegameclient.map._X_l;
    import com.company.assembleegameclient.map._pf;
    import com.company.assembleegameclient.objects.BasicObject;
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.objects.ObjectLibrary;
    import com.company.util.IntPoint;
    import com.hurlant.util.Base64;

    import flash.utils.ByteArray;

    public class MapLoader
    {
        private static const jsonParser_:IJsonSerializer = JsonSerializerProvider.getSerializer();

        public static function loadMap(json:String):_X_l
        {
            var mapData:Object = jsonParser_.parse(json);
            var map:_X_l = new _X_l(null);
            map.setProps(mapData["width"], mapData["height"], mapData["name"], mapData["back"], false, false, "Menu", 0);
            map.initialize();
            fillMap(mapData, map, 0, 0);
            return map;
        }

        public static function loadInto(json:String, map:_X_l, offsetX:int, offsetY:int):void
        {
            var mapData:Object = jsonParser_.parse(json);
            fillMap(mapData, map, offsetX, offsetY);
        }

        public static function getMapSize(json:String):IntPoint
        {
            var mapData:Object = jsonParser_.parse(json);
            return new IntPoint(mapData["width"], mapData["height"]);
        }

        public static function createObject(objectData:Object):GameObject
        {
            var objectType:int = ObjectLibrary._pb[objectData["id"]];
            var obj:GameObject = ObjectLibrary._075(objectType);
            obj.size_ = objectData.hasOwnProperty("size") ? objectData["size"] : obj.props_._0M_t();
            return obj;
        }

        private static function fillMap(mapData:Object, map:_X_l, offsetX:int, offsetY:int):void
        {
            var x:int;
            var y:int;
            var tileData:Object;
            var objectsData:Array;
            var objectData:Object;
            var obj:GameObject;
            var groundType:int;
            var bytes:ByteArray = Base64.decodeToByteArray(mapData["data"]);
            bytes.uncompress();
            var tileDict:Array = mapData["dict"];
            for (y = offsetY; y < offsetY + mapData["height"]; y++)
            {
                for (x = offsetX; x < offsetX + mapData["width"]; x++)
                {
                    tileData = tileDict[bytes.readShort()];
                    if (x < 0 || x >= map.width_ || y < 0 || y >= map.height_)
                    {
                        continue;
                    }
                    if (tileData.hasOwnProperty("ground"))
                    {
                        groundType = _pf._pb[tileData["ground"]];
                        map.setGroundTile(x, y, groundType);
                    }
                    objectsData = tileData["objs"];
                    if (objectsData != null)
                    {
                        for each (objectData in objectsData)
                        {
                            obj = createObject(objectData);
                            obj.objectId_ = BasicObject._7y();
                            map.addObj(obj, x + 0.5, y + 0.5);
                        }
                    }
                }
            }
        }
    }
}
