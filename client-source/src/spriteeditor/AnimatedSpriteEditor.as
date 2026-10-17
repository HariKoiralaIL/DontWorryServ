package spriteeditor {
import com.company.util.BitmapUtil;

import flash.display.BitmapData;
import flash.events.Event;
import flash.geom.Point;
import flash.utils.Dictionary;

/**
 * Edits a character sprite sheet with one PixelGrid per animation frame.
 * The exported sheet is 7 frame-widths wide: Stand, Walk 1, Walk 2, (gap),
 * Attack 1, then Attack 2 which is two frames wide.
 */
public class AnimatedSpriteEditor extends BitmapEditor {

    /** Sheets this narrow are treated as a single standing frame. */
    private static const SINGLE_FRAME_MAX_WIDTH:int = 16;
    private static const SHEET_FRAMES:int = 7;

    public function AnimatedSpriteEditor(width:int, height:int, frameColumns:int, frameRows:int) {
        var frame:String;
        var grid:PixelGrid;
        this.grids_ = new Dictionary();
        super();
        this.frameSelector_ = new FrameSelector();
        this.frameSelector_.x = ((width / 2) - (this.frameSelector_.width / 2));
        this.frameSelector_.y = -28;
        this.frameSelector_.addEventListener(Event.CHANGE, this.onFrameChange);
        addChild(this.frameSelector_);
        for each (frame in FrameSelector.FRAMES) {
            if (frame == FrameSelector.ATTACK2) {
                grid = new PixelGrid(width, height, (frameColumns * 2), frameRows, true);
            } else {
                grid = new PixelGrid(width, height, frameColumns, frameRows, true);
            }
            this.grids_[frame] = grid;
        }
        this.selected_ = this.grids_[this.frameSelector_.getSelectedFrame()];
        addChild(this.selected_);
    }
    public var frameSelector_:FrameSelector;
    /** Frame name -> PixelGrid. */
    public var grids_:Dictionary;
    private var selected_:PixelGrid = null;

    override public function getBitmapData():BitmapData {
        var frame:BitmapData = this.grids_[FrameSelector.STAND].getBitmapData();
        var frameWidth:int = frame.width;
        var sheet:BitmapData = new BitmapData((frameWidth * SHEET_FRAMES), frame.height, true, 0);
        sheet.copyPixels(frame, frame.rect, new Point(0, 0));
        frame = this.grids_[FrameSelector.WALK1].getBitmapData();
        sheet.copyPixels(frame, frame.rect, new Point(frameWidth, 0));
        frame = this.grids_[FrameSelector.WALK2].getBitmapData();
        sheet.copyPixels(frame, frame.rect, new Point((frameWidth * 2), 0));
        frame = this.grids_[FrameSelector.ATTACK1].getBitmapData();
        sheet.copyPixels(frame, frame.rect, new Point((frameWidth * 4), 0));
        frame = this.grids_[FrameSelector.ATTACK2].getBitmapData();
        sheet.copyPixels(frame, frame.rect, new Point((frameWidth * 5), 0));
        return (sheet);
    }

    override public function loadBitmapData(bitmapData:BitmapData):void {
        var frameWidth:int;
        var frameHeight:int;
        if (bitmapData.width <= SINGLE_FRAME_MAX_WIDTH) {
            this.grids_[FrameSelector.STAND].loadBitmapData(bitmapData);
        } else {
            frameWidth = (bitmapData.width / SHEET_FRAMES);
            frameHeight = bitmapData.height;
            this.grids_[FrameSelector.STAND].loadBitmapData(BitmapUtil.crop(bitmapData, 0, 0, frameWidth, frameHeight));
            this.grids_[FrameSelector.WALK1].loadBitmapData(BitmapUtil.crop(bitmapData, frameWidth, 0, frameWidth, frameHeight));
            this.grids_[FrameSelector.WALK2].loadBitmapData(BitmapUtil.crop(bitmapData, (frameWidth * 2), 0, frameWidth, frameHeight));
            this.grids_[FrameSelector.ATTACK1].loadBitmapData(BitmapUtil.crop(bitmapData, (frameWidth * 4), 0, frameWidth, frameHeight));
            this.grids_[FrameSelector.ATTACK2].loadBitmapData(BitmapUtil.crop(bitmapData, (frameWidth * 5), 0, (frameWidth * 2), frameHeight));
        }
        dispatchEvent(new Event(Event.CHANGE));
    }

    override public function clear():void {
        this.selected_.clear();
    }

    /** Swaps in the grid for the chosen frame; an empty one is seeded from the Stand frame. */
    private function onFrameChange(event:Event):void {
        var standGrid:PixelGrid;
        if (this.selected_ != null) {
            removeChild(this.selected_);
        }
        this.selected_ = this.grids_[this.frameSelector_.getSelectedFrame()];
        addChild(this.selected_);
        if (this.selected_.isEmpty()) {
            standGrid = this.grids_[FrameSelector.STAND];
            this.selected_.loadBitmapData(standGrid.getBitmapData());
            dispatchEvent(new Event(Event.CHANGE));
        }
    }

}
}
