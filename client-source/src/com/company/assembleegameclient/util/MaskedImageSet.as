package com.company.assembleegameclient.util {
import com.company.util._kp;

import flash.display.BitmapData;

public class MaskedImageSet {

    public var images_:Vector.<MaskedImage> = new Vector.<MaskedImage>();

    /**
     * Slices an image (and optional mask) into equally sized cells.
     * Note: _kp is an external class; its members keep their original names.
     */
    public function addFromBitmapData(image:BitmapData, mask:BitmapData, cellWidth:int, cellHeight:int):void {
        var imageCells:_kp = new _kp();
        imageCells.addFromBitmapData(image, cellWidth, cellHeight);
        var maskCells:_kp;
        if (mask != null) {
            maskCells = new _kp();
            maskCells.addFromBitmapData(mask, cellWidth, cellHeight);
        }
        var i:int = 0;
        while (i < imageCells._W_u.length) {
            this.images_.push(new MaskedImage(imageCells._W_u[i], (maskCells == null) ? null : maskCells._W_u[i]));
            i++;
        }
    }

    public function addFromMaskedImage(source:MaskedImage, cellWidth:int, cellHeight:int):void {
        this.addFromBitmapData(source.image_, source.mask_, cellWidth, cellHeight);
    }

}
}
