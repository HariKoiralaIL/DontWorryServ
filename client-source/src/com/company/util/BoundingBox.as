package com.company.util {
public class BoundingBox {

    public function BoundingBox() {
        this.clear();
    }

    public var minX:Number;
    public var minY:Number;
    public var maxX:Number;
    public var maxY:Number;

    public function add(x:Number, y:Number):void {
        if (x < this.minX) {
            this.minX = x;
        }
        if (y < this.minY) {
            this.minY = y;
        }
        if (x > this.maxX) {
            this.maxX = x;
        }
        if (y > this.maxY) {
            this.maxY = y;
        }
    }

    public function clear():void {
        this.minX = Number.MAX_VALUE;
        this.minY = Number.MAX_VALUE;
        this.maxX = Number.MIN_VALUE; // NOTE: MIN_VALUE is the smallest positive Number (original behavior)
        this.maxY = Number.MIN_VALUE;
    }

    public function toString():String {
        return "min:(" + this.minX + ", " + this.minY + ") max:(" + this.maxX + ", " + this.maxY + ")";
    }

}
}//package com.company.util
