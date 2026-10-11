package picturebrowser {
import pngencoder.PNGEncoder;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.utils.ByteArray;

/**
 * Collects bitmaps and packs them, left to right in rows, into a single
 * PNG sprite sheet. Bitmaps that do not fit on the sheet are left out.
 */
public class SpriteSheetBuilder {

    private static const SHEET_WIDTH:int = 128;
    private static const SHEET_HEIGHT:int = 256;

    public var bitmaps:Vector.<BitmapData>;

    public function SpriteSheetBuilder() {
        this.bitmaps = new Vector.<BitmapData>();
    }

    public function addBitmap(bitmap:BitmapData):void {
        this.bitmaps.push(bitmap);
    }

    public function encodePng():ByteArray {
        var bitmap:BitmapData;
        var sheet:BitmapData = new BitmapData(SHEET_WIDTH, SHEET_HEIGHT, true, 0);
        var position:Point = new Point(0, 0);
        var rowHeight:int = 0;
        for each (bitmap in this.bitmaps) {
            if ((position.x + bitmap.width) > SHEET_WIDTH) {
                position.y = position.y + rowHeight;
                position.x = 0;
                rowHeight = 0;
            }
            if ((position.y + bitmap.height) > SHEET_HEIGHT) {
                break;
            }
            sheet.copyPixels(bitmap, bitmap.rect, position);
            position.x = position.x + bitmap.width;
            if (bitmap.height > rowHeight) {
                rowHeight = bitmap.height;
            }
        }
        return PNGEncoder.encode(sheet);
    }
}
}
