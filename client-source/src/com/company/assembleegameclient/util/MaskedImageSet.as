package com.company.assembleegameclient.util {
import com.company.util.ImageSet;

import flash.display.BitmapData;

public class MaskedImageSet {

    public var images_:Vector.<MaskedImage> = new Vector.<MaskedImage>();

    /**
     * Slices an image (and optional mask) into equally sized cells.
     * Note: _kp is an external class; its members keep their original names.
     */
    public function addFromBitmapData(image:BitmapData, mask:BitmapData, cellWidth:int, cellHeight:int):void {
        var imageCells:ImageSet = new ImageSet();
        imageCells.addFromBitmapData(image, cellWidth, cellHeight);
        var maskCells:ImageSet;
        if (mask != null) {
            maskCells = new ImageSet();
            maskCells.addFromBitmapData(mask, cellWidth, cellHeight);
        }
        var i:int = 0;
        while (i < imageCells.images.length) {
            this.images_.push(new MaskedImage(imageCells.images[i], (maskCells == null) ? null : maskCells.images[i]));
            i++;
        }
    }

    public function addFromMaskedImage(source:MaskedImage, cellWidth:int, cellHeight:int):void {
        this.addFromBitmapData(source.image_, source.mask_, cellWidth, cellHeight);
    }

}
}
