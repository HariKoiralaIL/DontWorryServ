package com.company.assembleegameclient.appengine {
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.util.AssetLibrary;

import flash.display.BitmapData;

public class NewsEntry {

    private static const FAME_ICON_TYPE:String = "fame";
    private static const ICON_SIZE:int = 80;

    public var iconImage_:BitmapData;
    public var iconType_:String;
    public var title_:String;
    public var tagline_:String;
    public var link_:String;
    public var date_:int;

    public function NewsEntry(iconType:String, title:String, tagline:String, link:String, date:int) {
        this.iconType_ = iconType;
        this.title_ = title;
        this.tagline_ = tagline;
        this.link_ = link;
        this.date_ = date;
    }

    private static function getDefaultIcon():BitmapData {
        return TextureRedrawer.redraw(AssetLibrary.getImageFromSet("lofiInterface2", 4), ICON_SIZE, true, 0, 0);
    }

    private static function getFameIcon():BitmapData {
        return TextureRedrawer.redraw(AssetLibrary.getImageFromSet("lofiObj3", 224), ICON_SIZE, true, 0, 0);
    }

    public function getIcon():BitmapData {
        return this.isDeath() ? getFameIcon() : getDefaultIcon();
    }

    public function isDeath():Boolean {
        return this.iconType_ == FAME_ICON_TYPE;
    }

}
}
