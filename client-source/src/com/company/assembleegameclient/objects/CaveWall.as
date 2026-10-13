package com.company.assembleegameclient.objects {
    import flash.geom.Vector3D;

    import com.company.assembleegameclient.engine3d.ObjectFace3D;

    import flash.display.BitmapData;

    public class CaveWall extends ConnectedObject {

        public function CaveWall(xml:XML) {
            super(xml);
        }

        override protected function buildDot():void {
            var _local1:Vector3D = new Vector3D((-0.25 - (Math.random() * 0.25)), (-0.25 - (Math.random() * 0.25)), 0);
            var _local2:Vector3D = new Vector3D((0.25 + (Math.random() * 0.25)), (-0.25 - (Math.random() * 0.25)), 0);
            var _local3:Vector3D = new Vector3D((0.25 + (Math.random() * 0.25)), (0.25 + (Math.random() * 0.25)), 0);
            var _local4:Vector3D = new Vector3D((-0.25 - (Math.random() * 0.25)), (0.25 + (Math.random() * 0.25)), 0);
            var _local5:Vector3D = new Vector3D((-0.25 + (Math.random() * 0.5)), (-0.25 + (Math.random() * 0.5)), 1);
            this.addFace(null, texture_, _local5, _local1, _local2);
            this.addFace(null, texture_, _local5, _local2, _local3);
            this.addFace(null, texture_, _local5, _local3, _local4);
            this.addFace(null, texture_, _local5, _local4, _local1);
        }

        override protected function buildShortLine():void {
            var _local1:Vector3D = this.getEdgePoint(0, 0);
            var _local2:Vector3D = this.getEdgePoint(0, 3);
            var _local3:Vector3D = new Vector3D((0.25 + (Math.random() * 0.25)), (0.25 + (Math.random() * 0.25)), 0);
            var _local4:Vector3D = new Vector3D((-0.25 - (Math.random() * 0.25)), (0.25 + (Math.random() * 0.25)), 0);
            var _local5:Vector3D = this.getEdgePoint(0, 1);
            var _local6:Vector3D = this.getEdgePoint(0, 2);
            var _local7:Vector3D = new Vector3D((Math.random() * 0.25), (Math.random() * 0.25), 0.5);
            var _local8:Vector3D = new Vector3D((Math.random() * -0.25), (Math.random() * 0.25), 0.5);
            this.addFace(null, texture_, _local5, _local8, _local4, _local1);
            this.addFace(null, texture_, _local8, _local7, _local3, _local4);
            this.addFace(null, texture_, _local7, _local6, _local2, _local3);
            this.addFace(null, texture_, _local5, _local6, _local7, _local8);
        }

        override protected function buildL():void {
            var _local1:Vector3D = this.getEdgePoint(0, 0);
            var _local2:Vector3D = this.getEdgePoint(0, 3);
            var _local3:Vector3D = this.getEdgePoint(1, 0);
            var _local4:Vector3D = this.getEdgePoint(1, 3);
            var _local5:Vector3D = new Vector3D((-(Math.random()) * 0.25), (Math.random() * 0.25), 0);
            var _local6:Vector3D = this.getEdgePoint(0, 1);
            var _local7:Vector3D = this.getEdgePoint(0, 2);
            var _local8:Vector3D = this.getEdgePoint(1, 1);
            var _local9:Vector3D = this.getEdgePoint(1, 2);
            var _local10:Vector3D = new Vector3D((Math.random() * 0.25), (-(Math.random()) * 0.25), 1);
            this.addFace(null, texture_, _local6, _local10, _local5, _local1);
            this.addFace(null, texture_, _local10, _local9, _local4, _local5);
            this.addFace(N2, texture_, _local8, _local7, _local2, _local3);
            this.addFace(null, texture_, _local6, _local7, _local8, _local9, _local10);
        }

        override protected function buildLine():void {
            var _local1:Vector3D = this.getEdgePoint(0, 0);
            var _local2:Vector3D = this.getEdgePoint(0, 3);
            var _local3:Vector3D = this.getEdgePoint(2, 3);
            var _local4:Vector3D = this.getEdgePoint(2, 0);
            var _local5:Vector3D = this.getEdgePoint(0, 1);
            var _local6:Vector3D = this.getEdgePoint(0, 2);
            var _local7:Vector3D = this.getEdgePoint(2, 2);
            var _local8:Vector3D = this.getEdgePoint(2, 1);
            this.addFace(N7, texture_, _local5, _local8, _local4, _local1);
            this.addFace(N3, texture_, _local7, _local6, _local2, _local3);
            this.addFace(null, texture_, _local5, _local6, _local7, _local8);
        }

        override protected function buildT():void {
            var _local1:Vector3D = this.getEdgePoint(0, 0);
            var _local2:Vector3D = this.getEdgePoint(0, 3);
            var _local3:Vector3D = this.getEdgePoint(1, 0);
            var _local4:Vector3D = this.getEdgePoint(1, 3);
            var _local5:Vector3D = this.getEdgePoint(3, 3);
            var _local6:Vector3D = this.getEdgePoint(3, 0);
            var _local7:Vector3D = this.getEdgePoint(0, 1);
            var _local8:Vector3D = this.getEdgePoint(0, 2);
            var _local9:Vector3D = this.getEdgePoint(1, 1);
            var _local10:Vector3D = this.getEdgePoint(1, 2);
            var _local11:Vector3D = this.getEdgePoint(3, 2);
            var _local12:Vector3D = this.getEdgePoint(3, 1);
            this.addFace(N2, texture_, _local9, _local8, _local2, _local3);
            this.addFace(null, texture_, _local11, _local10, _local4, _local5);
            this.addFace(N0, texture_, _local7, _local12, _local6, _local1);
            this.addFace(null, texture_, _local7, _local8, _local9, _local10, _local11, _local12);
        }

        override protected function buildCross():void {
            var _local1:Vector3D = this.getEdgePoint(0, 0);
            var _local2:Vector3D = this.getEdgePoint(0, 3);
            var _local3:Vector3D = this.getEdgePoint(1, 0);
            var _local4:Vector3D = this.getEdgePoint(1, 3);
            var _local5:Vector3D = this.getEdgePoint(2, 3);
            var _local6:Vector3D = this.getEdgePoint(2, 0);
            var _local7:Vector3D = this.getEdgePoint(3, 3);
            var _local8:Vector3D = this.getEdgePoint(3, 0);
            var _local9:Vector3D = this.getEdgePoint(0, 1);
            var _local10:Vector3D = this.getEdgePoint(0, 2);
            var _local11:Vector3D = this.getEdgePoint(1, 1);
            var _local12:Vector3D = this.getEdgePoint(1, 2);
            var _local13:Vector3D = this.getEdgePoint(2, 2);
            var _local14:Vector3D = this.getEdgePoint(2, 1);
            var _local15:Vector3D = this.getEdgePoint(3, 2);
            var _local16:Vector3D = this.getEdgePoint(3, 1);
            this.addFace(N2, texture_, _local11, _local10, _local2, _local3);
            this.addFace(N4, texture_, _local13, _local12, _local4, _local5);
            this.addFace(N6, texture_, _local15, _local14, _local6, _local7);
            this.addFace(N0, texture_, _local9, _local16, _local8, _local1);
            this.addFace(null, texture_, _local9, _local10, _local11, _local12, _local13, _local14, _local15, _local16);
        }

        protected function getEdgePoint(side:int, index:int):Vector3D {
            var _local6:int;
            var _local7:Number;
            var _local8:Number;
            var _local3:int = x_;
            var _local4:int = y_;
            var _local5:int = ((side + rotation_) % 4);
            switch (_local5) {
                case 1:
                    _local3++;
                    break;
                case 2:
                    _local4++;
                    break;
            }
            switch (index) {
                case 0:
                case 3:
                    _local6 = (15 + (((_local3 * 1259) ^ (_local4 * 2957)) % 35));
                    break;
                case 1:
                case 2:
                    _local6 = (3 + (((_local3 * 2179) ^ (_local4 * 1237)) % 35));
                    break;
            }
            switch (index) {
                case 0:
                    _local7 = (-(_local6) / 100);
                    _local8 = 0;
                    break;
                case 1:
                    _local7 = (-(_local6) / 100);
                    _local8 = 1;
                    break;
                case 2:
                    _local7 = (_local6 / 100);
                    _local8 = 1;
                    break;
                case 3:
                    _local7 = (_local6 / 100);
                    _local8 = 0;
                    break;
            }
            switch (side) {
                case 0:
                    return (new Vector3D(_local7, -0.5, _local8));
                case 1:
                    return (new Vector3D(0.5, _local7, _local8));
                case 2:
                    return (new Vector3D(_local7, 0.5, _local8));
                case 3:
                    return (new Vector3D(-0.5, _local7, _local8));
            }
            return (null);
        }

        protected function addFace(normal:Vector3D, texture:BitmapData, ..._args):void {
            var _local5:Vector3D;
            var _local6:int;
            var _local7:int;
            var _local4:int = (obj3D_.vertices_.length / 3);
            for each (_local5 in _args) {
                obj3D_.vertices_.push(_local5.x, _local5.y, _local5.z);
            }
            _local6 = obj3D_.faces_.length;
            if (_args.length == 4) {
                obj3D_.uvts_.push(0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0);
                if (Math.random() < 0.5) {
                    obj3D_.faces_.push(new ObjectFace3D(obj3D_, new <int>[_local4, (_local4 + 1), (_local4 + 3)]), new ObjectFace3D(obj3D_, new <int>[(_local4 + 1), (_local4 + 2), (_local4 + 3)]));
                } else {
                    obj3D_.faces_.push(new ObjectFace3D(obj3D_, new <int>[_local4, (_local4 + 2), (_local4 + 3)]), new ObjectFace3D(obj3D_, new <int>[_local4, (_local4 + 1), (_local4 + 2)]));
                }
            } else {
                if (_args.length == 3) {
                    obj3D_.uvts_.push(0, 0, 0, 0, 1, 0, 1, 1, 0);
                    obj3D_.faces_.push(new ObjectFace3D(obj3D_, new <int>[_local4, (_local4 + 1), (_local4 + 2)]));
                } else {
                    if (_args.length == 5) {
                        obj3D_.uvts_.push(0.2, 0, 0, 0.8, 0, 0, 1, 0.2, 0, 1, 0.8, 0, 0, 0.8, 0);
                        obj3D_.faces_.push(new ObjectFace3D(obj3D_, new <int>[_local4, (_local4 + 1), (_local4 + 2), (_local4 + 3), (_local4 + 4)]));
                    } else {
                        if (_args.length == 6) {
                            obj3D_.uvts_.push(0, 0, 0, 0.2, 0, 0, 1, 0.2, 0, 1, 0.8, 0, 0, 0.8, 0, 0, 0.2, 0);
                            obj3D_.faces_.push(new ObjectFace3D(obj3D_, new <int>[_local4, (_local4 + 1), (_local4 + 2), (_local4 + 3), (_local4 + 4), (_local4 + 5)]));
                        } else {
                            if (_args.length == 8) {
                                obj3D_.uvts_.push(0, 0, 0, 0.2, 0, 0, 1, 0.2, 0, 1, 0.8, 0, 0.8, 1, 0, 0.2, 1, 0, 0, 0.8, 0, 0, 0.2, 0);
                                obj3D_.faces_.push(new ObjectFace3D(obj3D_, new <int>[_local4, (_local4 + 1), (_local4 + 2), (_local4 + 3), (_local4 + 4), (_local4 + 5), (_local4 + 6), (_local4 + 7)]));
                            }
                        }
                    }
                }
            }
            if (((!((normal == null))) || (!((texture == null))))) {
                _local7 = _local6;
                while (_local7 < obj3D_.faces_.length) {
                    obj3D_.faces_[_local7].localNormal_ = normal;
                    obj3D_.faces_[_local7].texture_ = texture;
                    _local7++;
                }
            }
        }

    }
}//package com.company.assembleegameclient.objects
