package jsonserializer {
import json.JSONCodec;

/** IJsonSerializer backed by json.JSONCodec. */
public class JsonSerializer implements IJsonSerializer {

    public function stringify(value:Object):String {
        return (JSONCodec.encode(value));
    }

    public function parse(json:String):Object {
        return (JSONCodec.decode(json));
    }

}
}//package jsonserializer
