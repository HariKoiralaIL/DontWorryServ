package com.company.json {
public class JSONDecoder {

    private var value;
    private var tokenizer:JSONTokenizer;
    private var token:JSONToken;

    public function JSONDecoder(s:String) {
        this.tokenizer = new JSONTokenizer(s);
        this.nextToken();
        this.value = this.parseValue();
    }

    public function getValue() {
        return this.value;
    }

    private function nextToken():JSONToken {
        return (this.token = this.tokenizer.getNextToken());
    }

    private function parseArray():Array {
        var arr:Array = [];
        this.nextToken();
        if (this.token.type_ == JSONTokenType.RIGHT_BRACKET) {
            return arr;
        }
        while (true) {
            arr.push(this.parseValue());
            this.nextToken();
            if (this.token.type_ == JSONTokenType.RIGHT_BRACKET) {
                return arr;
            }
            if (this.token.type_ == JSONTokenType.COMMA) {
                this.nextToken();
            } else {
                this.tokenizer.parseError("Expecting ] or , but found " + this.token.value);
            }
        }
        return null;
    }

    private function parseObject():Object {
        var key:String;
        var obj:Object = {};
        this.nextToken();
        if (this.token.type_ == JSONTokenType.RIGHT_BRACE) {
            return obj;
        }
        while (true) {
            if (this.token.type_ == JSONTokenType.STRING) {
                key = String(this.token.value);
                this.nextToken();
                if (this.token.type_ == JSONTokenType.COLON) {
                    this.nextToken();
                    obj[key] = this.parseValue();
                    this.nextToken();
                    if (this.token.type_ == JSONTokenType.RIGHT_BRACE) {
                        return obj;
                    }
                    if (this.token.type_ == JSONTokenType.COMMA) {
                        this.nextToken();
                    } else {
                        this.tokenizer.parseError("Expecting } or , but found " + this.token.value);
                    }
                } else {
                    this.tokenizer.parseError("Expecting : but found " + this.token.value);
                }
            } else {
                this.tokenizer.parseError("Expecting string but found " + this.token.value);
            }
        }
        return null;
    }

    private function parseValue():Object {
        if (this.token == null) {
            this.tokenizer.parseError("Unexpected end of input");
        }
        switch (this.token.type_) {
            case JSONTokenType.LEFT_BRACE:
                return this.parseObject();
            case JSONTokenType.LEFT_BRACKET:
                return this.parseArray();
            case JSONTokenType.STRING:
            case JSONTokenType.NUMBER:
            case JSONTokenType.TRUE:
            case JSONTokenType.FALSE:
            case JSONTokenType.NULL:
                return this.token.value;
            default:
                this.tokenizer.parseError("Unexpected " + this.token.value);
        }
        return null;
    }

}
}
