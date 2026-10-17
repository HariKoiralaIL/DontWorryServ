package com.company.assembleegameclient.util {
import com.company.util.BitmapUtil;

import flash.display.BitmapData;

/** A sprite image paired with an optional mask (used for player dye/texture areas). */
public class MaskedImage {

    public var image_:BitmapData;
    public var mask_:BitmapData;

    public function MaskedImage(image:BitmapData, mask:BitmapData) {
        this.image_ = image;
        this.mask_ = mask;
    }

    public function width():int {
        return this.image_.width;
    }

    public function height():int {
        return this.image_.height;
    }

    public function mirror(offset:int = 0):MaskedImage {
        var mirroredImage:BitmapData = BitmapUtil.mirror(this.image_, offset);
        var mirroredMask:BitmapData = (this.mask_ == null) ? null : BitmapUtil.mirror(this.mask_, offset);
        return new MaskedImage(mirroredImage, mirroredMask);
    }

    /** Fraction of the image that is transparent (1 = fully transparent). */
    public function amountTransparent():Number {
        return BitmapUtil._F_9(this.image_);
    }

}
}
