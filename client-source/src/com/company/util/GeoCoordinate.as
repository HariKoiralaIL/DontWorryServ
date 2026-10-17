package com.company.util {
public class GeoCoordinate {

    /** Great-circle distance in meters. */
    public static function distance(a:GeoCoordinate, b:GeoCoordinate):Number {
        var deltaLongitude:Number = Trig.DEG_TO_RAD * (a.longitude_ - b.longitude_);
        var latitudeA:Number = Trig.DEG_TO_RAD * a.latitude_;
        var latitudeB:Number = Trig.DEG_TO_RAD * b.latitude_;
        var cosine:Number = (Math.sin(latitudeA) * Math.sin(latitudeB)) + ((Math.cos(latitudeA) * Math.cos(latitudeB)) * Math.cos(deltaLongitude));
        return (((Trig.RAD_TO_DEG * Math.acos(cosine)) * 60) * 1.1515 * 1.609344) * 1000;
    }

    public function GeoCoordinate(latitude:Number, longitude:Number) {
        this.latitude_ = latitude;
        this.longitude_ = longitude;
    }

    public var latitude_:Number;
    public var longitude_:Number;

    public function toString():String {
        return "(" + this.latitude_ + ", " + this.longitude_ + ")";
    }

}
}//package com.company.util
