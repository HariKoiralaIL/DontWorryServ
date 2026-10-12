package com.company.assembleegameclient.net {
import com.company.util._0K_N_;

public class Server {

    private static const CROWDED_THRESHOLD:Number = 0.66;
    private static const FULL_THRESHOLD:Number = 1;

    private static const PRIORITY_NORMAL:int = 0;
    private static const PRIORITY_CROWDED:int = 1;
    private static const PRIORITY_ADMIN:int = 6;

    public var name_:String;
    public var address_:String;
    public var port_:int;
    public var latLong_:_0K_N_;
    public var usage_:Number;
    public var isAdminOnly_:Boolean;

    public function Server(name:String, address:String, port:int, latLong:_0K_N_ = null, usage:Number = 0, isAdminOnly:Boolean = false):void {
        this.name_ = name;
        this.address_ = address;
        this.port_ = port;
        this.latLong_ = latLong;
        this.usage_ = usage;
        this.isAdminOnly_ = isAdminOnly;
    }

    public function setName(name:String):Server {
        this.name_ = name;
        return this;
    }

    public function setAddress(address:String):Server {
        this.address_ = address;
        return this;
    }

    public function setPort(port:int):Server {
        this.port_ = port;
        return this;
    }

    public function setLatLong(latitude:Number, longitude:Number):Server {
        this.latLong_ = new _0K_N_(latitude, longitude);
        return this;
    }

    public function setUsage(usage:Number):Server {
        this.usage_ = usage;
        return this;
    }

    public function setIsAdminOnly(isAdminOnly:Boolean):Server {
        this.isAdminOnly_ = isAdminOnly;
        return this;
    }

    public function priority():int {
        if (this.isAdminOnly_) {
            return PRIORITY_ADMIN;
        }
        if (this.isCrowded()) {
            return PRIORITY_CROWDED;
        }
        return PRIORITY_NORMAL;
    }

    public function isCrowded():Boolean {
        return this.usage_ >= CROWDED_THRESHOLD;
    }

    public function isFull():Boolean {
        return this.usage_ >= FULL_THRESHOLD;
    }

    public function toString():String {
        return "[" + this.name_ + ": " + this.address_ + ":" + this.port_ + ":" + this.latLong_ + ":" + this.usage_ + ":" + this.isAdminOnly_ + "]";
    }

}
}
