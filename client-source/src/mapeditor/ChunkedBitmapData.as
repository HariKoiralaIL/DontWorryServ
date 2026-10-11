package mapeditor {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Rectangle;

/**
 * A large bitmap stored as a grid of CHUNK_SIZE x CHUNK_SIZE BitmapData pieces,
 * so it can exceed the maximum size of a single BitmapData.
 */
public class ChunkedBitmapData {

    private static const CHUNK_SIZE:int = 0x0100;

    public function ChunkedBitmapData(width:int, height:int, transparent:Boolean, fillColor:uint) {
        var chunkY:int;
        var chunkWidth:int;
        var chunkHeight:int;
        super();
        this.width_ = width;
        this.height_ = height;
        this.fillColor_ = fillColor;
        this.chunksX_ = Math.ceil((this.width_ / CHUNK_SIZE));
        this.chunksY_ = Math.ceil((this.height_ / CHUNK_SIZE));
        this.chunks_ = new Vector.<BitmapData>((this.chunksX_ * this.chunksY_), true);
        var chunkX:int;
        while (chunkX < this.chunksX_) {
            chunkY = 0;
            while (chunkY < this.chunksY_) {
                chunkWidth = Math.min(CHUNK_SIZE, (this.width_ - (chunkX * CHUNK_SIZE)));
                chunkHeight = Math.min(CHUNK_SIZE, (this.height_ - (chunkY * CHUNK_SIZE)));
                this.chunks_[(chunkX + (chunkY * this.chunksX_))] = new BitmapData(chunkWidth, chunkHeight, transparent, this.fillColor_);
                chunkY++;
            }
            chunkX++;
        }
    }
    public var width_:int;
    public var height_:int;
    public var fillColor_:uint;
    private var chunksX_:int;
    private var chunksY_:int;
    private var chunks_:Vector.<BitmapData>;

    /** Draws `source` (cropped to sourceRect) scaled into destRect of this bitmap. */
    public function copyTo(source:BitmapData, sourceRect:Rectangle, destRect:Rectangle):void {
        var chunkY:int;
        var chunk:BitmapData;
        var clipRect:Rectangle;
        var scaleX:Number = (destRect.width / sourceRect.width);
        var scaleY:Number = (destRect.height / sourceRect.height);
        var firstChunkX:int = int((destRect.x / CHUNK_SIZE));
        var firstChunkY:int = int((destRect.y / CHUNK_SIZE));
        var endChunkX:int = Math.ceil((destRect.right / CHUNK_SIZE));
        var endChunkY:int = Math.ceil((destRect.bottom / CHUNK_SIZE));
        var matrix:Matrix = new Matrix();
        var chunkX:int = firstChunkX;
        while (chunkX < endChunkX) {
            chunkY = firstChunkY;
            while (chunkY < endChunkY) {
                chunk = this.chunks_[(chunkX + (chunkY * this.chunksX_))];
                matrix.identity();
                matrix.scale(scaleX, scaleY);
                matrix.translate(((destRect.x - (chunkX * CHUNK_SIZE)) - (sourceRect.x * scaleX)), ((destRect.y - (chunkY * CHUNK_SIZE)) - (sourceRect.x * scaleY)));
                clipRect = new Rectangle((destRect.x - (chunkX * CHUNK_SIZE)), (destRect.y - (chunkY * CHUNK_SIZE)), destRect.width, destRect.height);
                chunk.draw(source, matrix, null, null, clipRect, false);
                chunkY++;
            }
            chunkX++;
        }
    }

    /** Draws the region `sourceRect` of this bitmap, scaled, into destRect of `dest`. */
    public function drawTo(sourceRect:Rectangle, dest:BitmapData, destRect:Rectangle):void {
        var chunkY:int;
        var chunk:BitmapData;
        var scaleX:Number = (destRect.width / sourceRect.width);
        var scaleY:Number = (destRect.height / sourceRect.height);
        var firstChunkX:int = Math.max(0, int((sourceRect.x / CHUNK_SIZE)));
        var firstChunkY:int = Math.max(0, int((sourceRect.y / CHUNK_SIZE)));
        var lastChunkX:int = Math.min((this.chunksX_ - 1), int((sourceRect.right / CHUNK_SIZE)));
        var lastChunkY:int = Math.min((this.chunksY_ - 1), int((sourceRect.bottom / CHUNK_SIZE)));
        var matrix:Matrix = new Matrix();
        var chunkX:int = firstChunkX;
        while (chunkX <= lastChunkX) {
            chunkY = firstChunkY;
            while (chunkY <= lastChunkY) {
                chunk = this.chunks_[(chunkX + (chunkY * this.chunksX_))];
                matrix.identity();
                matrix.translate((((destRect.x / scaleX) - sourceRect.x) + (chunkX * CHUNK_SIZE)), (((destRect.y / scaleY) - sourceRect.y) + (chunkY * CHUNK_SIZE)));
                matrix.scale(scaleX, scaleY);
                dest.draw(chunk, matrix, null, null, destRect, false);
                chunkY++;
            }
            chunkX++;
        }
    }

    /** Resets the given rectangle to the fill color. */
    public function clearRect(rect:Rectangle):void {
        var chunkY:int;
        var chunk:BitmapData;
        var firstChunkX:int = int((rect.x / CHUNK_SIZE));
        var firstChunkY:int = int((rect.y / CHUNK_SIZE));
        var endChunkX:int = Math.ceil((rect.right / CHUNK_SIZE));
        var endChunkY:int = Math.ceil((rect.bottom / CHUNK_SIZE));
        var chunkRect:Rectangle = new Rectangle();
        var chunkX:int = firstChunkX;
        while (chunkX < endChunkX) {
            chunkY = firstChunkY;
            while (chunkY < endChunkY) {
                chunk = this.chunks_[(chunkX + (chunkY * this.chunksX_))];
                chunkRect.x = (rect.x - (chunkX * CHUNK_SIZE));
                chunkRect.y = (rect.y - (chunkY * CHUNK_SIZE));
                chunkRect.right = (rect.right - (chunkX * CHUNK_SIZE));
                chunkRect.bottom = (rect.bottom - (chunkY * CHUNK_SIZE));
                chunk.fillRect(chunkRect, this.fillColor_);
                chunkY++;
            }
            chunkX++;
        }
    }

    /** Builds a Sprite that displays all chunks side by side. */
    public function toSprite():Sprite {
        var chunkY:int;
        var chunk:BitmapData;
        var bitmap:Bitmap;
        var sprite:Sprite = new Sprite();
        var chunkX:int;
        while (chunkX < this.chunksX_) {
            chunkY = 0;
            while (chunkY < this.chunksY_) {
                chunk = this.chunks_[(chunkX + (chunkY * this.chunksX_))];
                bitmap = new Bitmap(chunk);
                bitmap.x = (chunkX * CHUNK_SIZE);
                bitmap.y = (chunkY * CHUNK_SIZE);
                sprite.addChild(bitmap);
                chunkY++;
            }
            chunkX++;
        }
        return (sprite);
    }

}
}
