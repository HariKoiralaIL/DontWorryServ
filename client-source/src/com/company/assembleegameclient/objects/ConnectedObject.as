package com.company.assembleegameclient.objects {
    import flash.geom.Vector3D;
    import flash.utils.Dictionary;

    import com.company.assembleegameclient.engine3d.ObjectFace3D;

    import flash.display.BitmapData;

    import com.company.assembleegameclient.map.Square;

    import flash.geom.Utils3D;

    import flash.display.IGraphicsData;

    import com.company.assembleegameclient.map.GameCamera;
    import com.company.assembleegameclient.engine3d.Object3D;

    public class ConnectedObject extends GameObject {

        protected static const TYPE_DOT:int = 0;
        protected static const TYPE_SHORT_LINE:int = 1;
        protected static const TYPE_L:int = 2;
        protected static const TYPE_LINE:int = 3;
        protected static const TYPE_T:int = 4;
        protected static const TYPE_CROSS:int = 5;
        protected static const N0:Vector3D = new Vector3D(-1, -1, 0);
        protected static const N1:Vector3D = new Vector3D(0, -1, 0);
        protected static const N2:Vector3D = new Vector3D(1, -1, 0);
        protected static const N3:Vector3D = new Vector3D(1, 0, 0);
        protected static const N4:Vector3D = new Vector3D(1, 1, 0);
        protected static const N5:Vector3D = new Vector3D(0, 1, 0);
        protected static const N6:Vector3D = new Vector3D(-1, 1, 0);
        protected static const N7:Vector3D = new Vector3D(-1, 0, 0);
        protected static const N8:Vector3D = new Vector3D(0, 0, 1);

        private static var resultsByMask_:Dictionary = null;

        private static function init():void {
            resultsByMask_ = new Dictionary();
            registerPattern(33686018, TYPE_DOT);
            registerPattern(16908802, TYPE_SHORT_LINE);
            registerPattern(16843266, TYPE_L);
            registerPattern(16908546, TYPE_LINE);
            registerPattern(16843265, TYPE_T);
            registerPattern(16843009, TYPE_CROSS);
        }

        private static function getConnectedResults(mask:int):ConnectedResults {
            if (resultsByMask_ == null) {
                init();
            }
            var _local2 = (mask & 252645135);
            return (resultsByMask_[_local2]);
        }

        private static function registerPattern(mask:int, type:int):void {
            var _local4:int;
            var _local3:int;
            while (_local3 < 4) {
                if (!resultsByMask_.hasOwnProperty(String(mask))) {
                    resultsByMask_[mask] = new ConnectedResults(type, _local3);
                    _local4 = (mask & 0xFF);
                    mask = ((mask >> 8) | (_local4 << 24));
                }
                _local3++;
            }
        }

        public function ConnectedObject(xml:XML) {
            super(xml);
            hasShadow_ = false;
        }
        protected var rotation_:int = 0;

        override public function draw(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
            var _local4:ObjectFace3D;
            var _local5:int;
            var _local6:int;
            var _local7:BitmapData;
            var _local8:Square;
            if (obj3D_ == null) {
                this.buildModel();
            }
            Utils3D.projectVectors(camera.wToS_, obj3D_.worldVertices_, obj3D_.screenVertices_, obj3D_.uvts_);
            for each (_local4 in obj3D_.faces_) {
                _local5 = (((_local4.normal_.x > 0.4)) ? 1 : (((_local4.normal_.x < -0.4)) ? -1 : 0));
                _local6 = (((_local4.normal_.y > 0.4)) ? 1 : (((_local4.normal_.y < -0.4)) ? -1 : 0));
                _local7 = _local4.texture_;
                if (((!((_local5 == 0))) || (!((_local6 == 0))))) {
                    _local8 = map_.lookupSquare((x_ + _local5), (y_ + _local6));
                    if ((((_local8 == null)) || ((_local8.texture_ == null)))) {
                        _local7 = null;
                    }
                }
                _local4.draw(graphicsData, 0, _local7);
            }
        }

        public function buildModel():void {
            obj3D_ = new Object3D();
            var _local1:ConnectedResults = getConnectedResults(connectedMask_);
            if (_local1 == null) {
                obj3D_ = null;
                return;
            }
            this.rotation_ = _local1.rotation_;
            switch (_local1.type_) {
                case TYPE_DOT:
                    this.buildDot();
                    break;
                case TYPE_SHORT_LINE:
                    this.buildShortLine();
                    break;
                case TYPE_L:
                    this.buildL();
                    break;
                case TYPE_LINE:
                    this.buildLine();
                    break;
                case TYPE_T:
                    this.buildT();
                    break;
                case TYPE_CROSS:
                    this.buildCross();
                    break;
                default:
                    obj3D_ = null;
                    return;
            }
            obj3D_.setPosition(x_, y_, 0, (this.rotation_ * 90));
        }

        protected function buildDot():void {
        }

        protected function buildShortLine():void {
        }

        protected function buildL():void {
        }

        protected function buildLine():void {
        }

        protected function buildT():void {
        }

        protected function buildCross():void {
        }

    }
}//package com.company.assembleegameclient.objects

class ConnectedResults {

    public var type_:int;
    public var rotation_:int;

    public function ConnectedResults(_arg1:int, _arg2:int) {
        this.type_ = _arg1;
        this.rotation_ = _arg2;
    }
}
