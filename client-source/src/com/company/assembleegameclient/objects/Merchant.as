package com.company.assembleegameclient.objects {
    import mapoverlay.SpeechBalloon;

    import com.gskinner.motion.GTween;

    import easing.SineEase;

    import com.company.assembleegameclient.ui.tooltip.EquipmentToolTip;
    import com.company.assembleegameclient.ui.tooltip.ToolTip;

    import constants.ActorType;

    import com.company.assembleegameclient.map.GameCamera;
    import com.company.assembleegameclient.map.GameMap;
    import com.company.ui.SimpleText;
    import com.company.util.IntPoint;

    import flash.display.BitmapData;
    import flash.geom.ColorTransform;
    import flash.geom.Matrix;

    public class Merchant extends SellableObject implements IInteractable {

        private static const MSG_NONE:int = 0;
        private static const MSG_NEW:int = 1;
        private static const MSG_GOING:int = 2;
        private static const MSG_LEFT:int = 3;
        private static const MSG_DISCOUNT:int = 4;
        private static const TWEEN_TIME_SCALE:Number = 1;
        private static const DOSE_TEXT_MATRIX:Matrix = function ():Matrix {
            var _local1:* = new Matrix();
            _local1.translate(10, 5);
            return (_local1);
        }();

        public function Merchant(xml:XML) {
            this.colorTransform_ = new ColorTransform(1, 1, 1, 1);
            super(xml);
            isInteractive_ = true;
        }
        public var merchandiseType_:int = -1;
        public var count_:int = -1;
        public var minsLeft_:int = -1;
        public var discount_:int = 0;
        public var merchandiseTexture_:BitmapData = null;
        public var msUntilBubble_:int = 0;
        public var alpha_:Number = 1;
        private var firstUpdate_:Boolean = true;
        private var messageIndex_:int = 0;
        private var colorTransform_:ColorTransform;

        override public function setPrice(price:int):void {
            super.setPrice(price);
            this.msUntilBubble_ = 0;
        }

        override public function setRankReq(rank:int):void {
            super.setRankReq(rank);
            this.msUntilBubble_ = 0;
        }

        override public function addTo(map:GameMap, x:Number, y:Number):Boolean {
            if (!super.addTo(map, x, y)) {
                return (false);
            }
            map.merchLookup_[new IntPoint(x_, y_)] = this;
            return (true);
        }

        override public function removeFromMap():void {
            var _local1:IntPoint = new IntPoint(x_, y_);
            if (map_.merchLookup_[_local1] == this) {
                map_.merchLookup_[_local1] = null;
            }
            super.removeFromMap();
        }

        override public function update(time:int, dt:int):Boolean {
            var _local5:GTween;
            var _local6:GTween;
            super.update(time, dt);
            if (this.firstUpdate_) {
                if (this.minsLeft_ == 2147483647) {
                    this.alpha_ = 0;
                    _local5 = new GTween(this, (0.5 * TWEEN_TIME_SCALE), {"alpha_": 1});
                    _local6 = new GTween(this, (0.5 * TWEEN_TIME_SCALE), {"size_": 150}, {"ease": SineEase.easeOut});
                    _local6.nextTween = new GTween(this, (0.5 * TWEEN_TIME_SCALE), {"size_": 100}, {"ease": SineEase.easeIn});
                    _local6.nextTween.paused = true;
                }
                this.firstUpdate_ = false;
            }
            this.msUntilBubble_ = (this.msUntilBubble_ - dt);
            if (this.msUntilBubble_ > 0) {
                return (true);
            }
            this.msUntilBubble_ = 5000;
            var _local3:Vector.<int> = new Vector.<int>();
            if (this.minsLeft_ == 2147483647) {
                _local3.push(MSG_NEW);
            } else {
                if ((((this.minsLeft_ >= 0)) && ((this.minsLeft_ <= 5)))) {
                    _local3.push(MSG_GOING);
                }
            }
            if ((((this.count_ >= 1)) && ((this.count_ <= 2)))) {
                _local3.push(MSG_LEFT);
            }
            if (this.discount_ > 0) {
                _local3.push(MSG_DISCOUNT);
            }
            if (_local3.length == 0) {
                return (true);
            }
            this.messageIndex_ = (++this.messageIndex_ % _local3.length);
            var _local4:int = _local3[this.messageIndex_];
            map_.mapOverlay_.addSpeechBalloon(this.makeSpeechBalloon(_local4));
            return (true);
        }

        override public function soldObjectName():String {
            return (ObjectLibrary.typeToDisplayId_[this.merchandiseType_]);
        }

        override public function soldObjectInternalName():String {
            var _local1:XML = ObjectLibrary.typeToXML_[this.merchandiseType_];
            return (_local1.@id.toString());
        }

        override public function getTooltip():ToolTip {
            return (new EquipmentToolTip(this.merchandiseType_, map_.player_, -1, ActorType.NPC));
        }

        override public function getIcon():BitmapData {
            var _local3:SimpleText;
            var _local1:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.merchandiseType_, 80, true);
            var _local2:XML = ObjectLibrary.typeToXML_[this.merchandiseType_];
            if (_local2.hasOwnProperty("Doses")) {
                _local1 = _local1.clone();
                _local3 = new SimpleText(12, 0xFFFFFF, false, 0, 0, "Myriad Pro");
                _local3.text = String(_local2.Doses);
                _local3.updateMetrics();
                _local1.draw(_local3, DOSE_TEXT_MATRIX);
            }
            return (_local1);
        }

        override protected function getTexture(camera:GameCamera, time:int):BitmapData {
            if ((((this.alpha_ == 1)) && ((size_ == 100)))) {
                return (this.merchandiseTexture_);
            }
            var _local3:BitmapData = ObjectLibrary.getRedrawnTextureFromType(this.merchandiseType_, size_, false, false);
            if (this.alpha_ != 1) {
                this.colorTransform_.alphaMultiplier = this.alpha_;
                _local3.colorTransform(_local3.rect, this.colorTransform_);
            }
            return (_local3);
        }

        public function makeSpeechBalloon(messageType:int):SpeechBalloon {
            var _local2:String;
            var _local3:uint;
            var _local4:uint;
            var _local5:uint;
            switch (messageType) {
                case MSG_NEW:
                    _local2 = "New!";
                    _local3 = 0xE6E6E6;
                    _local4 = 0xFFFFFF;
                    _local5 = 5931045;
                    break;
                case MSG_GOING:
                    if (this.minsLeft_ == 0) {
                        _local2 = "Going soon!";
                    } else {
                        if (this.minsLeft_ == 1) {
                            _local2 = "Going in 1 min!";
                        } else {
                            _local2 = (("Going in " + this.minsLeft_) + " mins!");
                        }
                    }
                    _local3 = 5973542;
                    _local4 = 16549442;
                    _local5 = 16549442;
                    break;
                case MSG_LEFT:
                    _local2 = (this.count_ + " left!");
                    _local3 = 5973542;
                    _local4 = 16549442;
                    _local5 = 16549442;
                    break;
                case MSG_DISCOUNT:
                    _local2 = (this.discount_ + "% off!");
                    _local3 = 6324275;
                    _local4 = 16777103;
                    _local5 = 16777103;
                    break;
                default:
                    return (null);
            }
            return (new SpeechBalloon(this, _local2, _local3, 1, _local4, 1, _local5, 6, true, false));
        }

        public function getTex1Id(tex1Id:int):int {
            var _local2:XML = ObjectLibrary.typeToXML_[this.merchandiseType_];
            if (_local2 == null) {
                return (tex1Id);
            }
            if ((((_local2.Activate == "Dye")) && (_local2.hasOwnProperty("Tex1")))) {
                return (int(_local2.Tex1));
            }
            return (tex1Id);
        }

        public function getTex2Id(tex2Id:int):int {
            var _local2:XML = ObjectLibrary.typeToXML_[this.merchandiseType_];
            if (_local2 == null) {
                return (tex2Id);
            }
            if ((((_local2.Activate == "Dye")) && (_local2.hasOwnProperty("Tex2")))) {
                return (int(_local2.Tex2));
            }
            return (tex2Id);
        }

        public function getSkinId(skinId:int, player:Player):int {
            var _local2:XML = ObjectLibrary.typeToXML_[this.merchandiseType_];
            if (_local2 == null) return skinId;
            if (_local2.Activate == "UnlockSkin" && _local2.Activate.hasOwnProperty("@skinType")) {
                var _skin:XML = ObjectLibrary.typeToXML_[int(_local2.Activate.@skinType)];
                if (_skin == null)
                    return skinId;
                if (!_skin.hasOwnProperty("PlayerClassType"))
                    return skinId;
                if (int(_skin.PlayerClassType) != player.objectType_)
                    return skinId;
                return int(_local2.Activate.@skinType);
            }
            return skinId;
        }

        public function setMerchandiseType(type:int):void {
            this.merchandiseType_ = type;
            this.merchandiseTexture_ = ObjectLibrary.getRedrawnTextureFromType(this.merchandiseType_, 100, false);
        }

    }
}//package com.company.assembleegameclient.objects
