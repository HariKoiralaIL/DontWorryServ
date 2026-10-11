package json {
public class JSONDecoder {

    private var value:*;
    private var tokenizer:JSONTokenizer;
    private var token:JSONToken;

    public function JSONDecoder(s:String) {
        tokenizer = new JSONTokenizer(s);
        nextToken();
        value = parseValue();
    }

    public function getValue():* {
        return value;
    }

    private function nextToken():JSONToken {
        return token = tokenizer.getNextToken();
    }

    private function parseArray():Array {
        var arr:Array = [];
        nextToken();
        if (token.type_ == JSONTokenType.RIGHT_BRACKET) {
            return arr;
        }
        while (true) {
            arr.push(parseValue());
            nextToken();
            if (token.type_ == JSONTokenType.RIGHT_BRACKET) {
                return arr;
            }
            if (token.type_ == JSONTokenType.COMMA) {
                nextToken();
            } else {
                tokenizer.parseError("Expecting ] or , but found " + token.value);
            }
        }
        return null;
    }

    private function parseObject():Object {
        var key:String;
        var obj:Object = {};
        nextToken();
        if (token.type_ == JSONTokenType.RIGHT_BRACE) {
            return obj;
        }
        while (true) {
            if (token.type_ == JSONTokenType.STRING) {
                key = String(token.value);
                nextToken();
                if (token.type_ == JSONTokenType.COLON) {
                    nextToken();
                    obj[key] = parseValue();
                    nextToken();
                    if (token.type_ == JSONTokenType.RIGHT_BRACE) {
                        return obj;
                    }
                    if (token.type_ == JSONTokenType.COMMA) {
                        nextToken();
                    } else {
                        tokenizer.parseError("Expecting } or , but found " + token.value);
                    }
                } else {
                    tokenizer.parseError("Expecting : but found " + token.value);
                }
            } else {
                tokenizer.parseError("Expecting string but found " + token.value);
            }
        }
        return null;
    }

    private function parseValue():Object {
        if (token == null) {
            tokenizer.parseError("Unexpected end of input");
        }
        switch (token.type_) {
            case JSONTokenType.LEFT_BRACE:
                return parseObject();
            case JSONTokenType.LEFT_BRACKET:
                return parseArray();
            case JSONTokenType.STRING:
            case JSONTokenType.NUMBER:
            case JSONTokenType.TRUE:
            case JSONTokenType.FALSE:
            case JSONTokenType.NULL:
                return token.value;
            default:
                tokenizer.parseError("Unexpected " + token.value);
        }
        return null;
    }

}
}
