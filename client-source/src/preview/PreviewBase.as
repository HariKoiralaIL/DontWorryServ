package preview {
import com.company.ui.SimpleText;
import com.company.util.MoreColorUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.ColorMatrixFilter;

public class PreviewBase extends Sprite {

    private static const MAX_SIZE:int = 300;
    private static const MIN_SIZE:int = 40;
    private static const ZOOM_STEP:int = 20;
    protected static const DISABLED_FILTER:Array = MoreColorUtil._fL_(0x4F4F4F);

    private static var zoomInIcon:Class = ZoomInIcon;
    private static var zoomOutIcon:Class = ZoomOutIcon;

    protected var w_:int;
    protected var h_:int;
    protected var size_:int;
    protected var source_:BitmapData;
    protected var bitmap_:Bitmap;
    private var sizeText:SimpleText;
    private var zoomInButton:Sprite;
    private var zoomOutButton:Sprite;

    public function PreviewBase(w:int, h:int) {
        w_ = w;
        h_ = h;
        size_ = 100;
        graphics.lineStyle(1, 0xFFFFFF);
        graphics.beginFill(0x7F7F7F, 1);
        graphics.drawRect(0, 0, w_, h_);
        graphics.lineStyle();
        graphics.endFill();
        bitmap_ = new Bitmap();
        addChild(bitmap_);
        sizeText = new SimpleText(16, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        sizeText.setBold(true);
        sizeText.text = size_ + "%";
        sizeText.updateMetrics();
        sizeText.x = 2;
        addChild(sizeText);
        zoomInButton = addIcon(new zoomInIcon(), zoomIn);
        zoomInButton.x = w_ - zoomInButton.width - 5;
        zoomInButton.y = 5;
        zoomOutButton = addIcon(new zoomOutIcon(), zoomOut);
        zoomOutButton.x = zoomInButton.x - zoomOutButton.width - 5;
        zoomOutButton.y = 5;
    }

    public function setBitmap(bmd:BitmapData):void {
        source_ = bmd;
        redraw();
        position();
    }

    public function redraw():void {
        sizeText.text = size_ + "%";
        sizeText.updateMetrics();
        zoomInButton.filters = (size_ == MAX_SIZE) ? [new ColorMatrixFilter(DISABLED_FILTER)] : [];
        zoomOutButton.filters = (size_ == MIN_SIZE) ? [new ColorMatrixFilter(DISABLED_FILTER)] : [];
    }

    public function position():void {
        bitmap_.x = (w_ / 2) - (bitmap_.width / 2);
        bitmap_.y = (h_ / 2) - (bitmap_.height / 2);
    }

    protected function addIcon(icon:Bitmap, callback:Function):Sprite {
        var button:Sprite = new Sprite();
        button.addChild(icon);
        var cb:IconCallback = new IconCallback(this, callback);
        button.addEventListener(MouseEvent.MOUSE_DOWN, cb.handler);
        addChild(button);
        return button;
    }

    private function zoomIn():void {
        if (size_ == MAX_SIZE) {
            return;
        }
        size_ += ZOOM_STEP;
    }

    private function zoomOut():void {
        if (size_ == MIN_SIZE) {
            return;
        }
        size_ -= ZOOM_STEP;
    }

}
}

import preview.PreviewBase;

import flash.events.Event;

class IconCallback {

    public var preview_:PreviewBase;
    public var callback_:Function;

    public function IconCallback(preview:PreviewBase, callback:Function):void {
        preview_ = preview;
        callback_ = callback;
    }

    public function handler(e:Event):void {
        callback_();
        preview_.redraw();
        preview_.position();
    }

}
