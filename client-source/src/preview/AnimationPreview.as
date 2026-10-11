package preview {
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.assembleegameclient.util._J_H_;
import com.company.assembleegameclient.util._lJ_;
import com.company.util._kp;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.ColorMatrixFilter;
import flash.utils.getTimer;

public class AnimationPreview extends PreviewBase {

    private static var iconsEmbed_:Class = AnimationPreviewIcons;
    private static var icons:_kp = function ():_kp {
        var set:* = new _kp();
        set.addFromBitmapData(new iconsEmbed_().bitmapData, 16, 16);
        return set;
    }();

    private var animChar:_lJ_ = null;
    private var action_:int = 0;
    private var standButton:Sprite;
    private var walkButton:Sprite;
    private var attackButton:Sprite;

    public function AnimationPreview(w:int, h:int) {
        super(w, h);
        var walkBitmap:Bitmap = new Bitmap(icons._W_u[1]);
        walkBitmap.scaleX = walkBitmap.scaleY = 2;
        walkButton = addIcon(walkBitmap, function ():void {
            action_ = _lJ_._m1;
        });
        walkButton.x = (w_ / 2) - (walkButton.width / 2);
        walkButton.y = h_ - walkButton.height - 5;
        var standBitmap:Bitmap = new Bitmap(icons._W_u[0]);
        standBitmap.scaleX = standBitmap.scaleY = 2;
        standButton = addIcon(standBitmap, function ():void {
            action_ = _lJ_._sS_;
        });
        standButton.x = walkButton.x - standButton.width - 5;
        standButton.y = h_ - standButton.height - 5;
        var attackBitmap:Bitmap = new Bitmap(icons._W_u[2]);
        attackBitmap.scaleX = attackBitmap.scaleY = 2;
        attackButton = addIcon(attackBitmap, function ():void {
            action_ = _lJ_._E_w;
        });
        attackButton.x = walkButton.x + walkButton.width + 5;
        attackButton.y = h_ - attackButton.height - 5;
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }

    override public function redraw():void {
        super.redraw();
        standButton.filters = (action_ == _lJ_._sS_) ? [new ColorMatrixFilter(DISABLED_FILTER)] : [];
        walkButton.filters = (action_ == _lJ_._m1) ? [new ColorMatrixFilter(DISABLED_FILTER)] : [];
        attackButton.filters = (action_ == _lJ_._E_w) ? [new ColorMatrixFilter(DISABLED_FILTER)] : [];
        if (source_ == null || source_.width <= 16) {
            return;
        }
        animChar = new _lJ_(new _J_H_(source_, null), source_.width / 7, source_.height, _lJ_.RIGHT);
        drawFrame();
    }

    protected function drawFrame():void {
        if (animChar == null) {
            return;
        }
        var t:Number = (getTimer() % 400) / 400;
        var frame:_J_H_ = animChar.imageFromDir(_lJ_.RIGHT, action_, t);
        bitmap_.bitmapData = TextureRedrawer.redraw(frame.image_, size_, true, 0, 0, false);
        position();
    }

    private function onAddedToStage(e:Event):void {
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function onRemovedFromStage(e:Event):void {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function onEnterFrame(e:Event):void {
        drawFrame();
    }

}
}
