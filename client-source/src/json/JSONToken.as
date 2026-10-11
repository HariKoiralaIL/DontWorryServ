package json {
public class JSONToken {

    private var _type:int;
    private var _value:Object;

    public function JSONToken(type:int = -1, value:Object = null) {
        _type = type;
        _value = value;
    }

    public function get value():Object {
        return _value;
    }

    public function set value(v:Object):void {
        _value = v;
    }

    public function get type_():int {
        return _type;
    }

    public function set type_(t:int):void {
        _type = t;
    }

}
}
