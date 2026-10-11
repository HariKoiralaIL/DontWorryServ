package json {
public class JSONTokenizer {

    private var jsonString:String;
    private var loc:int;
    private var ch:String;

    public function JSONTokenizer(s:String) {
        jsonString = s;
        loc = 0;
        nextChar();
    }

    public function getNextToken():JSONToken {
        var s:String;
        var token:JSONToken = new JSONToken();
        skipIgnored();
        switch (ch) {
            case "{":
                token.type_ = JSONTokenType.LEFT_BRACE;
                token.value = "{";
                nextChar();
                break;
            case "}":
                token.type_ = JSONTokenType.RIGHT_BRACE;
                token.value = "}";
                nextChar();
                break;
            case "[":
                token.type_ = JSONTokenType.LEFT_BRACKET;
                token.value = "[";
                nextChar();
                break;
            case "]":
                token.type_ = JSONTokenType.RIGHT_BRACKET;
                token.value = "]";
                nextChar();
                break;
            case ",":
                token.type_ = JSONTokenType.COMMA;
                token.value = ",";
                nextChar();
                break;
            case ":":
                token.type_ = JSONTokenType.COLON;
                token.value = ":";
                nextChar();
                break;
            case "t":
                s = "t" + nextChar() + nextChar() + nextChar();
                if (s == "true") {
                    token.type_ = JSONTokenType.TRUE;
                    token.value = true;
                    nextChar();
                } else {
                    parseError("Expecting 'true' but found " + s);
                }
                break;
            case "f":
                s = "f" + nextChar() + nextChar() + nextChar() + nextChar();
                if (s == "false") {
                    token.type_ = JSONTokenType.FALSE;
                    token.value = false;
                    nextChar();
                } else {
                    parseError("Expecting 'false' but found " + s);
                }
                break;
            case "n":
                s = "n" + nextChar() + nextChar() + nextChar();
                if (s == "null") {
                    token.type_ = JSONTokenType.NULL;
                    token.value = null;
                    nextChar();
                } else {
                    parseError("Expecting 'null' but found " + s);
                }
                break;
            case '"':
                token = readString();
                break;
            default:
                if (isDigit(ch) || ch == "-") {
                    token = readNumber();
                } else {
                    if (ch == "") {
                        return null;
                    }
                    parseError("Unexpected " + ch + " encountered");
                }
        }
        return token;
    }

    public function parseError(message:String):void {
        throw new JSONParseError(message, loc, jsonString);
    }

    private function readString():JSONToken {
        var hex:String;
        var i:int;
        var token:JSONToken = new JSONToken();
        token.type_ = JSONTokenType.STRING;
        var str:String = "";
        nextChar();
        while (ch != '"' && ch != "") {
            if (ch == "\\") {
                nextChar();
                switch (ch) {
                    case '"':
                        str += '"';
                        break;
                    case "/":
                        str += "/";
                        break;
                    case "\\":
                        str += "\\";
                        break;
                    case "b":
                        str += "\b";
                        break;
                    case "f":
                        str += "\f";
                        break;
                    case "n":
                        str += "\n";
                        break;
                    case "r":
                        str += "\r";
                        break;
                    case "t":
                        str += "\t";
                        break;
                    case "u":
                        hex = "";
                        i = 0;
                        while (i < 4) {
                            if (!isHexDigit(nextChar())) {
                                parseError(" Excepted a hex digit, but found: " + ch);
                            }
                            hex += ch;
                            i++;
                        }
                        str += String.fromCharCode(parseInt(hex, 16));
                        break;
                    default:
                        str += "\\" + ch;
                }
            } else {
                str += ch;
            }
            nextChar();
        }
        if (ch == "") {
            parseError("Unterminated string literal");
        }
        nextChar();
        token.value = str;
        return token;
    }

    private function readNumber():JSONToken {
        var token:JSONToken = new JSONToken();
        token.type_ = JSONTokenType.NUMBER;
        var s:String = "";
        if (ch == "-") {
            s += "-";
            nextChar();
        }
        if (!isDigit(ch)) {
            parseError("Expecting a digit");
        }
        if (ch == "0") {
            s += ch;
            nextChar();
            if (isDigit(ch)) {
                parseError("A digit cannot immediately follow 0");
            }
        } else {
            while (isDigit(ch)) {
                s += ch;
                nextChar();
            }
        }
        if (ch == ".") {
            s += ".";
            nextChar();
            if (!isDigit(ch)) {
                parseError("Expecting a digit");
            }
            while (isDigit(ch)) {
                s += ch;
                nextChar();
            }
        }
        if (ch == "e" || ch == "E") {
            s += "e";
            nextChar();
            if (ch == "+" || ch == "-") {
                s += ch;
                nextChar();
            }
            if (!isDigit(ch)) {
                parseError("Scientific notation number needs exponent value");
            }
            while (isDigit(ch)) {
                s += ch;
                nextChar();
            }
        }
        var num:Number = Number(s);
        if (isFinite(num) && !isNaN(num)) {
            token.value = num;
            return token;
        }
        parseError("Number " + num + " is not valid!");
        return null;
    }

    private function nextChar():String {
        return ch = jsonString.charAt(loc++);
    }

    private function skipIgnored():void {
        var start:int;
        do {
            start = loc;
            skipWhite();
            skipComments();
        } while (start != loc);
    }

    private function skipComments():void {
        if (ch == "/") {
            nextChar();
            switch (ch) {
                case "/":
                    do {
                        nextChar();
                    } while (ch != "\n" && ch != "");
                    nextChar();
                    return;
                case "*":
                    nextChar();
                    while (true) {
                        if (ch == "*") {
                            nextChar();
                            if (ch == "/") {
                                nextChar();
                                break;
                            }
                        } else {
                            nextChar();
                        }
                        if (ch == "") {
                            parseError("Multi-line comment not closed");
                        }
                    }
                    return;
                default:
                    parseError("Unexpected " + ch + " encountered (expecting '/' or '*' )");
            }
        }
    }

    private function skipWhite():void {
        while (isWhiteSpace(ch)) {
            nextChar();
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
        return isDigit(c) || (u >= "A" && u <= "F");
    }

}
}
