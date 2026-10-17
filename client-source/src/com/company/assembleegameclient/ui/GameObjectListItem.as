package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.ui.SimpleText;
import com.company.util.MoreColorUtil;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.ColorTransform;

/**
 * Portrait plus coloured name of a game object / player, used in player list
 * tooltips and menus. The name colour reflects party / guild / special players.
 *
 * Formerly: ui_playerslist
 */
public class GameObjectListItem extends Sprite {

    /** Show "<b>name</b> (class level)" as HTML instead of a plain name (formerly _H_a). */
    public var detailed_:Boolean;
    public var go_:GameObject;

    private var portrait_:Bitmap;
    private var nameText_:SimpleText;
    private var color_:uint;
    private var lastColor_:uint = 0xFFFFFF;
    private var lastText_:String = null;
    private var lastHtml_:Boolean = false;
    private var lastColorTransform_:ColorTransform = null;

    public function GameObjectListItem(color:uint, detailed:Boolean, go:GameObject) {
        super();
        this.detailed_ = detailed;
        this.color_ = color;
        this.portrait_ = new Bitmap();
        this.portrait_.x = -4;
        this.portrait_.y = -4;
        addChild(this.portrait_);
        if (this.detailed_) {
            this.nameText_ = new SimpleText(13, color, false, 0, 0, "Myriad Pro");
        } else {
            this.nameText_ = new SimpleText(13, color, false, 66, 20, "Myriad Pro");
            this.nameText_.setBold(true);
        }
        this.nameText_.x = 32;
        this.nameText_.y = 6;
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
        addChild(this.nameText_);
        this.draw(go);
    }

    public function draw(go:GameObject, colorTransform:ColorTransform = null):void {
        this.go_ = go;
        visible = (this.go_ != null);
        if (!visible) {
            return;
        }
        this.portrait_.bitmapData = this.go_.getPortrait();
        var color:uint = this.color_;
        var text:String;
        var html:Boolean;
        var player:Player = this.go_ as Player;
        if (player != null) {
            if (player.inParty) {
                color = Parameters.partyColor;
            } else if (player.isFellowGuild_) {
                color = Parameters._mg;
            } else if (player.name_ == "$Bledixon$") {
                color = Parameters._colorBled;
            } else if (player.name_ == "Quest") {
                color = Parameters._colorArc;
            } else if (player.name_ == "Antidote") {
                color = Parameters._colorSec;
            } else if (player.name_ == "Crisp") {
                color = Parameters._colorSec;
            } else if (player.nameChosen_) {
                color = Parameters._8T_;
            }
        }
        var displayId:String = ObjectLibrary.typeToDisplayId_[this.go_.objectType_];
        var hasName:Boolean = (this.go_.name_ != null && this.go_.name_ != "");
        if (this.detailed_) {
            html = true;
            if (hasName) {
                text = "<b>" + this.go_.name_ + "</b> (" + displayId;
                if (this.go_.level_ < 1) {
                    text = text + ")";
                } else {
                    text = text + (" " + this.go_.level_ + ")");
                }
            } else {
                text = "<b>" + displayId + "</b>";
            }
        } else {
            text = hasName ? this.go_.name_ : displayId;
        }
        this.update(color, text, html, colorTransform);
    }

    /** Applies colour / text / tint, skipping work when nothing changed. Formerly _0E_J_. */
    private function update(color:uint, text:String, html:Boolean, colorTransform:ColorTransform):void {
        if (color == this.lastColor_ && text == this.lastText_ && html == this.lastHtml_ && colorTransform == this.lastColorTransform_) {
            return;
        }
        this.nameText_.setColor(color);
        if (html) {
            this.nameText_.htmlText = text;
        } else {
            this.nameText_.text = text;
        }
        this.nameText_.updateMetrics();
        if (this.lastColorTransform_ != null || colorTransform != null) {
            transform.colorTransform = (colorTransform == null) ? MoreColorUtil.identity : colorTransform;
        }
        this.lastColor_ = color;
        this.lastText_ = text;
        this.lastHtml_ = html;
        this.lastColorTransform_ = colorTransform;
    }
}
}
