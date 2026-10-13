package com.company.assembleegameclient.objects {
    import flash.geom.Vector3D;
    import flash.display.BitmapData;

    import com.company.util.AssetLibrary;
    import com.company.assembleegameclient.engine3d.ObjectFace3D;

    public class ConnectedWall extends ConnectedObject {

        public function ConnectedWall(xml:XML) {
            super(xml);
            this.objectXml_ = xml;
            if (xml.hasOwnProperty("BaseIndent")) {
                this.baseHalfWidth_ = (0.5 - Number(xml.BaseIndent));
            }
            if (xml.hasOwnProperty("TopIndent")) {
                this.topHalfWidth_ = (0.5 - Number(xml.TopIndent));
            }
            if (xml.hasOwnProperty("Height")) {
                this.height_ = Number(xml.Height);
            }
            this.repeatWallTexture_ = !(xml.hasOwnProperty("NoWallTextureRepeat"));
            this.repeatTopTexture_ = !(xml.hasOwnProperty("NoTopTextureRepeat"));
        }
        protected var objectXml_:XML;
        protected var baseHalfWidth_:Number = 0.5;
        protected var topHalfWidth_:Number = 0.25;
        protected var height_:Number = 1;
        protected var repeatWallTexture_:Boolean;
        protected var repeatTopTexture_:Boolean;

        override protected function buildDot():void {
            var _local1:Vector3D = new Vector3D(-(this.baseHalfWidth_), -(this.baseHalfWidth_), 0);
            var _local2:Vector3D = new Vector3D(this.baseHalfWidth_, -(this.baseHalfWidth_), 0);
            var _local3:Vector3D = new Vector3D(this.baseHalfWidth_, this.baseHalfWidth_, 0);
            var _local4:Vector3D = new Vector3D(-(this.baseHalfWidth_), this.baseHalfWidth_, 0);
            var _local5:Vector3D = new Vector3D(-(this.topHalfWidth_), -(this.topHalfWidth_), this.height_);
            var _local6:Vector3D = new Vector3D(this.topHalfWidth_, -(this.topHalfWidth_), this.height_);
            var _local7:Vector3D = new Vector3D(this.topHalfWidth_, this.topHalfWidth_, this.height_);
            var _local8:Vector3D = new Vector3D(-(this.topHalfWidth_), this.topHalfWidth_, this.height_);
            this.addWallFace(_local6, _local5, _local1, _local2, texture_, true, true);
            this.addWallFace(_local7, _local6, _local2, _local3, texture_, true, true);
            this.addWallFace(_local5, _local8, _local4, _local1, texture_, true, true);
            this.addWallFace(_local8, _local7, _local3, _local4, texture_, true, true);
            var _local9:BitmapData = texture_;
            if (this.objectXml_.hasOwnProperty("DotTexture")) {
                _local9 = AssetLibrary._xK_(String(this.objectXml_.DotTexture.File), int(this.objectXml_.DotTexture.Index));
            }
            this.addTopFace([_local5, _local6, _local7, _local8], new <Number>[0.25, 0.25, 0.75, 0.25, 0.25, 0.75], _local9);
        }

        override protected function buildShortLine():void {
            var _local1:Vector3D = new Vector3D(-(this.baseHalfWidth_), -0.5, 0);
            var _local2:Vector3D = new Vector3D(this.baseHalfWidth_, -0.5, 0);
            var _local3:Vector3D = new Vector3D(this.baseHalfWidth_, this.baseHalfWidth_, 0);
            var _local4:Vector3D = new Vector3D(-(this.baseHalfWidth_), this.baseHalfWidth_, 0);
            var _local5:Vector3D = new Vector3D(-(this.topHalfWidth_), -0.5, this.height_);
            var _local6:Vector3D = new Vector3D(this.topHalfWidth_, -0.5, this.height_);
            var _local7:Vector3D = new Vector3D(this.topHalfWidth_, this.topHalfWidth_, this.height_);
            var _local8:Vector3D = new Vector3D(-(this.topHalfWidth_), this.topHalfWidth_, this.height_);
            this.addWallFace(_local7, _local6, _local2, _local3, texture_, true, false);
            this.addWallFace(_local5, _local8, _local4, _local1, texture_, false, true);
            this.addWallFace(_local8, _local7, _local3, _local4, texture_, true, true);
            var _local9:BitmapData = texture_;
            if (this.objectXml_.hasOwnProperty("ShortLineTexture")) {
                _local9 = AssetLibrary._xK_(String(this.objectXml_.ShortLineTexture.File), int(this.objectXml_.ShortLineTexture.Index));
            }
            this.addTopFace([_local5, _local6, _local7, _local8], new <Number>[0.25, 0, 0.75, 0, 0.25, 0.75], _local9);
        }

        override protected function buildL():void {
            var _local1:Vector3D = new Vector3D(-(this.baseHalfWidth_), -0.5, 0);
            var _local2:Vector3D = new Vector3D(this.baseHalfWidth_, -0.5, 0);
            var _local3:Vector3D = new Vector3D(this.baseHalfWidth_, -(this.baseHalfWidth_), 0);
            var _local4:Vector3D = new Vector3D(0.5, -(this.baseHalfWidth_), 0);
            var _local5:Vector3D = new Vector3D(0.5, this.baseHalfWidth_, 0);
            var _local6:Vector3D = new Vector3D(-(this.baseHalfWidth_), this.baseHalfWidth_, 0);
            var _local7:Vector3D = new Vector3D(-(this.topHalfWidth_), -0.5, this.height_);
            var _local8:Vector3D = new Vector3D(this.topHalfWidth_, -0.5, this.height_);
            var _local9:Vector3D = new Vector3D(this.topHalfWidth_, -(this.topHalfWidth_), this.height_);
            var _local10:Vector3D = new Vector3D(0.5, -(this.topHalfWidth_), this.height_);
            var _local11:Vector3D = new Vector3D(0.5, this.topHalfWidth_, this.height_);
            var _local12:Vector3D = new Vector3D(-(this.topHalfWidth_), this.topHalfWidth_, this.height_);
            this.addNormalWallFace(_local9, _local8, _local2, _local3, texture_, N2, true);
            this.addNormalWallFace(_local10, _local9, _local3, _local4, texture_, N2, false);
            this.addWallFace(_local12, _local11, _local5, _local6, texture_, true, false);
            this.addWallFace(_local7, _local12, _local6, _local1, texture_, false, true);
            var _local13:BitmapData = texture_;
            if (this.objectXml_.hasOwnProperty("LTexture")) {
                _local13 = AssetLibrary._xK_(String(this.objectXml_.LTexture.File), int(this.objectXml_.LTexture.Index));
            }
            this.addTopFace([_local7, _local8, _local9, _local10, _local11, _local12], new <Number>[0.25, 0, 0.75, 0, 0.25, 0.75], _local13);
        }

        override protected function buildLine():void {
            var _local1:Vector3D = new Vector3D(-(this.baseHalfWidth_), -0.5, 0);
            var _local2:Vector3D = new Vector3D(this.baseHalfWidth_, -0.5, 0);
            var _local3:Vector3D = new Vector3D(this.baseHalfWidth_, 0.5, 0);
            var _local4:Vector3D = new Vector3D(-(this.baseHalfWidth_), 0.5, 0);
            var _local5:Vector3D = new Vector3D(-(this.topHalfWidth_), -0.5, this.height_);
            var _local6:Vector3D = new Vector3D(this.topHalfWidth_, -0.5, this.height_);
            var _local7:Vector3D = new Vector3D(this.topHalfWidth_, 0.5, this.height_);
            var _local8:Vector3D = new Vector3D(-(this.topHalfWidth_), 0.5, this.height_);
            this.addWallFace(_local7, _local6, _local2, _local3, texture_, false, false);
            this.addWallFace(_local5, _local8, _local4, _local1, texture_, false, false);
            var _local9:BitmapData = texture_;
            if (this.objectXml_.hasOwnProperty("LineTexture")) {
                _local9 = AssetLibrary._xK_(String(this.objectXml_.LineTexture.File), int(this.objectXml_.LineTexture.Index));
            }
            this.addTopFace([_local5, _local6, _local7, _local8], new <Number>[0.25, 0, 0.75, 0, 0.25, 1], _local9);
        }

        override protected function buildT():void {
            var _local1:Vector3D = new Vector3D(-(this.baseHalfWidth_), -0.5, 0);
            var _local2:Vector3D = new Vector3D(this.baseHalfWidth_, -0.5, 0);
            var _local3:Vector3D = new Vector3D(this.baseHalfWidth_, -(this.baseHalfWidth_), 0);
            var _local4:Vector3D = new Vector3D(0.5, -(this.baseHalfWidth_), 0);
            var _local5:Vector3D = new Vector3D(0.5, this.baseHalfWidth_, 0);
            var _local6:Vector3D = new Vector3D(-0.5, this.baseHalfWidth_, 0);
            var _local7:Vector3D = new Vector3D(-0.5, -(this.baseHalfWidth_), 0);
            var _local8:Vector3D = new Vector3D(-(this.baseHalfWidth_), -(this.baseHalfWidth_), 0);
            var _local9:Vector3D = new Vector3D(-(this.topHalfWidth_), -0.5, this.height_);
            var _local10:Vector3D = new Vector3D(this.topHalfWidth_, -0.5, this.height_);
            var _local11:Vector3D = new Vector3D(this.topHalfWidth_, -(this.topHalfWidth_), this.height_);
            var _local12:Vector3D = new Vector3D(0.5, -(this.topHalfWidth_), this.height_);
            var _local13:Vector3D = new Vector3D(0.5, this.topHalfWidth_, this.height_);
            var _local14:Vector3D = new Vector3D(-0.5, this.topHalfWidth_, this.height_);
            var _local15:Vector3D = new Vector3D(-0.5, -(this.topHalfWidth_), this.height_);
            var _local16:Vector3D = new Vector3D(-(this.topHalfWidth_), -(this.topHalfWidth_), this.height_);
            this.addNormalWallFace(_local11, _local10, _local2, _local3, texture_, N2, true);
            this.addNormalWallFace(_local12, _local11, _local3, _local4, texture_, N2, false);
            this.addWallFace(_local14, _local13, _local5, _local6, texture_, false, false);
            this.addNormalWallFace(_local16, _local15, _local7, _local8, texture_, N0, true);
            this.addNormalWallFace(_local9, _local16, _local8, _local1, texture_, N0, false);
            var _local17:BitmapData = texture_;
            if (this.objectXml_.hasOwnProperty("TTexture")) {
                _local17 = AssetLibrary._xK_(String(this.objectXml_.TTexture.File), int(this.objectXml_.TTexture.Index));
            }
            this.addTopFace([_local9, _local10, _local11, _local12, _local13, _local14, _local15, _local16], new <Number>[0.25, 0, 0.75, 0, 0.25, 0.25], _local17);
        }

        override protected function buildCross():void {
            var _local1:Vector3D = new Vector3D(-(this.baseHalfWidth_), -0.5, 0);
            var _local2:Vector3D = new Vector3D(this.baseHalfWidth_, -0.5, 0);
            var _local3:Vector3D = new Vector3D(this.baseHalfWidth_, -(this.baseHalfWidth_), 0);
            var _local4:Vector3D = new Vector3D(0.5, -(this.baseHalfWidth_), 0);
            var _local5:Vector3D = new Vector3D(0.5, this.baseHalfWidth_, 0);
            var _local6:Vector3D = new Vector3D(this.baseHalfWidth_, this.baseHalfWidth_, 0);
            var _local7:Vector3D = new Vector3D(this.baseHalfWidth_, 0.5, 0);
            var _local8:Vector3D = new Vector3D(-(this.baseHalfWidth_), 0.5, 0);
            var _local9:Vector3D = new Vector3D(-(this.baseHalfWidth_), this.baseHalfWidth_, 0);
            var _local10:Vector3D = new Vector3D(-0.5, this.baseHalfWidth_, 0);
            var _local11:Vector3D = new Vector3D(-0.5, -(this.baseHalfWidth_), 0);
            var _local12:Vector3D = new Vector3D(-(this.baseHalfWidth_), -(this.baseHalfWidth_), 0);
            var _local13:Vector3D = new Vector3D(-(this.topHalfWidth_), -0.5, this.height_);
            var _local14:Vector3D = new Vector3D(this.topHalfWidth_, -0.5, this.height_);
            var _local15:Vector3D = new Vector3D(this.topHalfWidth_, -(this.topHalfWidth_), this.height_);
            var _local16:Vector3D = new Vector3D(0.5, -(this.topHalfWidth_), this.height_);
            var _local17:Vector3D = new Vector3D(0.5, this.topHalfWidth_, this.height_);
            var _local18:Vector3D = new Vector3D(this.topHalfWidth_, this.topHalfWidth_, this.height_);
            var _local19:Vector3D = new Vector3D(this.topHalfWidth_, 0.5, this.height_);
            var _local20:Vector3D = new Vector3D(-(this.topHalfWidth_), 0.5, this.height_);
            var _local21:Vector3D = new Vector3D(-(this.topHalfWidth_), this.topHalfWidth_, this.height_);
            var _local22:Vector3D = new Vector3D(-0.5, this.topHalfWidth_, this.height_);
            var _local23:Vector3D = new Vector3D(-0.5, -(this.topHalfWidth_), this.height_);
            var _local24:Vector3D = new Vector3D(-(this.topHalfWidth_), -(this.topHalfWidth_), this.height_);
            this.addNormalWallFace(_local15, _local14, _local2, _local3, texture_, N2, true);
            this.addNormalWallFace(_local16, _local15, _local3, _local4, texture_, N2, false);
            this.addNormalWallFace(_local18, _local17, _local5, _local6, texture_, N4, true);
            this.addNormalWallFace(_local19, _local18, _local6, _local7, texture_, N4, false);
            this.addNormalWallFace(_local21, _local20, _local8, _local9, texture_, N6, true);
            this.addNormalWallFace(_local22, _local21, _local9, _local10, texture_, N6, false);
            this.addNormalWallFace(_local24, _local23, _local11, _local12, texture_, N0, true);
            this.addNormalWallFace(_local13, _local24, _local12, _local1, texture_, N0, false);
            var _local25:BitmapData = texture_;
            if (this.objectXml_.hasOwnProperty("CrossTexture")) {
                _local25 = AssetLibrary._xK_(String(this.objectXml_.CrossTexture.File), int(this.objectXml_.CrossTexture.Index));
            }
            this.addTopFace([_local13, _local14, _local15, _local16, _local17, _local18, _local19, _local20, _local21, _local22, _local23, _local24], new <Number>[0.25, 0, 0.75, 0, 0.25, 0.25], _local25);
        }

        protected function addWallFace(v1:Vector3D, v2:Vector3D, v3:Vector3D, v4:Vector3D, texture:BitmapData, flagA:Boolean, flagB:Boolean):void {
            var _local8:int = (obj3D_.vertices_.length / 3);
            obj3D_.vertices_.push(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z, v3.x, v3.y, v3.z, v4.x, v4.y, v4.z);
            var _local9:Number = ((flagA) ? (-((this.baseHalfWidth_ - this.topHalfWidth_)) / ((1 - (this.baseHalfWidth_ - this.topHalfWidth_)) - ((flagB) ? (this.baseHalfWidth_ - this.topHalfWidth_) : 0))) : 0);
            obj3D_.uvts_.push(0, 0, 0, 1, 0, 0, 1, 1, 0, _local9, 1, 0);
            var _local10:ObjectFace3D = new ObjectFace3D(obj3D_, new <int>[_local8, (_local8 + 1), (_local8 + 2), (_local8 + 3)]);
            _local10.texture_ = texture;
            _local10.bitmapFill_.repeat = this.repeatWallTexture_;
            obj3D_.faces_.push(_local10);
        }

        protected function addNormalWallFace(v1:Vector3D, v2:Vector3D, v3:Vector3D, v4:Vector3D, texture:BitmapData, normal:Vector3D, flag:Boolean):void {
            var _local8:int = (obj3D_.vertices_.length / 3);
            obj3D_.vertices_.push(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z, v3.x, v3.y, v3.z, v4.x, v4.y, v4.z);
            if (flag) {
                obj3D_.uvts_.push((-0.5 + this.topHalfWidth_), 0, 0, 0, 0, 0, 0, 0, 0, (-0.5 + this.baseHalfWidth_), 1, 0);
            } else {
                obj3D_.uvts_.push(1, 0, 0, (1.5 - this.topHalfWidth_), 0, 0, 0, 0, 0, 1, 1, 0);
            }
            var _local9:ObjectFace3D = new ObjectFace3D(obj3D_, new <int>[_local8, (_local8 + 1), (_local8 + 2), (_local8 + 3)]);
            _local9.texture_ = texture;
            _local9.bitmapFill_.repeat = this.repeatWallTexture_;
            _local9.localNormal_ = normal;
            obj3D_.faces_.push(_local9);
        }

        protected function addTopFace(verts:Array, uvs:Vector.<Number>, texture:BitmapData):void {
            var _local4:int = (obj3D_.vertices_.length / 3);
            var _local5:Vector.<int> = new Vector.<int>();
            var _local6:uint;
            while (_local6 < verts.length) {
                obj3D_.vertices_.push(verts[_local6].x, verts[_local6].y, verts[_local6].z);
                _local5.push((_local4 + _local6));
                if (_local6 == 0) {
                    obj3D_.uvts_.push(uvs[0], uvs[1], 0);
                } else {
                    if (_local6 == 1) {
                        obj3D_.uvts_.push(uvs[2], uvs[3], 0);
                    } else {
                        if (_local6 == (verts.length - 1)) {
                            obj3D_.uvts_.push(uvs[4], uvs[5], 0);
                        } else {
                            obj3D_.uvts_.push(0, 0, 0);
                        }
                    }
                }
                _local6++;
            }
            var _local7:ObjectFace3D = new ObjectFace3D(obj3D_, _local5);
            _local7.texture_ = texture;
            _local7.bitmapFill_.repeat = this.repeatTopTexture_;
            obj3D_.faces_.push(_local7);
        }

    }
}//package com.company.assembleegameclient.objects
