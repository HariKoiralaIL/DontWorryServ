package pngencoder {
import flash.display.BitmapData;
import flash.utils.ByteArray;

// Formerly _9l. Encodes a BitmapData as a PNG (8-bit RGBA, no filtering).
public class PNGEncoder {

    private static const PNG_SIGNATURE_1:uint = 0x89504E47;
    private static const PNG_SIGNATURE_2:uint = 0x0D0A1A0A;
    private static const CHUNK_IHDR:uint = 0x49484452;    // "IHDR"
    private static const CHUNK_IDAT:uint = 0x49444154;    // "IDAT"
    private static const CHUNK_IEND:uint = 0x49454E44;    // "IEND"
    private static const IHDR_DEPTH_AND_COLOR_TYPE:uint = 0x08060000;   // 8 bits per channel, RGBA
    private static const CRC_POLYNOMIAL:uint = 0xEDB88320;

    private static var crcTable:Array;                    // formerly _oa
    private static var crcTableCreated:Boolean = false;   // formerly _oP_

    public static function encode(bitmapData:BitmapData):ByteArray {
        var png:ByteArray = new ByteArray();
        png.writeUnsignedInt(PNG_SIGNATURE_1);
        png.writeUnsignedInt(PNG_SIGNATURE_2);

        var header:ByteArray = new ByteArray();
        header.writeInt(bitmapData.width);
        header.writeInt(bitmapData.height);
        header.writeUnsignedInt(IHDR_DEPTH_AND_COLOR_TYPE);
        header.writeByte(0);   // interlace method: none
        writeChunk(png, CHUNK_IHDR, header);

        var pixelData:ByteArray = new ByteArray();
        var pixel:uint;
        for (var y:int = 0; y < bitmapData.height; y++) {
            pixelData.writeByte(0);   // filter type: none
            if (!bitmapData.transparent) {
                for (var x:int = 0; x < bitmapData.width; x++) {
                    pixel = bitmapData.getPixel(x, y);
                    pixelData.writeUnsignedInt(uint(((pixel & 0xFFFFFF) << 8) | 0xFF));
                }
            } else {
                for (x = 0; x < bitmapData.width; x++) {
                    pixel = bitmapData.getPixel32(x, y);
                    pixelData.writeUnsignedInt(uint(((pixel & 0xFFFFFF) << 8) | (pixel >>> 24)));
                }
            }
        }
        pixelData.compress();
        writeChunk(png, CHUNK_IDAT, pixelData);
        writeChunk(png, CHUNK_IEND, null);
        return png;
    }

    // formerly _X_H_: appends length, type, data and CRC for one PNG chunk.
    private static function writeChunk(png:ByteArray, type:uint, data:ByteArray):void {
        if (!crcTableCreated) {
            createCrcTable();
        }
        var length:uint = 0;
        if (data != null) {
            length = data.length;
        }
        png.writeUnsignedInt(length);
        var crcStart:uint = png.position;
        png.writeUnsignedInt(type);
        if (data != null) {
            png.writeBytes(data);
        }
        var crcEnd:uint = png.position;

        // CRC covers the chunk type and data.
        png.position = crcStart;
        var crc:uint = 0xFFFFFFFF;
        for (var i:int = 0; i < crcEnd - crcStart; i++) {
            crc = uint(crcTable[(crc ^ png.readUnsignedByte()) & 0xFF] ^ uint(crc >>> 8));
        }
        crc = uint(crc ^ 0xFFFFFFFF);
        png.position = crcEnd;
        png.writeUnsignedInt(crc);
    }

    private static function createCrcTable():void {
        crcTableCreated = true;
        crcTable = [];
        for (var n:uint = 0; n < 256; n++) {
            var c:uint = n;
            for (var k:uint = 0; k < 8; k++) {
                if (c & 1) {
                    c = uint(CRC_POLYNOMIAL ^ uint(c >>> 1));
                } else {
                    c = uint(c >>> 1);
                }
            }
            crcTable[n] = c;
        }
    }
}
}
