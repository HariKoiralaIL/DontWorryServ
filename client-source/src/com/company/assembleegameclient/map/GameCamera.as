package com.company.assembleegameclient.map {
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.util.MathUtil;
import com.company.util.Trig;

import flash.geom.Matrix3D;
import flash.geom.PerspectiveProjection;
import flash.geom.Rectangle;
import flash.geom.Vector3D;

public class GameCamera {

    public static const Z_AXIS:Vector3D = new Vector3D(0, 0, 1);

    private static const CENTERED_RECT:Rectangle = new Rectangle(-300, -325, 600, 600);
    private static const OFFSET_RECT:Rectangle = new Rectangle(-300, -450, 600, 600);
    private static const WIDE_RECT:Rectangle = new Rectangle(-400, -325, 800, 600);
    private static const WIDE_SHORT_RECT:Rectangle = new Rectangle(-400, -275, 800, 500);
    private static const MAX_SHAKE:Number = 0.5;
    private static const SHAKE_BUILDUP_MS:int = 10000;

    public var x_:Number;
    public var y_:Number;
    public var z_:Number;
    public var angleRad_:Number;
    public var clipRect_:Rectangle;
    public var perspective_:PerspectiveProjection;
    public var maxDist_:Number;
    public var maxDistSq_:Number;
    public var isHallucinating_:Boolean = false;
    public var wToS_:Matrix3D;
    public var wToV_:Matrix3D;
    public var vToS_:Matrix3D;
    public var perspectiveMatrix_:Matrix3D;
    private var nonPerspectiveMatrix_:Matrix3D;
    private var pos_:Vector3D;
    private var zVec_:Vector3D;
    private var yVec_:Vector3D;
    private var xVec_:Vector3D;
    private var isShaking_:Boolean = false;
    private var shakeAmount_:Number = 0;
    private var rawData_:Vector.<Number>;

    public function GameCamera() {
        this.perspective_ = new PerspectiveProjection();
        this.wToS_ = new Matrix3D();
        this.wToV_ = new Matrix3D();
        this.vToS_ = new Matrix3D();
        this.nonPerspectiveMatrix_ = new Matrix3D();
        this.pos_ = new Vector3D();
        this.zVec_ = new Vector3D();
        this.yVec_ = new Vector3D();
        this.xVec_ = new Vector3D();
        this.rawData_ = new Vector.<Number>(16, true);
        super();
        this.perspective_.focalLength = 3;
        this.perspective_.fieldOfView = 48;
        this.perspectiveMatrix_ = this.perspective_.toMatrix3D();
        this.nonPerspectiveMatrix_.appendScale(50, 50, 50);
        this.zVec_.x = 0;
        this.zVec_.y = 0;
        this.zVec_.z = -1;
    }

    public function configureForPlayer(player:Player):void {
        var rect:Rectangle = Parameters.data_.centerOnPlayer ? CENTERED_RECT : OFFSET_RECT;
        if (Parameters._0F_o) {
            rect = Parameters._ih ? WIDE_SHORT_RECT : WIDE_RECT;
        }
        this.configure(player.x_, player.y_, 12, Parameters.data_.cameraAngle, rect, false);
        this.isHallucinating_ = player.isNinjaSpeedy();
    }

    public function startShake():void {
        this.isShaking_ = true;
        this.shakeAmount_ = 0;
    }

    public function update(dt:Number):void {
        if (this.isShaking_ && this.shakeAmount_ < MAX_SHAKE) {
            this.shakeAmount_ += dt * MAX_SHAKE / SHAKE_BUILDUP_MS;
            if (this.shakeAmount_ > MAX_SHAKE) {
                this.shakeAmount_ = MAX_SHAKE;
            }
        }
    }

    public function configure(x:Number, y:Number, z:Number, angleRad:Number, clipRect:Rectangle, usePerspective:Boolean):void {
        if (this.isShaking_) {
            x += MathUtil.randomSpread(this.shakeAmount_);
            y += MathUtil.randomSpread(this.shakeAmount_);
        }
        this.x_ = x;
        this.y_ = y;
        this.z_ = z;
        this.angleRad_ = angleRad;
        this.clipRect_ = clipRect;
        this.pos_.x = x;
        this.pos_.y = y;
        this.pos_.z = z;
        this.xVec_.x = Math.cos(this.angleRad_);
        this.xVec_.y = Math.sin(this.angleRad_);
        this.xVec_.z = 0;
        this.yVec_.x = Math.cos(this.angleRad_ + Math.PI / 2);
        this.yVec_.y = Math.sin(this.angleRad_ + Math.PI / 2);
        this.yVec_.z = 0;
        this.rawData_[0] = this.xVec_.x;
        this.rawData_[1] = this.yVec_.x;
        this.rawData_[2] = this.zVec_.x;
        this.rawData_[3] = 0;
        this.rawData_[4] = this.xVec_.y;
        this.rawData_[5] = this.yVec_.y;
        this.rawData_[6] = this.zVec_.y;
        this.rawData_[7] = 0;
        this.rawData_[8] = this.xVec_.z;
        this.rawData_[9] = usePerspective ? this.yVec_.z : -1;
        this.rawData_[10] = this.zVec_.z;
        this.rawData_[11] = 0;
        this.rawData_[12] = -this.pos_.dotProduct(this.xVec_);
        this.rawData_[13] = -this.pos_.dotProduct(this.yVec_);
        this.rawData_[14] = -this.pos_.dotProduct(this.zVec_);
        this.rawData_[15] = 1;
        this.wToV_.rawData = this.rawData_;
        this.vToS_ = usePerspective ? this.perspectiveMatrix_ : this.nonPerspectiveMatrix_;
        this.wToS_.identity();
        this.wToS_.append(this.wToV_);
        this.wToS_.append(this.vToS_);

        //I can already feel it will take me a long time to get this part right...
        var viewingDistance:int = (projectblogo.sHeight / 600) + (projectblogo.sWidth / 600) + (projectblogo.sHeight / 600) + (projectblogo.sWidth / 600) / (Parameters.data_["mscale"]);
        if (usePerspective) {
            var halfFovTan:Number = this.z_ * Math.tan((this.perspective_.fieldOfView / 2) * Trig._km);
            this.maxDist_ = Math.SQRT2 * halfFovTan * 1.4;
        } else {
            var halfWidth:Number = this.clipRect_.width / (2 * 50);
            var halfHeight:Number = this.clipRect_.height / (2 * 50);
            this.maxDist_ = Math.sqrt(halfWidth * halfWidth + halfHeight * halfHeight) + viewingDistance;
        }
        this.maxDistSq_ = this.maxDist_ * this.maxDist_;
    }

}
}
