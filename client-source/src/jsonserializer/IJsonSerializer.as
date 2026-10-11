package jsonserializer {

/** Converts objects to JSON text and back. */
public interface IJsonSerializer {

    function stringify(value:Object):String;

    function parse(json:String):Object;

}
}//package jsonserializer
