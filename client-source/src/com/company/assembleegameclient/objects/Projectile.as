package com.company.assembleegameclient.objects {
    import com.company.assembleegameclient.engine3d.Billboard;
    import com.company.assembleegameclient.map.Square;
    import com.company.assembleegameclient.map.GameCamera;
    import com.company.assembleegameclient.map.GameMap;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.tutorial.Tutorial;
    import com.company.assembleegameclient.tutorial.doneAction;
    import com.company.assembleegameclient.util.TextureRedrawer;
    import com.company.assembleegameclient.util._04d;
    import com.company.assembleegameclient.util._7t;
    import com.company.assembleegameclient.util._wW_;
    import com.company.util.GraphicHelper;
    import com.company.util.Trig;

    import flash.display.BitmapData;
    import flash.display.GradientType;
    import flash.display.GraphicsGradientFill;
    import flash.display.GraphicsPath;
    import flash.display.IGraphicsData;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Vector3D;
    import flash.utils.Dictionary;

    import particleeffects.HitEffect;
    import particleeffects.SparkParticle;

    public class Projectile extends BasicObject {

        private static var objectIds_:Dictionary = new Dictionary();

        public static function findObjectId(ownerId:int, bulletId:uint):int {
            return (objectIds_[((bulletId << 24) | ownerId)]);
        }

        public static function allocateObjectId(ownerId:int, bulletId:uint):int {
            var _local3:int = getNextFakeObjectId();
            objectIds_[((bulletId << 24) | ownerId)] = _local3;
            return (_local3);
        }

        public static function releaseObjectId(ownerId:int, bulletId:uint):void {
            delete objectIds_[((bulletId << 24) | ownerId)];
        }

        public static function dispose():void {
            objectIds_ = new Dictionary();
        }

        public function Projectile() {
            this.billboard_ = new Billboard(100);
            this.tempPoint_ = new Point();
            this.tempVec3D_ = new Vector3D();
            this.shadowFill_ = new GraphicsGradientFill(GradientType.RADIAL, [0, 0], [0.5, 0], null, new Matrix());
            this.shadowPath_ = new GraphicsPath(GraphicHelper._H_2, new Vector.<Number>());
            super();
        }
        public var props_:ObjectProperties;
        public var containerProps_:ObjectProperties;
        public var projProps_:ProjectileProperties;
        public var texture_:BitmapData;
        public var bulletId_:uint;
        public var ownerId_:int;
        public var containerType_:int;
        public var bulletType_:uint;
        public var damagesEnemies_:Boolean;
        public var damagesPlayers_:Boolean;
        public var damage_:int;
        public var sound_:String;
        public var startX_:Number;
        public var startY_:Number;
        public var startTime_:int;
        public var angle_:Number = 0;
        public var multiHitDict_:Dictionary;
        public var billboard_:Billboard;
        protected var shadowFill_:GraphicsGradientFill;
        protected var shadowPath_:GraphicsPath;
        private var tempPoint_:Point;
        private var tempVec3D_:Vector3D;

        override public function addTo(map:GameMap, x:Number, y:Number):Boolean {
            var _local4:Player;
            this.startX_ = x;
            this.startY_ = y;
            if (!super.addTo(map, x, y)) {
                return (false);
            }
            if (((!(this.containerProps_.flying_)) && (square_.sink_))) {
                z_ = 0.1;
            } else {
                _local4 = (map.goDict_[this.ownerId_] as Player);
                if (((!((_local4 == null))) && ((_local4.sinkLevel_ > 0)))) {
                    z_ = (0.5 - (0.4 * (_local4.sinkLevel_ / Parameters._K_5)));
                }
            }
            return (true);
        }

        override public function removeFromMap():void {
            super.removeFromMap();
            releaseObjectId(this.ownerId_, this.bulletId_);
            this.multiHitDict_ = null;
            _wW_._ay(this);
        }

        override public function update(time:int, dt:int):Boolean {
            var _local5:Vector.<uint>;
            var _local7:Boolean;
            var _local8:int;
            var _local9:Boolean;
            var _local3:int = (time - this.startTime_);
            if (_local3 > this.projProps_.lifetime_) {
                return (false);
            }
            var _local4:Point = this.tempPoint_;
            this.positionAt(_local3, _local4);
            if (((!(this.moveTo(_local4.x, _local4.y))) || ((square_.tileType_ == 0xFF)))) {
                if (this.damagesPlayers_) {
                    map_.gs_.gsc_.squareHit(time, this.bulletId_, this.ownerId_);
                } else {
                    if (square_.obj_ != null) {
                        _local5 = _7t._tD_(this.texture_);
                        map_.addObj(new HitEffect(_local5, 100, 3, this.angle_, this.projProps_.speed_), _local4.x, _local4.y);
                    }
                }
                return (false);
            }
            if (((((!((square_.obj_ == null))) && (((!(square_.obj_.props_.isEnemy_)) || (!(this.damagesEnemies_)))))) && (((square_.obj_.props_.enemyOccupySquare_) || (((!(this.projProps_.passesCover_)) && (square_.obj_.props_.occupySquare_))))))) {
                if (this.damagesPlayers_) {
                    map_.gs_.gsc_.otherHit(time, this.bulletId_, this.ownerId_, square_.obj_.objectId_);
                } else {
                    _local5 = _7t._tD_(this.texture_);
                    map_.addObj(new HitEffect(_local5, 100, 3, this.angle_, this.projProps_.speed_), _local4.x, _local4.y);
                }
                return (false);
            }
            var _local6:GameObject = this.getHit(_local4.x, _local4.y);
            if (_local6 != null) {
                _local7 = false;
                if (this.damagesPlayers_) {
                    _local7 = true;
                } else if (this.ownerId_ == map_.player_.objectId_) {
                    _local7 = true;
                } else if (_local6 == map_.player_) {
                    _local7 = true;
                }
                if (((_local7) && (!(map_.player_.isPaused())))) {
                    _local8 = GameObject.getDamageAfterDefense(this.damage_, _local6.defense_, this.projProps_.armorPiercing_, _local6.condition_);
                    _local9 = false;
                    if (_local6.HP_ <= _local8) {
                        _local9 = true;
                        if (_local6.props_.isEnemy_) {
                            doneAction(map_.gs_, Tutorial.KILL);
                        }
                    }
                    if (_local6 == map_.player_) {
                        map_.gs_.gsc_.playerHit(this.bulletId_, this.ownerId_);
                        _local6.damage(this.containerType_, _local8, this.projProps_.effects_, false, this);
                    } else {
                        if (_local6.props_.isEnemy_) {
                            map_.gs_.gsc_.enemyHit(time, this.bulletId_, _local6.objectId_, _local9, _local8);
                            _local6.damage(this.containerType_, _local8, this.projProps_.effects_, _local9, this);
                        } else {
                            if (!this.projProps_.multiHit_) {
                                map_.gs_.gsc_.otherHit(time, this.bulletId_, this.ownerId_, _local6.objectId_);
                            }
                        }
                    }
                }
                if (this.projProps_.multiHit_) {
                    this.multiHitDict_[_local6] = true;
                } else {
                    return (false);
                }
            }
            return (true);
        }

        override public function draw(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
            var _local6:uint;
            var _local7:uint;
            if (!Parameters._Q_w) {
                return;
            }
            var _local4:BitmapData = this.texture_;
            if (Parameters._Q_b != 0) {
                switch (Parameters._Q_b) {
                    case 1:
                        _local6 = 16777100;
                        _local7 = 0xFFFFFF;
                        break;
                    case 2:
                        _local6 = 16777100;
                        _local7 = 16777100;
                        break;
                    case 3:
                        _local6 = 0xFF0000;
                        _local7 = 0xFF0000;
                        break;
                    case 4:
                        _local6 = 0xFF;
                        _local7 = 0xFF;
                        break;
                    case 5:
                        _local6 = 0xFFFFFF;
                        _local7 = 0xFFFFFF;
                        break;
                    case 6:
                        _local6 = 0;
                        _local7 = 0;
                        break;
                }
                _local4 = TextureRedrawer.redraw(_local4, 120, true, _local6, _local7);
            }
            var _local5:Number = (((this.props_.rotation_ == 0)) ? 0 : (time / this.props_.rotation_));
            this.tempVec3D_.x = x_;
            this.tempVec3D_.y = y_;
            this.tempVec3D_.z = z_;
            this.billboard_.draw(graphicsData, this.tempVec3D_, (((this.angle_ - camera.angleRad_) + this.props_.angleCorrection_) + _local5), camera.wToS_, camera, _local4);
            if (this.projProps_.particleTrail_) {
                if (!Parameters.data_["disableParticles"]) {
                    map_.addObj(new SparkParticle(100, this.projProps_.trailColor_, 600, 0.5, _04d._F_e(3), _04d._F_e(3)), x_, y_);
                    map_.addObj(new SparkParticle(100, this.projProps_.trailColor_, 600, 0.5, _04d._F_e(3), _04d._F_e(3)), x_, y_);
                    map_.addObj(new SparkParticle(100, this.projProps_.trailColor_, 600, 0.5, _04d._F_e(3), _04d._F_e(3)), x_, y_);
                }
            }
        }

        override public function drawShadow(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
            if (!Parameters._Q_w) {
                return;
            }
            var _local4:Number = (this.props_.shadowSize_ / 400);
            var _local5:Number = (30 * _local4);
            var _local6:Number = (15 * _local4);
            this.shadowFill_.matrix.createGradientBox((_local5 * 2), (_local6 * 2), 0, (screenVec_[0] - _local5), (screenVec_[1] - _local6));
            graphicsData.push(this.shadowFill_);
            this.shadowPath_.data.length = 0;
            this.shadowPath_.data.push((screenVec_[0] - _local5), (screenVec_[1] - _local6), (screenVec_[0] + _local5), (screenVec_[1] - _local6), (screenVec_[0] + _local5), (screenVec_[1] + _local6), (screenVec_[0] - _local5), (screenVec_[1] + _local6));
            graphicsData.push(this.shadowPath_);
            graphicsData.push(GraphicHelper.END_FILL);
        }

        public function reset(containerType:int, bulletType:int, ownerId:int, bulletId:int, angle:Number, startTime:int):void {
            var _local8:Number;
            clear();
            this.containerType_ = containerType;
            this.bulletType_ = bulletType;
            this.ownerId_ = ownerId;
            this.bulletId_ = bulletId;
            this.angle_ = Trig._V_r(angle);
            this.startTime_ = startTime;
            objectId_ = allocateObjectId(this.ownerId_, this.bulletId_);
            z_ = 0.5;
            this.containerProps_ = ObjectLibrary.typeToProps_[this.containerType_];
            this.projProps_ = this.containerProps_.projectiles_[bulletType];
            this.props_ = ObjectLibrary.getPropsFromId(this.projProps_.objectId_);
            hasShadow_ = (this.props_.shadowSize_ > 0);
            var _local7:TextureData = ObjectLibrary.typeToTextureData_[this.props_.type_];
            this.texture_ = _local7.getTexture(objectId_);
            this.damagesPlayers_ = this.containerProps_.isEnemy_;
            this.damagesEnemies_ = !(this.damagesPlayers_);
            this.sound_ = this.containerProps_.oldSound_;
            this.multiHitDict_ = ((this.projProps_.multiHit_) ? new Dictionary() : null);
            if (this.projProps_.size_ >= 0) {
                _local8 = this.projProps_.size_;
            } else {
                _local8 = ObjectLibrary.getSizeFromType(this.containerType_);
            }
            this.billboard_.setSize((8 * (_local8 / 100)));
            this.damage_ = 0;
        }

        public function setDamage(damage:int):void {
            this.damage_ = damage;
        }

        public function moveTo(x:Number, y:Number):Boolean {
            var _local3:Square = map_.getSquare(x, y);
            if (_local3 == null) {
                return (false);
            }
            x_ = x;
            y_ = y;
            square_ = _local3;
            return (true);
        }

        public function getHit(x:Number, y:Number):GameObject {
            var _local5:GameObject;
            var _local6:Number;
            var _local7:Number;
            var _local8:Number;
            var _local3:Number = Number.MAX_VALUE;
            var _local4:GameObject;
            for each (_local5 in map_.goDict_) {
                if (!_local5.isInvincible()) {
                    if (!_local5.isStasis()) {
                        if ((this.damagesEnemies_ && _local5.objectId_ != this.ownerId_ && ((_local5.pvp_ && _local5.props_.isPlayer_) || _local5.props_.isEnemy_)) || (this.damagesPlayers_ && _local5.props_.isPlayer_)) {
                            if (!((_local5.dead_) || (_local5.isPaused()))) {
                                _local6 = (((_local5.x_ > x)) ? (_local5.x_ - x) : (x - _local5.x_));
                                _local7 = (((_local5.y_ > y)) ? (_local5.y_ - y) : (y - _local5.y_));
                                if (!(((_local6 > _local5.radius_)) || ((_local7 > _local5.radius_)))) {
                                    if (!((this.projProps_.multiHit_) && (!((this.multiHitDict_[_local5] == null))))) {
                                        if (_local5 == map_.player_ || _local5.props_.isPlayer_) {
                                            var _owner:GameObject = map_.goDict_[this.ownerId_];
                                            if (_owner is Player) {
                                                if (_owner != null) {
                                                    if (_local5.canBeHitBy(_owner)) {
                                                        return (_local5);
                                                    } else {
                                                        continue;
                                                    }
                                                } else {
                                                    return (_local5);
                                                }
                                            }
                                        }
                                        _local8 = Math.sqrt(((_local6 * _local6) + (_local7 * _local7)));
                                        if (_local8 < _local3) {
                                            _local3 = _local8;
                                            _local4 = _local5;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return (_local4);
        }

        private function positionAt(elapsed:int, point:Point):void {
            var _local5:Number;
            var _local6:Number;
            var _local7:Number;
            var _local8:Number;
            var _local9:Number;
            var _local10:Number;
            var _local11:Number;
            var _local12:Number;
            var _local13:Number;
            var _local14:Number;
            point.x = this.startX_;
            point.y = this.startY_;
            var _local3:Number = (elapsed * (this.projProps_.speed_ / 10000));
            var _local4:Number = ((((this.bulletId_ % 2)) == 0) ? 0 : Math.PI);
            if (this.projProps_.wavy_) {
                _local5 = (6 * Math.PI);
                _local6 = (Math.PI / 64);
                _local7 = (this.angle_ + (_local6 * Math.sin((_local4 + ((_local5 * elapsed) / 1000)))));
                point.x = (point.x + (_local3 * Math.cos(_local7)));
                point.y = (point.y + (_local3 * Math.sin(_local7)));
            } else {
                if (this.projProps_.parametric_) {
                    _local8 = (((elapsed / this.projProps_.lifetime_) * 2) * Math.PI);
                    _local9 = (Math.sin(_local8) * (((this.bulletId_ % 2)) ? 1 : -1));
                    _local10 = (Math.sin((2 * _local8)) * ((((this.bulletId_ % 4)) < 2) ? 1 : -1));
                    _local11 = Math.sin(this.angle_);
                    _local12 = Math.cos(this.angle_);
                    point.x = (point.x + (((_local9 * _local12) - (_local10 * _local11)) * this.projProps_.magnitude_));
                    point.y = (point.y + (((_local9 * _local11) + (_local10 * _local12)) * this.projProps_.magnitude_));
                } else {
                    if (this.projProps_.boomerang_) {
                        _local13 = ((this.projProps_.lifetime_ * (this.projProps_.speed_ / 10000)) / 2);
                        if (_local3 > _local13) {
                            _local3 = (_local13 - (_local3 - _local13));
                        }
                    }
                    point.x = (point.x + (_local3 * Math.cos(this.angle_)));
                    point.y = (point.y + (_local3 * Math.sin(this.angle_)));
                    if (this.projProps_.amplitude_ != 0) {
                        _local14 = (this.projProps_.amplitude_ * Math.sin((_local4 + ((((elapsed / this.projProps_.lifetime_) * this.projProps_.frequency_) * 2) * Math.PI))));
                        point.x = (point.x + (_local14 * Math.cos((this.angle_ + (Math.PI / 2)))));
                        point.y = (point.y + (_local14 * Math.sin((this.angle_ + (Math.PI / 2)))));
                    }
                }
            }
        }

    }
}//package com.company.assembleegameclient.objects
