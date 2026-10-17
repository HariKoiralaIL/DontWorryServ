package com.company.assembleegameclient.objects {

    import com.company.assembleegameclient.engine3d.Face3D;

    import flash.display.BitmapData;

    import com.company.util.BitmapUtil;
    import com.company.assembleegameclient.map.Square;

    import flash.display.IGraphicsData;

    import com.company.assembleegameclient.map.GameCamera;

    public class Wall extends GameObject {

        private static const UVT_UNIT:Vector.<Number> = new <Number>[0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0];
        private static const NEIGHBOR_DX:Vector.<int> = new <int>[0, 1, 0, -1];
        private static const NEIGHBOR_DY:Vector.<int> = new <int>[-1, 0, 1, 0];

        public function Wall(xml:XML) {
            this.faces_ = new Vector.<Face3D>();
            super(xml);
            hasShadow_ = false;
            var _local2:TextureData = ObjectLibrary.typeToTopTextureData_[objectType_];
            this.topTexture_ = _local2.getTexture(0);
            this.wallModel_ = new <Number>[0, 0, 0, 1, 0, 0, 1, wallSize_, 0, 0, wallSize_, 0];
            if(xml.hasOwnProperty("Size"))
                this.setWallSize(Number(xml.Size));
            if(xml.hasOwnProperty("Elevation"))
                this.wallElevation_ = Number(xml.Elevation);
        }
        public var faces_:Vector.<Face3D>;
        private var topFace_:Face3D = null;
        private var topTexture_:BitmapData = null;
        public var wallSize_:Number = 1;
        public var wallModel_:Vector.<Number>;
        public var wallElevation_:Number = 0;

        override public function setObjectId(id:int):void {
            super.setObjectId(id);
            var _local2:TextureData = ObjectLibrary.typeToTopTextureData_[objectType_];
            this.topTexture_ = _local2.getTexture(id);
        }

        override public function getColor():uint {
            return (BitmapUtil.getDominantColor(this.topTexture_));
        }

        override public function draw(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
            var _local6:BitmapData;
            var _local7:Face3D;
            var _local8:Square;
            if (texture_ == null) {
                return;
            }
            if (this.faces_.length == 0) {
                this.buildFaces();
            }
            var _local4:BitmapData = texture_;
            if (animations_ != null) {
                _local6 = animations_.getTexture(time);
                if (_local6 != null) {
                    _local4 = _local6;
                }
            }
            var _local5:int;
            while (_local5 < this.faces_.length) {
                _local7 = this.faces_[_local5];
                _local8 = map_.lookupSquare((x_ + NEIGHBOR_DX[_local5]), (y_ + NEIGHBOR_DY[_local5]));
                if ((((((_local8 == null)) || ((_local8.texture_ == null)))) || (((((!((_local8 == null))) && ((_local8.obj_ is Wall)))) && (!(_local8.obj_.dead_)))))) {
                    _local7.useSolidFill_ = true;
                } else {
                    _local7.useSolidFill_ = false;
                    if (animations_ != null) {
                        _local7.setTexture(_local4);
                    }
                }
                _local7.draw(graphicsData, camera);
                _local5++;
            }
            this.topFace_.draw(graphicsData, camera);
        }

        public function setWallSize(size:Number):void {
            this.wallSize_ = size;
            this.wallModel_ = new <Number>[0, 0, 0, 1, 0, 0, 1, wallSize_, 0, 0, wallSize_, 0];
        }

        public function buildFaces():void {
            this.faces_.length = 0;
            var _local1:int = x_;
            var _local2:int = y_;
            var _local3:Vector.<Number> = new <Number>[_local1, _local2, this.wallSize_ + this.wallElevation_, (_local1 + 1), _local2, this.wallSize_ + this.wallElevation_, (_local1 + 1), (_local2 + 1), this.wallSize_ + this.wallElevation_, _local1, (_local2 + 1), this.wallSize_ + this.wallElevation_];
            this.topFace_ = new Face3D(this.topTexture_, _local3, UVT_UNIT, false, true);
            this.topFace_.bitmapFill_.repeat = true;
            this.addSideFace(_local1, _local2, this.wallSize_ + this.wallElevation_, (_local1 + 1), _local2, this.wallSize_ + this.wallElevation_);
            this.addSideFace((_local1 + 1), _local2, this.wallSize_ + this.wallElevation_, (_local1 + 1), (_local2 + 1), this.wallSize_ + this.wallElevation_);
            this.addSideFace((_local1 + 1), (_local2 + 1), this.wallSize_ + this.wallElevation_, _local1, (_local2 + 1), this.wallSize_ + this.wallElevation_);
            this.addSideFace(_local1, (_local2 + 1), this.wallSize_ + this.wallElevation_, _local1, _local2, this.wallSize_ + this.wallElevation_);
        }

        private function addSideFace(x1:Number, y1:Number, z1:Number, x2:Number, y2:Number, z2:Number):void {
            var _local7:Vector.<Number> = new <Number>[x1, y1, z1, x2, y2, z2, x2, y2, (z2 - this.wallSize_), x1, y1, (z1 - this.wallSize_)];
            var _local8:Face3D = new Face3D(texture_, _local7, this.wallModel_, true, true);
            _local8.bitmapFill_.repeat = true;
            this.faces_.push(_local8);
        }

    }
}//package com.company.assembleegameclient.objects
