package com.company.json {
// Formerly _0D_n._iC_. Default IJsonParser, backed by JSONCodec.
public class JsonParser implements IJsonParser {

    public function stringify(value:Object):String {
        return JSONCodec.encode(value);
    }

    public function parse(json:String):Object {
        return JSONCodec.decode(json);
    }

}
}
