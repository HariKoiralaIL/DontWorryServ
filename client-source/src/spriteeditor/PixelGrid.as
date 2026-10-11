package spriteeditor {
import client.util.color.HSV;
import client.util.color.RGB;

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.events.Event;
import flash.events.MouseEvent;

/** A columns x rows grid of PixelCells that edits a single bitmap. */
public class PixelGrid extends BitmapEditor {

    private static const BACKGROUND_TILE:BitmapData = new GridBackgroundAsset().bitmapData;

    public function PixelGrid(width:int, height:int, columns:int, rows:int, transparentWhenEmpty:Boolean) {
        var column:int;
        var row:int;
        var cell:PixelCell;
        var cellSize:int;
        this.cells_ = new Vector.<Vector.<PixelCell>>();
        super();
        this.width_ = width;
        this.height_ = height;
        this.columns_ = columns;
        this.rows_ = rows;
        this.transparentWhenEmpty_ = transparentWhenEmpty;
        cellSize = Math.min((this.width_ / this.columns_), (this.height_ / this.rows_));
        var offsetX:int = ((this.width_ / 2) - ((cellSize * this.columns_) / 2));
        var offsetY:int = ((this.height_ / 2) - ((cellSize * this.rows_) / 2));
        this.cells_.length = this.columns_;
        column = 0;
        while (column < this.columns_) {
            if (this.cells_[column] == null) {
                this.cells_[column] = new Vector.<PixelCell>();
            }
            this.cells_[column].length = this.rows_;
            row = 0;
            while (row < this.rows_) {
                cell = new PixelCell(cellSize, this.transparentWhenEmpty_);
                this.cells_[column][row] = cell;
                cell.x = (offsetX + (column * cellSize));
                cell.y = (offsetY + (row * cellSize));
                cell.addEventListener(MouseEvent.MOUSE_DOWN, this.onCellMouseDown);
                cell.addEventListener(MouseEvent.MOUSE_OVER, this.onCellMouseOver);
                cell.addEventListener(MouseEvent.MOUSE_OUT, this.onCellMouseOut);
                addChild(cell);
                row++;
            }
            column++;
        }
        graphics.clear();
        graphics.beginBitmapFill(BACKGROUND_TILE, null);
        graphics.drawRect(offsetX, offsetY, (cellSize * columns), (cellSize * rows));
        graphics.endFill();
        this.gridLines_ = new Shape();
        var g:Graphics = this.gridLines_.graphics;
        g.lineStyle(1, 0xFFFFFF, 0.5);
        column = 0;
        while (column <= this.columns_) {
            g.moveTo((offsetX + (column * cellSize)), offsetY);
            g.lineTo((offsetX + (column * cellSize)), (offsetY + (this.rows_ * cellSize)));
            column++;
        }
        row = 0;
        while (row <= this.rows_) {
            g.moveTo(offsetX, (offsetY + (row * cellSize)));
            g.lineTo((offsetX + (this.columns_ * cellSize)), (offsetY + (row * cellSize)));
            row++;
        }
        g.lineStyle();
        addChild(this.gridLines_);
    }
    private var width_:int;
    private var height_:int;
    private var columns_:int;
    private var rows_:int;
    private var transparentWhenEmpty_:Boolean;
    /** cells_[column][row] */
    private var cells_:Vector.<Vector.<PixelCell>>;
    private var gridLines_:Shape;

    override public function getBitmapData():BitmapData {
        var row:int;
        var cell:PixelCell;
        var bitmapData:BitmapData = new BitmapData(this.columns_, this.rows_, true, 0);
        var column:int;
        while (column < this.cells_.length) {
            row = 0;
            while (row < this.cells_[column].length) {
                cell = this.cells_[column][row];
                if (((cell.color_ != null) || (!(this.transparentWhenEmpty_)))) {
                    bitmapData.setPixel32(column, row, (0xFF000000 | cell.getColor()));
                }
                row++;
            }
            column++;
        }
        return (bitmapData);
    }

    override public function loadBitmapData(bitmapData:BitmapData):void {
        var row:int;
        var cell:PixelCell;
        var pixel:uint;
        var color:HSV;
        var column:int;
        while (column < bitmapData.width) {
            row = 0;
            while (row < bitmapData.height) {
                cell = this.cells_[column][row];
                pixel = bitmapData.getPixel32(column, row);
                color = null;
                if ((pixel & 0xFF000000) != 0) {
                    color = RGB.fromHex((pixel & 0xFFFFFF)).toHSV();
                }
                cell.setColor(color);
                row++;
            }
            column++;
        }
        dispatchEvent(new Event(Event.CHANGE));
    }

    /** Requests clearing of every painted cell (handled by whoever listens for SetPixelsEvent). */
    override public function clear():void {
        var column:Vector.<PixelCell>;
        var cell:PixelCell;
        var changes:Vector.<PixelChange> = new Vector.<PixelChange>();
        for each (column in this.cells_) {
            for each (cell in column) {
                if (cell.color_ != null) {
                    changes.push(new PixelChange(cell, null));
                }
            }
        }
        dispatchEvent(new SetPixelsEvent(changes));
    }

    public function isEmpty():Boolean {
        var column:Vector.<PixelCell>;
        var cell:PixelCell;
        for each (column in this.cells_) {
            for each (cell in column) {
                if (cell.color_ != null) {
                    return (false);
                }
            }
        }
        return (true);
    }

    private function onCellMouseDown(event:MouseEvent):void {
        var cell:PixelCell = (event.target as PixelCell);
        dispatchEvent(new PixelEvent(PixelEvent.UNDO_TEMP_EVENT, cell));
        dispatchEvent(new PixelEvent(PixelEvent.PIXEL_EVENT, cell));
    }

    private function onCellMouseOver(event:MouseEvent):void {
        var cell:PixelCell = (event.target as PixelCell);
        if (event.buttonDown) {
            dispatchEvent(new PixelEvent(PixelEvent.PIXEL_EVENT, cell));
        } else {
            dispatchEvent(new PixelEvent(PixelEvent.TEMP_PIXEL_EVENT, cell));
        }
    }

    private function onCellMouseOut(event:MouseEvent):void {
        var cell:PixelCell = (event.target as PixelCell);
        dispatchEvent(new PixelEvent(PixelEvent.UNDO_TEMP_EVENT, cell));
    }

}
}
