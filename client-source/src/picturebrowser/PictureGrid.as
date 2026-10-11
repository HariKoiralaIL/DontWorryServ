package picturebrowser {
import com.company.events.LoadCompleteEvent;

import flash.display.Sprite;
import flash.events.MouseEvent;

/**
 * One page of picture tiles, built from the server's XML list response.
 * Dispatches LoadCompleteEvent when a loaded tile is clicked.
 */
public class PictureGrid extends Sprite {

    /** Offset of this page within the full result list (from the XML). */
    public var offset:int;
    /** Number of tiles on this page. */
    public var pictureCount:int;

    public function PictureGrid(xml:XML, columns:int, rows:int) {
        var picXml:XML;
        var tile:PictureTile;
        this.offset = int(xml.@offset);
        this.pictureCount = 0;
        var column:int = 0;
        var row:int = 0;
        var isAdmin:Boolean = xml.hasOwnProperty("Admin");
        for each (picXml in xml.Pic) {
            tile = new PictureTile(picXml, isAdmin);
            tile.x = column * PictureTile.WIDTH;
            tile.y = row * PictureTile.HEIGHT;
            tile.addEventListener(MouseEvent.CLICK, this.onTileClick);
            addChild(tile);
            this.pictureCount++;
            column = (column + 1) % columns;
            if (column == 0) {
                row++;
                if (row >= rows) {
                    break;
                }
            }
        }
    }

    private function onTileClick(event:MouseEvent):void {
        var tile:PictureTile = event.target as PictureTile;
        if (tile.bitmapData == null) {
            return;
        }
        dispatchEvent(new LoadCompleteEvent(tile.pictureName, tile.dataType, tile.tags, tile.bitmapData));
    }
}
}
