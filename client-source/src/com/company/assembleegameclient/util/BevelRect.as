package com.company.assembleegameclient.util {

/** Describes a rectangle whose corners can be individually bevelled. */
public class BevelRect {

    public var topLeftBevel_:Boolean = true;
    public var topRightBevel_:Boolean = true;
    public var bottomLeftBevel_:Boolean = true;
    public var bottomRightBevel_:Boolean = true;
    public var width:int;
    public var height:int;
    public var bevel_:int;

    public function BevelRect(width:int, height:int, bevel:int) {
        this.width = width;
        this.height = height;
        this.bevel_ = bevel;
    }

}
}
