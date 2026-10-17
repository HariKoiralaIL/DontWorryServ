package com.company.util {
import flash.display.BitmapData;

public class ImageSet {

    public var images:Vector.<BitmapData>;

    public function ImageSet() {
        this.images = new Vector.<BitmapData>();
    }

    public function add(bitmapData:BitmapData):void {
        this.images.push(bitmapData);
    }

    public function random():BitmapData {
        return this.images[int(Math.random() * this.images.length)];
    }

    /** Slices a sprite sheet into tiles, row by row. */
    public function addFromBitmapData(sheet:BitmapData, tileWidth:int, tileHeight:int):void {
        var cols:int = sheet.width / tileWidth;
        var rows:int = sheet.height / tileHeight;
        var row:int = 0;
        while (row < rows) {
            var col:int = 0;
            while (col < cols) {
                this.images.push(BitmapUtil.crop(sheet, col * tileWidth, row * tileHeight, tileWidth, tileHeight));
                col++;
            }
            row++;
        }
    }

}
}//package com.company.util
