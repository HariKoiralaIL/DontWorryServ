package matchers {
import matchers.BaseMatcher;
import matchers.Description;

public class IsEqual extends BaseMatcher {

    private var _value:Object;

    public function IsEqual(value:Object) {
        _value = value;
    }

    override public function matches(item:Object):Boolean {
        return areEqual(item, _value);
    }

    override public function describeTo(description:Description):void {
        description.appendValue(_value);
    }

    private function areEqual(a:Object, b:Object):Boolean {
        if (isNaN(a as Number)) {
            return isNaN(b as Number);
        }
        if (a == null) {
            return b == null;
        }
        if (a is Array) {
            return b is Array && areArraysEqual(a as Array, b as Array);
        }
        return a == b;
    }

    private function areArraysEqual(a:Array, b:Array):Boolean {
        return a.length == b.length && areElementsEqual(a, b);
    }

    private function areElementsEqual(a:Array, b:Array):Boolean {
        var count:int = a.length;
        for (var i:int = 0; i < count; i++) {
            if (!areEqual(a[i], b[i])) {
                return false;
            }
        }
        return true;
    }

}
}
