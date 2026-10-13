package com.company.assembleegameclient.objects {
    import com.company.assembleegameclient.engine3d.Object3D;
    import com.company.assembleegameclient.engine3d.ObjectFace3D;

    public class Stalagmite extends GameObject {

        private static const BASE_ANGLE:Number = (Math.PI / 6);//0.523598775598299
        private static const ANGLE_STEP:Number = (Math.PI / 3);//1.0471975511966

        public function Stalagmite(xml:XML) {
            super(xml);
            var _local2:Number = (BASE_ANGLE + (ANGLE_STEP * Math.random()));
            var _local3:Number = (((2 * ANGLE_STEP) + BASE_ANGLE) + (ANGLE_STEP * Math.random()));
            var _local4:Number = (((4 * ANGLE_STEP) + BASE_ANGLE) + (ANGLE_STEP * Math.random()));
            obj3D_ = new Object3D();
            obj3D_.vertices_.push((Math.cos(_local2) * 0.3), (Math.sin(_local2) * 0.3), 0, (Math.cos(_local3) * 0.3), (Math.sin(_local3) * 0.3), 0, (Math.cos(_local4) * 0.3), (Math.sin(_local4) * 0.3), 0, 0, 0, (0.6 + (0.6 * Math.random())));
            obj3D_.faces_.push(new ObjectFace3D(obj3D_, new <int>[0, 1, 3]), new ObjectFace3D(obj3D_, new <int>[1, 2, 3]), new ObjectFace3D(obj3D_, new <int>[2, 0, 3]));
            obj3D_.uvts_.push(0, 1, 0, 0.5, 1, 0, 1, 1, 0, 0.5, 0, 0);
        }
    }
}//package com.company.assembleegameclient.objects
