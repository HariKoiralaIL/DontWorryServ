package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.GraphicHelper;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Sprite;

/** Tab header with an icon. Owns the content panel (holder_) that is shown while it is selected. */
public class TabButton extends Sprite {

    public static const WIDTH:int = 28;
    public static const HEIGHT:int = 24;

    private static const SELECTED_COLOR:uint = 0x191919;
    private static const UNSELECTED_COLOR:uint = 0x4C4C4C;
    private static const HOLDER_WIDTH:int = 186;
    private static const HOLDER_HEIGHT:int = 98;
    private static const HOLDER_Y:int = 22;

    public var iconRaw_:BitmapData;
    public var icon_:BitmapData;
    public var selected_:Boolean = false;
    public var tabId_:int = 0;
    /** The content panel of this tab; add the tab's controls to it. */
    public var holder_:TabBackground;

    protected var fill_:GraphicsSolidFill;
    protected var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());

    private var iconBitmap_:Bitmap;
    private var graphicsData_:Vector.<IGraphicsData>;

    public function TabButton(icon:BitmapData, selected:Boolean, tabId:int) {
        super();
        this.selected_ = selected;
        this.iconRaw_ = icon;
        this.icon_ = TextureRedrawer.redraw(this.iconRaw_, 320 / this.iconRaw_.width, true, 0, 0);
        this.holder_ = new TabBackground(HOLDER_WIDTH, HOLDER_HEIGHT);
        this.holder_.x = -WIDTH * tabId;
        this.holder_.y = HOLDER_Y;
        this.holder_.visible = selected;
        this.addChild(this.holder_);
        this.tabId_ = tabId;
        this.draw();
    }

    public function setSelected(selected:Boolean):void {
        this.selected_ = selected;
        this.holder_.visible = selected;
        this.draw();
    }

    public function updateFill(selected:Boolean):void {
        this.fill_ = new GraphicsSolidFill(selected ? SELECTED_COLOR : UNSELECTED_COLOR, 1);
        this.graphicsData_ = new <IGraphicsData>[this.fill_, this.path_, GraphicHelper.END_FILL];
    }

    public function draw():void {
        this.updateFill(this.selected_);
        GraphicHelper.clearPath(this.path_);
        GraphicHelper.drawUI(0, 0, WIDTH, HEIGHT + 4, 2, [1, 1, 0, 0], this.path_);
        this.graphics.clear();
        this.graphics.drawGraphicsData(this.graphicsData_);
        if (this.iconBitmap_ == null) {
            this.iconBitmap_ = new Bitmap(this.icon_);
            this.iconBitmap_.x = -6;
            this.iconBitmap_.y = -10;
            this.addChild(this.iconBitmap_);
        }
        this.holder_.draw(this.tabId_ == 0);
    }
}
}
