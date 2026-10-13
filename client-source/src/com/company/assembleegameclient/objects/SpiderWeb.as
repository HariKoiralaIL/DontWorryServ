package com.company.assembleegameclient.objects {

    import flash.display.IGraphicsData;

    import com.company.assembleegameclient.map.GameCamera;
    import com.company.assembleegameclient.map.Square;

    public class SpiderWeb extends GameObject {

        public function SpiderWeb(xml:XML) {
            super(xml);
        }
        private var foundWall_:Boolean = false;

        override public function draw(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
            if (!this.foundWall_) {
                this.foundWall_ = this.findAdjacentWall();
            }
            if (this.foundWall_) {
                super.draw(graphicsData, camera, time);
            }
        }

        private function findAdjacentWall():Boolean {
            var _local1:Square;
            _local1 = map_.lookupSquare((x_ - 1), y_);
            if (((!((_local1 == null))) && ((_local1.obj_ is Wall)))) {
                return (true);
            }
            _local1 = map_.lookupSquare(x_, (y_ - 1));
            if (((!((_local1 == null))) && ((_local1.obj_ is Wall)))) {
                obj3D_.setPosition(x_, y_, 0, 90);
                return (true);
            }
            _local1 = map_.lookupSquare((x_ + 1), y_);
            if (((!((_local1 == null))) && ((_local1.obj_ is Wall)))) {
                obj3D_.setPosition(x_, y_, 0, 180);
                return (true);
            }
            _local1 = map_.lookupSquare(x_, (y_ + 1));
            if (((!((_local1 == null))) && ((_local1.obj_ is Wall)))) {
                obj3D_.setPosition(x_, y_, 0, 270);
                return (true);
            }
            return (false);
        }

    }
}//package com.company.assembleegameclient.objects
