package com.company.json {
// Formerly _0D_n._P_I_. Lazily creates and returns the shared IJsonParser.
public class JsonParserLocator {

    private static var instance:IJsonParser;

    // Formerly _dJ_
    public static function getInstance():IJsonParser {
        return instance = instance || new JsonParser();
    }

}
}
