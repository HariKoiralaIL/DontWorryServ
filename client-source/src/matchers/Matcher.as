package matchers {

public interface Matcher extends SelfDescribing {

    function matches(item:Object):Boolean;

    function describeMismatch(item:Object, description:Description):void;

}
}
