package matchers {
import matchers.BaseMatcher;
import matchers.Description;

import flash.utils.getQualifiedClassName;

public class IsInstanceOf extends BaseMatcher {

    private var _type:Class;
    private var _typeName:String;

    public function IsInstanceOf(type:Class) {
        _type = type;
        _typeName = getQualifiedClassName(type);
    }

    override public function matches(item:Object):Boolean {
        return item is _type;
    }

    override public function describeTo(description:Description):void {
        description.appendText("an instance of ").appendText(_typeName);
    }

}
}
