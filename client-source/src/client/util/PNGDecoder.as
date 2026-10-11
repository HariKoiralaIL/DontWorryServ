// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.util.PNGDecoder

package client.util {
import flash.utils.ByteArray;
import flash.display.BitmapData;

public class PNGDecoder {

    private static const CHUNK_IHDR:int = 1229472850;
    private static const CHUNK_IDAT:int = 1229209940;
    private static const CHUNK_TEXT:int = 1950701684;
    private static const CHUNK_ITXT:int = 1767135348;
    private static const CHUNK_ZTXT:int = 2052348020;
    private static const CHUNK_IEND:int = 1229278788;

    private static var width:uint;
    private static var height:uint;
    private static var source:ByteArray;
    private static var buffer:ByteArray;
    private static var row:int;
    private static var bytesPerPixel:int;

    public static function decodeImage(_arg1:ByteArray):BitmapData {
        var _local4:Boolean;
        var _local5:int;
        if (_arg1 == null) {
            return (null);
        }
        source = _arg1;
        buffer = new ByteArray();
        bytesPerPixel = 4;
        source.position = 0;
        if (source.readUnsignedInt() != 2303741511) {
            return (abort());
        }
        if (source.readUnsignedInt() != 218765834) {
            return (abort());
        }
        var _local2:Array = readChunks();
        var _local3:int;
        _local5 = 0;
        while (_local5 < _local2.length) {
            source.position = _local2[_local5].position;
            _local4 = true;
            if (_local2[_local5].type == CHUNK_IHDR) {
                _local3++;
                if (_local5 == 0) {
                    _local4 = parseHeader(_local2[_local5].length);
                } else {
                    _local4 = false;
                }
            }
            if (_local2[_local5].type == CHUNK_IDAT) {
                buffer.writeBytes(source, source.position, _local2[_local5].length);
            }
            if (((!(_local4)) || ((_local3 > 1)))) {
                return (abort());
            }
            _local5++;
        }
        var _local6:BitmapData = decodePixels();
        source = null;
        buffer = null;
        return (_local6);
    }

    public static function decodeMetadata(_arg1:ByteArray):XML {
        var _local4:int;
        if (_arg1 == null) {
            return (null);
        }
        source = _arg1;
        source.position = 0;
        if (source.readUnsignedInt() != 2303741511) {
            source = null;
            return (null);
        }
        if (source.readUnsignedInt() != 218765834) {
            source = null;
            return (null);
        }
        var _local2:Array = readChunks();
        var _local3:XML = <information/>
                ;
        _local4 = 0;
        while (_local4 < _local2.length) {
            if (_local2[_local4].type == CHUNK_TEXT) {
                _local3.appendChild(parseTextChunk(_local2[_local4].position, _local2[_local4].length));
            }
            if (_local2[_local4].type == CHUNK_ITXT) {
                _local3.appendChild(parseITextChunk(_local2[_local4].position, _local2[_local4].length));
            }
            if (_local2[_local4].type == CHUNK_ZTXT) {
                _local3.appendChild(parseZTextChunk(_local2[_local4].position, _local2[_local4].length));
            }
            _local4++;
        }
        source = null;
        return (_local3);
    }

    private static function parseTextChunk(_arg1:int, _arg2:int):XML {
        var _local3:XML = <tEXt/>
                ;
        var _local4 = "";
        var _local5 = "";
        var _local6:int = -1;
        source.position = _arg1;
        while (source.position < (_arg1 + _arg2)) {
            _local6 = source.readUnsignedByte();
            if (_local6 > 0) {
                _local4 = (_local4 + String.fromCharCode(_local6));
            } else {
                break;
            }
        }
        _local5 = source.readUTFBytes(((_arg1 + _arg2) - source.position));
        _local3.appendChild(new XML((("<keyword>" + _local4) + "</keyword>")));
        _local3.appendChild(new XML((("<text>" + _local5) + "</text>")));
        return (_local3);
    }

    private static function parseZTextChunk(_arg1:int, _arg2:int):XML {
        var _local8:ByteArray;
        var _local3:XML = <zTXt/>
                ;
        var _local4 = "";
        var _local5 = "";
        var _local6:int = -1;
        source.position = _arg1;
        while (source.position < (_arg1 + _arg2)) {
            _local6 = source.readUnsignedByte();
            if (_local6 > 0) {
                _local4 = (_local4 + String.fromCharCode(_local6));
            } else {
                break;
            }
        }
        var _local7:int = source.readUnsignedByte();
        if (_local7 == 0) {
            _local8 = new ByteArray();
            _local8.writeBytes(source, source.position, ((_arg1 + _arg2) - source.position));
            _local8.uncompress();
            _local5 = _local8.readUTFBytes(_local8.length);
        }
        _local3.appendChild(new XML((("<keyword>" + _local4) + "</keyword>")));
        _local3.appendChild(new XML((("<text>" + _local5) + "</text>")));
        return (_local3);
    }

    private static function parseITextChunk(_arg1:int, _arg2:int):XML {
        var _local11:ByteArray;
        var _local3:XML = <iTXt/>
                ;
        var _local4 = "";
        var _local5 = "";
        var _local6 = "";
        var _local7 = "";
        var _local8:int = -1;
        source.position = _arg1;
        while (source.position < (_arg1 + _arg2)) {
            _local8 = source.readUnsignedByte();
            if (_local8 > 0) {
                _local4 = (_local4 + String.fromCharCode(_local8));
            } else {
                break;
            }
        }
        var _local9 = (source.readUnsignedByte() == 1);
        var _local10:int = source.readUnsignedByte();
        while (source.position < (_arg1 + _arg2)) {
            _local8 = source.readUnsignedByte();
            if (_local8 > 0) {
                _local5 = (_local5 + String.fromCharCode(_local8));
            } else {
                break;
            }
        }
        while (source.position < (_arg1 + _arg2)) {
            _local8 = source.readUnsignedByte();
            if (_local8 > 0) {
                _local6 = (_local6 + String.fromCharCode(_local8));
            } else {
                break;
            }
        }
        if (_local9) {
            if (_local10 == 0) {
                _local11 = new ByteArray();
                _local11.writeBytes(source, source.position, ((_arg1 + _arg2) - source.position));
                _local11.uncompress();
                _local7 = _local11.readUTFBytes(_local11.length);
            }
        } else {
            _local7 = source.readUTFBytes(((_arg1 + _arg2) - source.position));
        }
        _local3.appendChild(new XML((("<keyword>" + _local4) + "</keyword>")));
        _local3.appendChild(new XML((("<text>" + _local7) + "</text>")));
        _local3.appendChild(new XML((("<languageTag>" + _local5) + "</languageTag>")));
        _local3.appendChild(new XML((("<translatedKeyword>" + _local6) + "</translatedKeyword>")));
        return (_local3);
    }

    private static function abort():BitmapData {
        source = null;
        buffer = null;
        return (null);
    }

    private static function readChunks():Array {
        var _local2:uint;
        var _local3:int;
        var _local1:Array = [];
        do
        {
            _local2 = source.readUnsignedInt();
            _local3 = source.readInt();
            _local1.push({
                "type": _local3,
                "position": source.position,
                "length": _local2
            });
            source.position = (source.position + (_local2 + 4));
        } while (((!((_local3 == CHUNK_IEND))) && ((source.bytesAvailable > 0))));
        return (_local1);
    }

    private static function parseHeader(_arg1:int):Boolean {
        if (_arg1 != 13) {
            return (false);
        }
        width = source.readUnsignedInt();
        height = source.readUnsignedInt();
        var bitDepth:int = source.readUnsignedByte();
        var colorType:int = source.readUnsignedByte();
        var compressionMethod:int = source.readUnsignedByte();
        var filterMethod:int = source.readUnsignedByte();
        var interlaceMethod:int = source.readUnsignedByte();
        if ((((width <= 0)) || ((height <= 0)))) {
            return (false);
        }
        switch (bitDepth) {
            case 1:
            case 2:
            case 4:
            case 8:
            case 16:
                break;
            default:
                return (false);
        }
        switch (colorType) {
            case 0:
                if (((((((((!((bitDepth == 1))) && (!((bitDepth == 2))))) && (!((bitDepth == 4))))) && (!((bitDepth == 8))))) && (!((bitDepth == 16))))) {
                    return (false);
                }
                break;
            case 2:
            case 4:
            case 6:
                if (((!((bitDepth == 8))) && (!((bitDepth == 16))))) {
                    return (false);
                }
                break;
            case 3:
                if (((((((!((bitDepth == 1))) && (!((bitDepth == 2))))) && (!((bitDepth == 4))))) && (!((bitDepth == 8))))) {
                    return (false);
                }
                break;
            default:
                return (false);
        }
        if (((!((compressionMethod == 0))) || (!((filterMethod == 0))))) {
            return (false);
        }
        if (((!((interlaceMethod == 0))) && (!((interlaceMethod == 1))))) {
            return (false);
        }
        return (true);
    }

    private static function decodePixels():BitmapData {
        var bufferLen:uint;
        var filter:int;
        var i:int;
        var r:uint;
        var g:uint;
        var b:uint;
        var a:uint;
        var bd:BitmapData = new BitmapData(width, height);
        try {
            buffer.uncompress();
        } catch (err) {
            return (null);
        }
        row = 0;
        bufferLen = buffer.length;
        while (buffer.position < bufferLen) {
            filter = buffer.readUnsignedByte();
            if (filter == 0) {
                i = 0;
                while (i < width) {
                    r = (unfilterNone() << 16);
                    g = (unfilterNone() << 8);
                    b = unfilterNone();
                    a = (unfilterNone() << 24);
                    bd.setPixel32(i, row, (((a + r) + g) + b));
                    i = (i + 1);
                }
            } else {
                if (filter == 1) {
                    i = 0;
                    while (i < width) {
                        r = (unfilterSub() << 16);
                        g = (unfilterSub() << 8);
                        b = unfilterSub();
                        a = (unfilterSub() << 24);
                        bd.setPixel32(i, row, (((a + r) + g) + b));
                        i = (i + 1);
                    }
                } else {
                    if (filter == 2) {
                        i = 0;
                        while (i < width) {
                            r = (unfilterUp() << 16);
                            g = (unfilterUp() << 8);
                            b = unfilterUp();
                            a = (unfilterUp() << 24);
                            bd.setPixel32(i, row, (((a + r) + g) + b));
                            i = (i + 1);
                        }
                    } else {
                        if (filter == 3) {
                            i = 0;
                            while (i < width) {
                                r = (unfilterAverage() << 16);
                                g = (unfilterAverage() << 8);
                                b = unfilterAverage();
                                a = (unfilterAverage() << 24);
                                bd.setPixel32(i, row, (((a + r) + g) + b));
                                i = (i + 1);
                            }
                        } else {
                            if (filter == 4) {
                                i = 0;
                                while (i < width) {
                                    r = (unfilterPaeth() << 16);
                                    g = (unfilterPaeth() << 8);
                                    b = unfilterPaeth();
                                    a = (unfilterPaeth() << 24);
                                    bd.setPixel32(i, row, (((a + r) + g) + b));
                                    i = (i + 1);
                                }
                            } else {
                                buffer.position = (buffer.position + (bytesPerPixel * width));
                            }
                        }
                    }
                }
            }
            row++;
        }
        return (bd);
    }

    private static function unfilterNone():uint {
        return (buffer[buffer.position++]);
    }

    private static function unfilterSub():uint {
        var _local1:uint = (buffer[buffer.position] + getLeftByte());
        _local1 = (_local1 & 0xFF);
        var _local2 = buffer.position++;
        buffer[_local2] = _local1;
        return (_local1);
    }

    private static function unfilterUp():uint {
        var _local1:uint = (buffer[buffer.position] + getUpByte());
        _local1 = (_local1 & 0xFF);
        var _local2 = buffer.position++;
        buffer[_local2] = _local1;
        return (_local1);
    }

    private static function unfilterAverage():uint {
        var _local1:uint = (buffer[buffer.position] + Math.floor(((getLeftByte() + getUpByte()) / 2)));
        _local1 = (_local1 & 0xFF);
        var _local2 = buffer.position++;
        buffer[_local2] = _local1;
        return (_local1);
    }

    private static function unfilterPaeth():uint {
        var _local1:uint = (buffer[buffer.position] + paethPredictor());
        _local1 = (_local1 & 0xFF);
        var _local2 = buffer.position++;
        buffer[_local2] = _local1;
        return (_local1);
    }

    private static function paethPredictor():uint {
        var _local1:uint = getLeftByte();
        var _local2:uint = getUpByte();
        var _local3:uint = getUpLeftByte();
        var _local4:int;
        var _local5:int;
        var _local6:int;
        var _local7:int;
        var _local8:int;
        _local4 = ((_local1 + _local2) - _local3);
        _local5 = Math.abs((_local4 - _local1));
        _local6 = Math.abs((_local4 - _local2));
        _local7 = Math.abs((_local4 - _local3));
        if ((((_local5 <= _local6)) && ((_local5 <= _local7)))) {
            _local8 = _local1;
        } else {
            if (_local6 <= _local7) {
                _local8 = _local2;
            } else {
                _local8 = _local3;
            }
        }
        return (_local8);
    }

    private static function getLeftByte():uint {
        var _local1:int = (row * ((width * bytesPerPixel) + 1));
        var _local2:int = (buffer.position - bytesPerPixel);
        if (_local2 <= _local1) {
            return (0);
        }
        return (buffer[_local2]);
    }

    private static function getUpByte():uint {
        var _local1:int = (buffer.position - ((width * bytesPerPixel) + 1));
        if (_local1 < 0) {
            return (0);
        }
        return (buffer[_local1]);
    }

    private static function getUpLeftByte():uint {
        var _local1:int = (buffer.position - ((width * bytesPerPixel) + 1));
        if (_local1 < 0) {
            return (0);
        }
        var _local2:int = ((row - 1) * ((width * bytesPerPixel) + 1));
        _local1 = (_local1 - bytesPerPixel);
        if (_local1 <= _local2) {
            return (0);
        }
        return (buffer[_local1]);
    }

}
}//package client.util

