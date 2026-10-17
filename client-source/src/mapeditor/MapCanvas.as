package mapeditor {
import com.company.assembleegameclient.map.GroundLibrary;
import com.company.assembleegameclient.map.RegionLibrary;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.util.AssetLibrary;
import com.company.util.IntPoint;
import com.company.util.PointUtil;
import com.company.util.KeyCodes;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.ui.Keyboard;
import flash.utils.Dictionary;

/**
 * The editable map: tile storage, rendering of the visible window (zoom / scroll),
 * and mouse/keyboard navigation. Tile edits are reported via TilesEvent.
 *
 * Hold SHIFT to extend a rectangular selection, hold CTRL and move the mouse to pan.
 */
internal class MapCanvas extends Sprite {

    /** Map width/height in tiles. */
    public static const MAP_SIZE:int = 0x0200;
    /** Width/height of one tile texture in pixels. */
    public static const TILE_SIZE:int = 16;
    /** Width/height of the on-screen viewport in pixels. */
    public static const VIEW_SIZE:int = 0x0200;
    public static const MIN_ZOOM:Number = 0.0625;
    public static const MAX_ZOOM:Number = 16;

    private static const BACKGROUND_TILE:BitmapData = new MapBackgroundAsset().bitmapData;

    public function MapCanvas() {
        this.tiles_ = new Dictionary();
        this.tileTextures_ = new ChunkedBitmapData((MAP_SIZE * TILE_SIZE), (MAP_SIZE * TILE_SIZE), true, 0);
        this.regionMap_ = new BitmapData(MAP_SIZE, MAP_SIZE, true, 0);
        this.view_ = new BitmapData(VIEW_SIZE, VIEW_SIZE, true, 0);
        this.selectionOverlay_ = new Shape();
        super();
        graphics.beginBitmapFill(BACKGROUND_TILE, null, true);
        graphics.drawRect(0, 0, VIEW_SIZE, VIEW_SIZE);
        addChild(new Bitmap(this.view_));
        addChild(this.selectionOverlay_);
        this.viewOrigin_ = new IntPoint(((MAP_SIZE / 2) - (this.getVisibleTileCount() / 2)), ((MAP_SIZE / 2) - (this.getVisibleTileCount() / 2)));
        this.invisibleTexture_ = AssetLibrary.getImageFromSet("invisible", 0);
        this.placeholderTexture_ = AssetLibrary.getImageFromSet("lofiObj3", 0xFF);
        this.draw();
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }
    /** Tile index (x + y * MAP_SIZE) -> MapTile. */
    private var tiles_:Dictionary;
    /** Ground/object textures of every tile at TILE_SIZE pixels per tile. */
    private var tileTextures_:ChunkedBitmapData;
    /** One pixel per tile; region colors. */
    private var regionMap_:BitmapData;
    /** The rendered viewport. */
    private var view_:BitmapData;
    private var selectionOverlay_:Shape;
    /** Top-left visible tile. */
    private var viewOrigin_:IntPoint;
    private var zoom_:Number = 1;
    /** Fixed corner of the rectangular selection while SHIFT is held. */
    private var selectionAnchor_:IntPoint = null;
    /** Tile under the cursor when CTRL panning started. */
    private var panAnchor_:IntPoint = null;
    private var invisibleTexture_:BitmapData;
    private var placeholderTexture_:BitmapData;

    public function getType(tileX:int, tileY:int, layer:int):int {
        var tile:MapTile = this.getTile(tileX, tileY);
        if (tile == null) {
            return (-1);
        }
        return (tile.types_[layer]);
    }

    public function getTile(tileX:int, tileY:int):MapTile {
        return (this.tiles_[(tileX + (tileY * MAP_SIZE))]);
    }

    public function setType(tileX:int, tileY:int, layer:int, type:int):void {
        var tile:MapTile = this.getOrCreateTile(tileX, tileY);
        if (tile.types_[layer] == type) {
            return;
        }
        tile.types_[layer] = type;
        this.redrawTile(tileX, tileY, tile);
    }

    public function getObjectName(tileX:int, tileY:int):String {
        var tile:MapTile = this.getTile(tileX, tileY);
        if (tile == null) {
            return (null);
        }
        return (tile.objectName_);
    }

    public function setObjectName(tileX:int, tileY:int, objectName:String):void {
        var tile:MapTile = this.getOrCreateTile(tileX, tileY);
        tile.objectName_ = objectName;
    }

    /** Positions of every tile that has data (including empty ones). */
    public function getTilePositions():Vector.<IntPoint> {
        var key:String;
        var index:int;
        var positions:Vector.<IntPoint> = new Vector.<IntPoint>();
        for (key in this.tiles_) {
            index = int(key);
            positions.push(new IntPoint((index % MAP_SIZE), (index / MAP_SIZE)));
        }
        return (positions);
    }

    /** Stores a copy of `tile` at the given position. */
    public function restoreTile(tileX:int, tileY:int, tile:MapTile):void {
        tile = tile.clone();
        this.tiles_[(tileX + (tileY * MAP_SIZE))] = tile;
        this.redrawTile(tileX, tileY, tile);
    }

    public function removeTile(tileX:int, tileY:int):void {
        this.deleteTileData(tileX, tileY);
        this.redrawTile(tileX, tileY, null);
    }

    public function clear():void {
        var key:String;
        var index:int;
        for (key in this.tiles_) {
            index = int(key);
            this.removeTile((index % MAP_SIZE), (index / MAP_SIZE));
        }
    }

    /** Bounding box (in tiles) of all non-empty tiles, or null if the map is empty. */
    public function getContentBounds():Rectangle {
        var key:String;
        var tile:MapTile;
        var index:int;
        var tileX:int;
        var tileY:int;
        var minX:int = MAP_SIZE;
        var minY:int = MAP_SIZE;
        var maxX:int;
        var maxY:int;
        for (key in this.tiles_) {
            tile = this.tiles_[key];
            if (!tile.isEmpty()) {
                index = int(key);
                tileX = (index % MAP_SIZE);
                tileY = (index / MAP_SIZE);
                if (tileX < minX) {
                    minX = tileX;
                }
                if (tileY < minY) {
                    minY = tileY;
                }
                if ((tileX + 1) > maxX) {
                    maxX = (tileX + 1);
                }
                if ((tileY + 1) > maxY) {
                    maxY = (tileY + 1);
                }
            }
        }
        if (minX > maxX) {
            return (null);
        }
        return (new Rectangle(minX, minY, (maxX - minX), (maxY - minY)));
    }

    /** Currently selected rectangle in tile coordinates (a single tile unless SHIFT is held). */
    public function getSelection():Rectangle {
        var mouseTile:IntPoint = this.getMouseTile();
        if (this.selectionAnchor_ == null) {
            return (new Rectangle(mouseTile.x_, mouseTile.y_, 1, 1));
        }
        return (new Rectangle(Math.min(mouseTile.x_, this.selectionAnchor_.x_), Math.min(mouseTile.y_, this.selectionAnchor_.y_), (Math.abs((mouseTile.x_ - this.selectionAnchor_.x_)) + 1), (Math.abs((mouseTile.y_ - this.selectionAnchor_.y_)) + 1)));
    }

    public function draw():void {
        var matrix:Matrix;
        var tilePixels:int;
        var regionView:BitmapData;
        var sourceSize:int = (VIEW_SIZE / this.zoom_);
        this.view_.fillRect(this.view_.rect, 0);
        this.tileTextures_.drawTo(new Rectangle((this.viewOrigin_.x_ * TILE_SIZE), (this.viewOrigin_.y_ * TILE_SIZE), sourceSize, sourceSize), this.view_, this.view_.rect);
        matrix = new Matrix();
        matrix.identity();
        tilePixels = (TILE_SIZE * this.zoom_);
        if (this.zoom_ > 2) {
            regionView = new BitmapData((VIEW_SIZE / tilePixels), (VIEW_SIZE / tilePixels));
            regionView.copyPixels(this.regionMap_, new Rectangle(this.viewOrigin_.x_, this.viewOrigin_.y_, sourceSize, sourceSize), PointUtil.ORIGIN);
            matrix.scale(tilePixels, tilePixels);
            this.view_.draw(regionView, matrix);
        } else {
            matrix.translate(-(this.viewOrigin_.x_), -(this.viewOrigin_.y_));
            matrix.scale(tilePixels, tilePixels);
            this.view_.draw(this.regionMap_, matrix, null, null, this.view_.rect);
        }
        this.drawSelection();
    }

    /** Number of tiles visible across the viewport at the current zoom. */
    private function getVisibleTileCount():int {
        return ((VIEW_SIZE / (TILE_SIZE * this.zoom_)));
    }

    /** Zooms around the tile under the mouse; ignored at the zoom limits. */
    private function zoomBy(factor:Number):void {
        if (((((factor > 1) && (this.zoom_ >= MAX_ZOOM))) || (((factor < 1) && (this.zoom_ <= MIN_ZOOM))))) {
            return;
        }
        var tileBefore:IntPoint = this.getMouseTile();
        this.zoom_ = (this.zoom_ * factor);
        var tileAfter:IntPoint = this.getMouseTile();
        this.scrollBy((tileBefore.x_ - tileAfter.x_), (tileBefore.y_ - tileAfter.y_));
    }

    /** Keyboard navigation is disabled while a selection or pan is in progress. */
    private function isNavigationAllowed():Boolean {
        return (((this.selectionAnchor_ == null) && (this.panAnchor_ == null)));
    }

    private function zoomIn():void {
        if (!this.isNavigationAllowed()) {
            return;
        }
        this.zoomBy(2);
        this.draw();
    }

    private function zoomOut():void {
        if (!this.isNavigationAllowed()) {
            return;
        }
        this.zoomBy(0.5);
        this.draw();
    }

    private function moveLeft():void {
        if (!this.isNavigationAllowed()) {
            return;
        }
        this.scrollBy(-1, 0);
        this.draw();
    }

    private function moveRight():void {
        if (!this.isNavigationAllowed()) {
            return;
        }
        this.scrollBy(1, 0);
        this.draw();
    }

    private function moveUp():void {
        if (!this.isNavigationAllowed()) {
            return;
        }
        this.scrollBy(0, -1);
        this.draw();
    }

    private function moveDown():void {
        if (!this.isNavigationAllowed()) {
            return;
        }
        this.scrollBy(0, 1);
        this.draw();
    }

    /** Moves the viewport by whole tiles, clamped to the map. */
    private function scrollBy(deltaX:int, deltaY:int):void {
        var minOrigin:int;
        var maxOrigin:int = (MAP_SIZE - this.getVisibleTileCount());
        this.viewOrigin_.x_ = Math.max(minOrigin, Math.min(maxOrigin, (this.viewOrigin_.x_ + deltaX)));
        this.viewOrigin_.y_ = Math.max(minOrigin, Math.min(maxOrigin, (this.viewOrigin_.y_ + deltaY)));
    }

    /** Tile coordinates under the mouse cursor. */
    private function getMouseTile():IntPoint {
        var pixelX:int = Math.max(0, Math.min((VIEW_SIZE - 1), mouseX));
        var pixelY:int = Math.max(0, Math.min((VIEW_SIZE - 1), mouseY));
        return (new IntPoint((this.viewOrigin_.x_ + (pixelX / (TILE_SIZE * this.zoom_))), (this.viewOrigin_.y_ + (pixelY / (TILE_SIZE * this.zoom_)))));
    }

    /** Converts a tile position to viewport pixels. */
    private function tileToViewPoint(tile:IntPoint):IntPoint {
        return (new IntPoint((((tile.x_ - this.viewOrigin_.x_) * TILE_SIZE) * this.zoom_), (((tile.y_ - this.viewOrigin_.y_) * TILE_SIZE) * this.zoom_)));
    }

    private function tilesToPixels(tileCount:int):Number {
        return (((tileCount * this.zoom_) * TILE_SIZE));
    }

    /** Selection rectangle in viewport pixels. */
    private function getSelectionViewRect():Rectangle {
        var selection:Rectangle = this.getSelection();
        var topLeft:IntPoint = this.tileToViewPoint(new IntPoint(selection.x, selection.y));
        selection.x = topLeft.x_;
        selection.y = topLeft.y_;
        selection.width = (this.tilesToPixels(selection.width) - 1);
        selection.height = (this.tilesToPixels(selection.height) - 1);
        return (selection);
    }

    private function getOrCreateTile(tileX:int, tileY:int):MapTile {
        var index:int = (tileX + (tileY * MAP_SIZE));
        var tile:MapTile = this.tiles_[index];
        if (tile != null) {
            return (tile);
        }
        tile = new MapTile();
        this.tiles_[index] = tile;
        return (tile);
    }

    private function deleteTileData(tileX:int, tileY:int):void {
        delete this.tiles_[(tileX + (tileY * MAP_SIZE))];
    }

    /** Re-renders one tile into the texture and region buffers. A null tile clears it. */
    private function redrawTile(tileX:int, tileY:int, tile:MapTile):void {
        var groundTexture:BitmapData;
        var objectTexture:BitmapData;
        var regionColor:uint;
        var tileRect:Rectangle = new Rectangle((tileX * TILE_SIZE), (tileY * TILE_SIZE), TILE_SIZE, TILE_SIZE);
        this.tileTextures_.clearRect(tileRect);
        this.regionMap_.setPixel32(tileX, tileY, 0);
        if (tile == null) {
            return;
        }
        if (tile.types_[MapLayer.GROUND] != -1) {
            groundTexture = GroundLibrary.getBitmapData(tile.types_[MapLayer.GROUND]);
            this.tileTextures_.copyTo(groundTexture, groundTexture.rect, tileRect);
        }
        if (tile.types_[MapLayer.OBJECT] != -1) {
            objectTexture = ObjectLibrary.getTextureFromType(tile.types_[MapLayer.OBJECT]);
            if (((objectTexture == null) || (objectTexture == this.invisibleTexture_))) {
                this.tileTextures_.copyTo(this.placeholderTexture_, this.placeholderTexture_.rect, tileRect);
            } else {
                this.tileTextures_.copyTo(objectTexture, objectTexture.rect, tileRect);
            }
        }
        if (tile.types_[MapLayer.REGION] != -1) {
            regionColor = RegionLibrary.getColor(tile.types_[MapLayer.REGION]);
            this.regionMap_.setPixel32(tileX, tileY, (0x5F000000 | regionColor));
        }
    }

    private function drawSelection():void {
        var rect:Rectangle = this.getSelectionViewRect();
        var g:Graphics = this.selectionOverlay_.graphics;
        g.clear();
        g.lineStyle(1, 0xFFFFFF);
        g.beginFill(0xFFFFFF, 0.1);
        g.drawRect(rect.x, rect.y, rect.width, rect.height);
        g.endFill();
        g.lineStyle();
    }

    private function onAddedToStage(event:Event):void {
        addEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
        addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
        addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
    }

    private function onRemovedFromStage(event:Event):void {
        removeEventListener(MouseEvent.MOUSE_WHEEL, this.onMouseWheel);
        removeEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
        removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
        stage.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUp);
    }

    private function onKeyDown(event:KeyboardEvent):void {
        switch (event.keyCode) {
            case Keyboard.SHIFT:
                if (this.selectionAnchor_ == null) {
                    this.selectionAnchor_ = this.getMouseTile();
                }
                break;
            case Keyboard.CONTROL:
                if (this.panAnchor_ == null) {
                    this.panAnchor_ = this.getMouseTile();
                }
                break;
            case Keyboard.LEFT:
                this.moveLeft();
                break;
            case Keyboard.RIGHT:
                this.moveRight();
                break;
            case Keyboard.UP:
                this.moveUp();
                break;
            case Keyboard.DOWN:
                this.moveDown();
                break;
            case KeyCodes.MINUS:
                this.zoomOut();
                break;
            case KeyCodes.EQUAL:
                this.zoomIn();
                break;
        }
        this.draw();
    }

    private function onKeyUp(event:KeyboardEvent):void {
        switch (event.keyCode) {
            case Keyboard.SHIFT:
                this.selectionAnchor_ = null;
                break;
            case Keyboard.CONTROL:
                this.panAnchor_ = null;
                break;
        }
        this.draw();
    }

    private function onMouseWheel(event:MouseEvent):void {
        if (event.delta > 0) {
            this.zoomIn();
        } else if (event.delta < 0) {
            this.zoomOut();
        }
    }

    private function onMouseDown(event:MouseEvent):void {
        var tileY:int;
        var selection:Rectangle = this.getSelection();
        var tiles:Vector.<IntPoint> = new Vector.<IntPoint>();
        var tileX:int = selection.x;
        while (tileX < selection.right) {
            tileY = selection.y;
            while (tileY < selection.bottom) {
                tiles.push(new IntPoint(tileX, tileY));
                tileY++;
            }
            tileX++;
        }
        dispatchEvent(new TilesEvent(tiles));
    }

    private function onMouseMove(event:MouseEvent):void {
        var mouseTile:IntPoint;
        if (!event.shiftKey) {
            this.selectionAnchor_ = null;
        } else if (this.selectionAnchor_ == null) {
            this.selectionAnchor_ = this.getMouseTile();
        }
        if (!event.ctrlKey) {
            this.panAnchor_ = null;
        } else if (this.panAnchor_ == null) {
            this.panAnchor_ = this.getMouseTile();
        }
        if (event.buttonDown) {
            dispatchEvent(new TilesEvent(new <IntPoint>[this.getMouseTile()]));
        }
        if (this.panAnchor_ != null) {
            mouseTile = this.getMouseTile();
            this.scrollBy((this.panAnchor_.x_ - mouseTile.x_), (this.panAnchor_.y_ - mouseTile.y_));
            this.draw();
        } else {
            this.drawSelection();
        }
    }

}
}
