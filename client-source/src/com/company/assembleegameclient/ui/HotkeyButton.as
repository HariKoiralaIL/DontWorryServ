package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.tooltip.TitleDescriptionToolTip;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.KeyCodes;
import com.company.util.MoreColorUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;

/**
 * Icon button that highlights on hover and shows a tooltip with the key
 * currently bound to its action.
 *
 * Formerly: _rN_
 */
public class HotkeyButton extends Sprite {

    protected static const HOVER_TRANSFORM:ColorTransform = new ColorTransform(1, 220 / 0xFF, 133 / 0xFF);

    protected var iconRaw_:BitmapData;
    protected var iconRedrawn_:BitmapData;
    protected var bitmap_:Bitmap;
    protected var hotkeyName_:String;
    protected var colorTransform_:ColorTransform = null;
    protected var toolTip_:TitleDescriptionToolTip = null;

    /**
     * @param icon       button icon
     * @param title      tooltip title; an empty string disables the tooltip
     * @param hotkeyName key in Parameters.data_ holding the bound key code
     */
    public function HotkeyButton(icon:BitmapData, title:String, hotkeyName:String) {
        super();
        this.iconRaw_ = icon;
        this.iconRedrawn_ = TextureRedrawer.redraw(this.iconRaw_, 320 / this.iconRaw_.width, true, 0, 0);
        this.bitmap_ = new Bitmap(this.iconRedrawn_);
        this.bitmap_.x = -12;
        this.bitmap_.y = -12;
        addChild(this.bitmap_);
        this.hotkeyName_ = hotkeyName;
        if (title != "") {
            this.toolTip_ = new TitleDescriptionToolTip(0x2A2A2A, 0x9B9B9B, title, "", 200);
        }
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
    }

    /** Formerly _037 */
    public function setColorTransform(colorTransform:ColorTransform):void {
        if (colorTransform == this.colorTransform_) {
            return;
        }
        this.colorTransform_ = colorTransform;
        if (this.colorTransform_ == null) {
            transform.colorTransform = MoreColorUtil.identity;
        } else {
            transform.colorTransform = this.colorTransform_;
        }
    }

    protected function onMouseOver(event:MouseEvent):void {
        this.setColorTransform(HOVER_TRANSFORM);
        if (this.toolTip_ != null && !stage.contains(this.toolTip_)) {
            this.toolTip_.setDescription("Hotkey: " + KeyCodes.KEY_NAMES[Parameters.data_[this.hotkeyName_]]);
            stage.addChild(this.toolTip_);
        }
    }

    protected function onMouseOut(event:MouseEvent):void {
        this.setColorTransform(null);
        this.removeToolTip();
    }

    private function onRemovedFromStage(event:Event):void {
        this.removeToolTip();
    }

    private function removeToolTip():void {
        if (this.toolTip_ != null && this.toolTip_.parent != null) {
            this.toolTip_.parent.removeChild(this.toolTip_);
        }
    }
}
}
