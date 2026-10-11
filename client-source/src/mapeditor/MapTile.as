package mapeditor {

/**
 * Data for a single map tile: one type id per layer (-1 = empty)
 * plus an optional name for the object placed on it.
 */
public class MapTile {

    public function MapTile() {
        this.types_ = MapLayer.EMPTY_TYPES.concat();
        super();
    }
    public var types_:Vector.<int>;
    public var objectName_:String = null;

    public function clone():MapTile {
        var copy:MapTile = new MapTile();
        copy.types_ = this.types_.concat();
        copy.objectName_ = this.objectName_;
        return (copy);
    }

    public function isEmpty():Boolean {
        var layer:int;
        while (layer < MapLayer.NUM_LAYERS) {
            if (this.types_[layer] != -1) {
                return (false);
            }
            layer++;
        }
        return (true);
    }

}
}
