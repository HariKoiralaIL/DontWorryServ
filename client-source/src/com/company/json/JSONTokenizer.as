package com.company.json {
public class JSONTokenizer {

    private var jsonString:String;
    private var loc:int;
    private var ch:String;

    public function JSONTokenizer(s:String) {
        this.jsonString = s;
        this.loc = 0;
        this.nextChar();
    }

    public function getNextToken():JSONToken {
        var tmp:String;
        var token:JSONToken = new JSONToken();
        this.skipIgnored();
        switch (this.ch) {
            case "{":
                token.type_ = JSONTokenType.LEFT_BRACE;
                token.value = "{";
                this.nextChar();
                break;
            case "}":
                token.type_ = JSONTokenType.RIGHT_BRACE;
                token.value = "}";
                this.nextChar();
                break;
            case "[":
                token.type_ = JSONTokenType.LEFT_BRACKET;
                token.value = "[";
                this.nextChar();
                break;
            case "]":
                token.type_ = JSONTokenType.RIGHT_BRACKET;
                token.value = "]";
                this.nextChar();
                break;
            case ",":
                token.type_ = JSONTokenType.COMMA;
                token.value = ",";
                this.nextChar();
                break;
            case ":":
                token.type_ = JSONTokenType.COLON;
                token.value = ":";
                this.nextChar();
                break;
            case "t":
                tmp = "t" + this.nextChar() + this.nextChar() + this.nextChar();
                if (tmp == "true") {
                    token.type_ = JSONTokenType.TRUE;
                    token.value = true;
                    this.nextChar();
                } else {
                    this.parseError("Expecting 'true' but found " + tmp);
                }
                break;
            case "f":
                tmp = "f" + this.nextChar() + this.nextChar() + this.nextChar() + this.nextChar();
                if (tmp == "false") {
                    token.type_ = JSONTokenType.FALSE;
                    token.value = false;
                    this.nextChar();
                } else {
                    this.parseError("Expecting 'false' but found " + tmp);
                }
                break;
            case "n":
                tmp = "n" + this.nextChar() + this.nextChar() + this.nextChar();
                if (tmp == "null") {
                    token.type_ = JSONTokenType.NULL;
                    token.value = null;
                    this.nextChar();
                } else {
                    this.parseError("Expecting 'null' but found " + tmp);
                }
                break;
            case '"':
                token = this.readString();
                break;
            default:
                if (this.isDigit(this.ch) || this.ch == "-") {
                    token = this.readNumber();
                } else {
                    if (this.ch == "") {
                        return null;
                    }
                    this.parseError("Unexpected " + this.ch + " encountered");
                }
        }
        return token;
    }

    public function parseError(message:String):void {
        throw new JSONParseError(message, this.loc, this.jsonString);
    }

    private function readString():JSONToken {
        var hex:String;
        var i:int;
        var token:JSONToken = new JSONToken();
        token.type_ = JSONTokenType.STRING;
        var s:String = "";
        this.nextChar();
        while (this.ch != '"' && this.ch != "") {
            if (this.ch == "\\") {
                this.nextChar();
                switch (this.ch) {
                    case '"':
                        s += '"';
                        break;
                    case "/":
                        s += "/";
                        break;
                    case "\\":
                        s += "\\";
                        break;
                    case "b":
                        s += "\b";
                        break;
                    case "f":
                        s += "\f";
                        break;
                    case "n":
                        s += "\n";
                        break;
                    case "r":
                        s += "\r";
                        break;
                    case "t":
                        s += "\t";
                        break;
                    case "u":
                        hex = "";
                        i = 0;
                        while (i < 4) {
                            if (!this.isHexDigit(this.nextChar())) {
                                this.parseError(" Excepted a hex digit, but found: " + this.ch);
                            }
                            hex += this.ch;
                            i++;
                        }
                        s += String.fromCharCode(parseInt(hex, 16));
                        break;
                    default:
                        s += "\\" + this.ch;
                }
            } else {
                s += this.ch;
            }
            this.nextChar();
        }
        if (this.ch == "") {
            this.parseError("Unterminated string literal");
        }
        this.nextChar();
        token.value = s;
        return token;
    }

    private function readNumber():JSONToken {
        var token:JSONToken = new JSONToken();
        token.type_ = JSONTokenType.NUMBER;
        var s:String = "";
        if (this.ch == "-") {
            s += "-";
            this.nextChar();
        }
        if (!this.isDigit(this.ch)) {
            this.parseError("Expecting a digit");
        }
        if (this.ch == "0") {
            s += this.ch;
            this.nextChar();
            if (this.isDigit(this.ch)) {
                this.parseError("A digit cannot immediately follow 0");
            }
        } else {
            while (this.isDigit(this.ch)) {
                s += this.ch;
                this.nextChar();
            }
        }
        if (this.ch == ".") {
            s += ".";
            this.nextChar();
            if (!this.isDigit(this.ch)) {
                this.parseError("Expecting a digit");
            }
            while (this.isDigit(this.ch)) {
                s += this.ch;
                this.nextChar();
            }
        }
        if (this.ch == "e" || this.ch == "E") {
            s += "e";
            this.nextChar();
            if (this.ch == "+" || this.ch == "-") {
                s += this.ch;
                this.nextChar();
            }
            if (!this.isDigit(this.ch)) {
                this.parseError("Scientific notation number needs exponent value");
            }
            while (this.isDigit(this.ch)) {
                s += this.ch;
                this.nextChar();
            }
        }
        var num:Number = Number(s);
        if (isFinite(num) && !isNaN(num)) {
            token.value = num;
            return token;
        }
        this.parseError("Number " + num + " is not valid!");
        return null;
    }

    private function nextChar():String {
        return (this.ch = this.jsonString.charAt(this.loc++));
    }

    private function skipIgnored():void {
        var prev:int;
        do {
            prev = this.loc;
            this.skipWhite();
            this.skipComments();
        } while (prev != this.loc);
    }

    private function skipComments():void {
        if (this.ch == "/") {
            this.nextChar();
            switch (this.ch) {
                case "/":
                    do {
                        this.nextChar();
                    } while (this.ch != "\n" && this.ch != "");
                    this.nextChar();
                    return;
                case "*":
                    this.nextChar();
                    while (true) {
                        if (this.ch == "*") {
                            this.nextChar();
                            if (this.ch == "/") {
                                this.nextChar();
                                break;
                            }
                        } else {
                            this.nextChar();
                        }
                        if (this.ch == "") {
                            this.parseError("Multi-line comment not closed");
                        }
                    }
                    return;
                default:
                    this.parseError("Unexpected " + this.ch + " encountered (expecting '/' or '*' )");
            }
        }
    }

    private function skipWhite():void {
        while (this.isWhiteSpace(this.ch)) {
            this.nextChar();
        }
    }

    private function isWhiteSpace(c:String):Boolean {
        return c == " " || c == "\t" || c == "\n" || c == "\r";
    }

    private function isDigit(c:String):Boolean {
        return c >= "0" && c <= "9";
    }

    private function isHexDigit(c:String):Boolean {
        var u:String = c.toUpperCase();
        return this.isDigit(c) || (u >= "A" && u <= "F");
    }

}
}
