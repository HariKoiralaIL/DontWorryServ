// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.ClassToolTip

package com.company.assembleegameclient.ui.tooltip {
import flash.display.Bitmap;

import com.company.ui.SimpleText;
import com.company.assembleegameclient.ui._return;
import com.company.assembleegameclient.util._0B_c;
import com.company.assembleegameclient.util._lJ_;
import com.company.assembleegameclient.util._J_H_;
import com.company.assembleegameclient.util.TextureRedrawer;

import flash.display.BitmapData;

import com.company.util._G_;

import flash.geom.ColorTransform;
import flash.filters.DropShadowFilter;

import com.company.assembleegameclient.util._Z_B_;
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.appengine.Server_list;
import com.company.assembleegameclient.appengine._0A_H_;

public class ClassToolTip extends ToolTip {

    public function ClassToolTip(xml2:XML, server_list:Server_list, _0a_h_:_0A_H_) {
        var _local9:int;
        var _local10:int;
        var xml:XML;
        var _local12:int;
        var _local13:int;
        super(0x2A2A2A, 1, 0xFFFFFF, 1);
        var _local4:_lJ_ = _0B_c._J_v(String(xml2.AnimatedTexture.File), int(xml2.AnimatedTexture.Index));
        var _j_h_:_J_H_ = _local4.imageFromDir(_lJ_.RIGHT, _lJ_._sS_, 0);
        var _local6:int = ((4 / _j_h_.width()) * 100);
        var bitmapData2:BitmapData = TextureRedrawer.redraw(_j_h_.image_, _local6, true, 0, 0);
        var _local8:Boolean = server_list.isAvailable(int(xml2.@type));
        if (!_local8) {
            bitmapData2 = _G_._B_2(bitmapData2, new ColorTransform(0, 0, 0, 0.5, 0, 0, 0, 0));
        }
        this.portrait_ = new Bitmap();
        this.portrait_.bitmapData = bitmapData2;
        this.portrait_.x = -4;
        this.portrait_.y = -4;
        addChild(this.portrait_);
        this.nameText_ = new SimpleText(13, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        this.nameText_.setBold(true);
        this.nameText_.text = xml2.@id;
        this.nameText_.updateMetrics();
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0)];
        this.nameText_.x = 32;
        this.nameText_.y = 6;
        addChild(this.nameText_);
        this.desc_ = new SimpleText(13, 0xB3B3B3, false, 174, 0, "Myriad Pro");
        this.desc_.wordWrap = true;
        this.desc_.multiline = true;
        this.desc_.text = xml2.Description;
        this.desc_.updateMetrics();
        this.desc_.filters = [new DropShadowFilter(0, 0, 0)];
        this.desc_.x = 8;
        this.desc_.y = 40;
        addChild(this.desc_);
        this.divider_ = new _return(100, 0x2D2D2D);
        this.divider_.x = 6;
        this.divider_.y = height;
        addChild(this.divider_);
        if (_local8) {
            _local9 = (((_0a_h_ == null)) ? 0 : _0a_h_._lr());
            this.statsText_ = new SimpleText(12, 6206769, false, 0, 0, "Myriad Pro");
            this.statsText_.text = ((((((_local9 + " of " + _Z_B_._yJ_.length + " C-Quests Completed\n") + "Best Level Achieved: ") + (((_0a_h_) != null) ? _0a_h_.bestLevel() : 0)) + "\n") + "Best Fame Achieved: ") + (((_0a_h_) != null) ? _0a_h_._0D_E_() : 0));
            this.statsText_.updateMetrics();
            this.statsText_.filters = [new DropShadowFilter(0, 0, 0)];
            this.statsText_.x = 8;
            this.statsText_.y = (height - 2);
            addChild(this.statsText_);
            _local10 = _Z_B_._F_U_((((_0a_h_ == null)) ? 0 : _0a_h_._0D_E_()), 0);
            if (_local10 > 0) {
                this.nextGoalText_ = new SimpleText(10, 16549442, false, 174, 0, "Myriad Pro");
                this.nextGoalText_.text = (((("Next Goal: Earn " + _local10) + " Fame\n") + "  with a ") + xml2.@id);
                this.nextGoalText_.updateMetrics();
                this.nextGoalText_.filters = [new DropShadowFilter(0, 0, 0)];
                this.nextGoalText_.x = 8;
                this.nextGoalText_.y = (height - 2);
                addChild(this.nextGoalText_);
            }
        } else {
            this.unlockText_ = new SimpleText(13, 0xB3B3B3, false, 174, 0, "Myriad Pro");
            this.unlockText_.setBold(true);
            this.unlockText_.text = "To Unlock:";
            this.unlockText_.updateMetrics();
            this.unlockText_.filters = [new DropShadowFilter(0, 0, 0)];
            this.unlockText_.x = 8;
            this.unlockText_.y = (height - 2);
            addChild(this.unlockText_);
            this.unlockText_ = new SimpleText(13, 16549442, false, 174, 0, "Myriad Pro");
            this.unlockText_.wordWrap = false;
            this.unlockText_.multiline = true;
            for each (xml in xml2.UnlockLevel) {
                _local12 = ObjectLibrary._pb[xml.toString()];
                _local13 = int(xml.@level);
                if (server_list.bestLevel(_local12) < int(xml.@level)) {
                    if (this.unlockText_.text != "") {
                        this.unlockText_.text = (this.unlockText_.text + "\n");
                    }
                    this.unlockText_.text = (this.unlockText_.text + ((("Reach Level " + _local13) + " with ") + ObjectLibrary._0D_N_[_local12]));
                }
            }
            this.unlockText_.border = false;
            this.unlockText_.updateMetrics();
            this.unlockText_.filters = [new DropShadowFilter(0, 0, 0)];
            this.unlockText_.x = 12;
            this.unlockText_.y = (height - 4);
            addChild(this.unlockText_);
        }
    }
    private var portrait_:Bitmap;
    private var nameText_:SimpleText;
    private var desc_:SimpleText;
    private var divider_:_return;
    private var statsText_:SimpleText;
    private var unusedText_:SimpleText;
    private var unlockText_:SimpleText;
    private var nextGoalText_:SimpleText;

    override public function draw():void {
        this.divider_._rs((width - 10), 0x2D2D2D);
        super.draw();
    }

}
}//package com.company.assembleegameclient.ui.tooltip

