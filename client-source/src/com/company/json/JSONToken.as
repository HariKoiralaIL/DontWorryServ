package com.company.json {
public class JSONToken {

    private var _type:int;
    private var _value:Object;

    public function JSONToken(type:int = -1, value:Object = null) {
        this._type = type;
        this._value = value;
    }

    public function get value():Object {
        return this._value;
    }

    public function set value(v:Object):void {
        this._value = v;
    }

    public function get type_():int {
        return this._type;
    }

    public function set type_(t:int):void {
        this._type = t;
    }

}
}
