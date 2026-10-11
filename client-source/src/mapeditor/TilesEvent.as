package mapeditor {
import com.company.util.IntPoint;

import flash.events.Event;

/** Dispatched by the map canvas when the user clicks/drags over one or more tiles. */
internal class TilesEvent extends Event {

    public static const TILES_EVENT:String = "TILES_EVENT";

    public function TilesEvent(tiles:Vector.<IntPoint>) {
        super(TILES_EVENT);
        this.tiles_ = tiles;
    }
    public var tiles_:Vector.<IntPoint>;
}
}
