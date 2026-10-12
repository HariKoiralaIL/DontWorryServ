package com.company.assembleegameclient.engine3d {
import flash.geom.Vector3D;

public class Lighting {

    public static const LIGHT_VECTOR:Vector3D = createLightVector();

    /** Returns brightness in [ambient, 1] for a surface with the given normal. */
    public static function getBrightness(normal:Vector3D, ambient:Number):Number {
        var diffuse:Number = Math.max(0, normal.dotProduct(LIGHT_VECTOR));
        return ambient + (1 - ambient) * diffuse;
    }

    private static function createLightVector():Vector3D {
        var light:Vector3D = new Vector3D(1, 3, 2);
        light.normalize();
        return light;
    }

}
}
