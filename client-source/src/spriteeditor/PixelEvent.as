package spriteeditor {
import client.util.color.HSV;

import flash.events.Event;

/** Mouse interaction with a cell. `color_` is the cell's color at the time of the event. */
public class PixelEvent extends Event {

    public static const PIXEL_EVENT:String = "PIXEL_EVENT";
    public static const TEMP_PIXEL_EVENT:String = "TEMP_PIXEL_EVENT";
    public static const UNDO_TEMP_EVENT:String = "UNDO_TEMP_EVENT";

    public function PixelEvent(type:String, cell:PixelCell) {
        super(type, true);
        this.cell_ = cell;
        this.color_ = this.cell_.color_;
    }
    public var cell_:PixelCell;
    public var color_:HSV;
}
}
