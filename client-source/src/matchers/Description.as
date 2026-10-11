package matchers {

public interface Description {

    function toString():String;

    function appendText(text:String):Description;

    function appendDescriptionOf(value:SelfDescribing):Description;

    function appendMismatchOf(matcher:Matcher, value:*):Description;

    function appendValue(value:Object):Description;

    function appendList(start:String, separator:String, end:String, list:Array):Description;

}
}
