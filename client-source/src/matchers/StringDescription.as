package matchers {

/** A Description that builds up a string. */
public class StringDescription extends BaseDescription {

    private var _out:String;

    public function StringDescription() {
        clear();
    }

    public static function toString(selfDescribing:SelfDescribing):String {
        return new StringDescription().appendDescriptionOf(selfDescribing).toString();
    }

    override protected function append(value:Object):void {
        _out += String(value);
    }

    override public function toString():String {
        return _out;
    }

    public function clear():void {
        _out = "";
    }

}
}
