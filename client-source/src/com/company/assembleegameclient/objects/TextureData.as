package com.company.assembleegameclient.objects {
    import flash.display.BitmapData;

    import com.company.assembleegameclient.util._lJ_;

    import flash.utils.Dictionary;

    import particleeffects.EffectProperties;

    import com.company.assembleegameclient.util._J_H_;
    import com.company.assembleegameclient.appengine.RemoteTexture;
    import com.company.util.AssetLibrary;
    import com.company.assembleegameclient.util._0B_c;
    import com.company.assembleegameclient.parameters.Parameters;

    import com.company.assembleegameclient.appengine.*;

    public class TextureData {

        public function TextureData(xml:XML) {
            var _local2:XML;
            super();
            if (xml.hasOwnProperty("Texture")) {
                this.parse(XML(xml.Texture));
            } else {
                if (xml.hasOwnProperty("AnimatedTexture")) {
                    this.parse(XML(xml.AnimatedTexture));
                } else {
                    if (xml.hasOwnProperty("RemoteTexture")) {
                        this.parse(XML(xml.RemoteTexture));
                    } else {
                        if (xml.hasOwnProperty("RandomTexture")) {
                            this.parse(XML(xml.RandomTexture));
                        } else {
                            this.parse(xml);
                        }
                    }
                }
            }
            for each (_local2 in xml.AltTexture) {
                this.parse(_local2);
            }
            if (xml.hasOwnProperty("Mask")) {
                this.parse(XML(xml.Mask));
            }
            if (xml.hasOwnProperty("Effect")) {
                this.parse(XML(xml.Effect));
            }
        }
        public var texture_:BitmapData = null;
        public var mask_:BitmapData = null;
        public var animatedChar_:_lJ_ = null;
        public var randomTextureData_:Vector.<TextureData> = null;
        public var altTextures_:Dictionary = null;
        public var remoteTextureDir_:int;
        public var effectProps_:EffectProperties = null;

        public function getTexture(index:int = 0):BitmapData {
            if (this.randomTextureData_ == null) {
                return (this.texture_);
            }
            var _local2:TextureData = this.randomTextureData_[(index % this.randomTextureData_.length)];
            return (_local2.getTexture(index));
        }

        public function getAltTextureData(altId:int):TextureData {
            if (this.altTextures_ == null) {
                return (null);
            }
            return (this.altTextures_[altId]);
        }

        private function parse(xml:XML):void {
            var _local2:_J_H_;
            var _local3:RemoteTexture;
            var _local4:XML;
            switch (xml.name().toString()) {
                case "Texture":
                    this.texture_ = AssetLibrary._xK_(String(xml.File), int(xml.Index));
                    return;
                case "Mask":
                    this.mask_ = AssetLibrary._xK_(String(xml.File), int(xml.Index));
                    return;
                case "Effect":
                    this.effectProps_ = new EffectProperties(xml);
                    return;
                case "AnimatedTexture":
                    this.animatedChar_ = _0B_c._J_v(String(xml.File), int(xml.Index));
                    _local2 = this.animatedChar_._l8(0, _lJ_._sS_, 0);
                    this.texture_ = _local2.image_;
                    this.mask_ = _local2.mask_;
                    return;
                case "RemoteTexture":
                    this.texture_ = AssetLibrary._xK_("lofiObj3", 0xFF);
                    if (Parameters.isTestingDomain()) {
                        _local3 = new RemoteTexture(xml.Id, xml.Instance, this.onRemoteTexture);
                        _local3.run();
                    }
                    this.remoteTextureDir_ = ((xml.hasOwnProperty("Right")) ? _lJ_.RIGHT : _lJ_.DOWN);
                    return;
                case "RandomTexture":
                    this.randomTextureData_ = new Vector.<TextureData>();
                    for each (_local4 in xml.children()) {
                        this.randomTextureData_.push(new TextureData(_local4));
                    }
                    return;
                case "AltTexture":
                    if (this.altTextures_ == null) {
                        this.altTextures_ = new Dictionary();
                    }
                    this.altTextures_[int(xml.@id)] = new TextureData(xml);
                    return;
            }
        }

        private function onRemoteTexture(bitmap:BitmapData):void {
            if (bitmap.width > 16) {
                _0B_c.add("remoteTexture", bitmap, null, (bitmap.width / 7), bitmap.height, bitmap.width, bitmap.height, this.remoteTextureDir_);
                this.animatedChar_ = _0B_c._J_v("remoteTexture", 0);
                this.texture_ = this.animatedChar_._l8(0, _lJ_._sS_, 0).image_;
            } else {
                this.texture_ = bitmap;
            }
        }

    }
}//package com.company.assembleegameclient.objects
