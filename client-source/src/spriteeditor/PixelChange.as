package spriteeditor {
import client.util.color.HSV;

/** A request to set one cell to a color (null = clear it). */
public class PixelChange {

    public function PixelChange(cell:PixelCell, color:HSV):void {
        this.cell_ = cell;
        this.color_ = color;
    }
    public var cell_:PixelCell;
    public var color_:HSV;
}
}
