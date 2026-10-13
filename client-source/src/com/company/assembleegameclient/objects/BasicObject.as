package com.company.assembleegameclient.objects {
    import com.company.assembleegameclient.map.GameMap;
    import com.company.assembleegameclient.map.Square;

    import flash.display.IGraphicsData;

    import com.company.assembleegameclient.map.GameCamera;

    public class BasicObject {

        private static var nextFakeId_:int = 0;

        public static function getNextFakeObjectId():int {
            return ((0x7F000000 | nextFakeId_++));
        }

        public function BasicObject() {
            this.worldVec_ = new Vector.<Number>();
            this.screenVec_ = new Vector.<Number>();
            super();
            this.clear();
        }
        public var map_:GameMap;
        public var square_:Square;
        public var objectId_:int;
        public var x_:Number;
        public var y_:Number;
        public var z_:Number;
        public var hasShadow_:Boolean;
        public var unusedFlag_:Boolean;
        public var worldVec_:Vector.<Number>;
        public var screenVec_:Vector.<Number>;
        public var sortVal_:Number;

        public function clear():void {
            this.map_ = null;
            this.square_ = null;
            this.objectId_ = -1;
            this.x_ = 0;
            this.y_ = 0;
            this.z_ = 0;
            this.hasShadow_ = false;
            this.unusedFlag_ = false;
            this.worldVec_.length = 0;
            this.screenVec_.length = 0;
            this.sortVal_ = 0;
        }

        public function dispose():void {
            this.map_ = null;
            this.square_ = null;
            this.worldVec_ = null;
            this.screenVec_ = null;
        }

        public function update(time:int, dt:int):Boolean {
            return (true);
        }

        public function draw(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
        }

        public function drawShadow(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
        }

        public function computeSortVal(camera:GameCamera):void {
            this.worldVec_.length = 0;
            this.worldVec_.push(this.x_, this.y_, 0, this.x_, this.y_, this.z_);
            this.screenVec_.length = 0;
            camera.wToS_.transformVectors(this.worldVec_, this.screenVec_);
            this.sortVal_ = this.screenVec_[1];
        }

        public function addTo(map:GameMap, x:Number, y:Number):Boolean {
            this.map_ = map;
            this.square_ = this.map_.getSquare(x, y);
            if (this.square_ == null) {
                this.map_ = null;
                return (false);
            }
            this.x_ = x;
            this.y_ = y;
            return (true);
        }

        public function removeFromMap():void {
            this.map_ = null;
            this.square_ = null;
        }

    }
}//package com.company.assembleegameclient.objects
