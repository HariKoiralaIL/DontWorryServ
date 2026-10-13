package com.company.assembleegameclient.objects {
    import flash.geom.ColorTransform;
    import flash.display.BitmapData;

    public class ColorFlash {

        public function ColorFlash(startTime:int, color:uint, periodSec:Number, repeats:int) {
            this.startTime_ = startTime;
            this.color_ = color;
            this.periodMs_ = (periodSec * 1000);
            this.repeats_ = repeats;
            this.red_ = ((color >> 16) & 0xFF);
            this.green_ = ((color >> 8) & 0xFF);
            this.blue_ = (color & 0xFF);
        }
        public var startTime_:int;
        public var color_:uint;
        public var periodMs_:int;
        public var repeats_:int;
        public var colorTransform_:ColorTransform;
        public var red_:int;
        public var green_:int;
        public var blue_:int;

        public function apply(bitmap:BitmapData, time:int):BitmapData {
            var _local3:int = ((time - this.startTime_) % this.periodMs_);
            var _local4:Number = Math.sin(((_local3 / this.periodMs_) * Math.PI));
            var _local5:Number = (_local4 * 0.5);
            var _local6:ColorTransform = new ColorTransform((1 - _local5), (1 - _local5), (1 - _local5), 1, (_local5 * this.red_), (_local5 * this.green_), (_local5 * this.blue_), 0);
            var _local7:BitmapData = bitmap.clone();
            _local7.colorTransform(_local7.rect, _local6);
            return (_local7);
        }

        public function isFinished(time:int):Boolean {
            return ((time > (this.startTime_ + (this.periodMs_ * this.repeats_))));
        }

    }
}//package com.company.assembleegameclient.objects
