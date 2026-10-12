package client.ui.screens {
import com.company.ui.SimpleText;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import signals.Signal;

/**
 * One clickable row in the news / graveyard list: icon, title, tagline and
 * how long ago it happened. Links of the form "fame:<id>" dispatch
 * fameClicked; anything else opens in the browser.
 */
public class NewsItem extends Sprite {

    public static const HEIGHT:int = 52;
    public static const NORMAL_COLOR:uint = 0xB3B3B3;
    public static const HOVER_COLOR:uint = 0xFFC800;

    public var WIDTH:int = 415;
    public var fameClicked:Signal;
    public var icon:Bitmap;
    public var titleText:SimpleText;
    public var taglineText_:SimpleText;
    public var timeText:SimpleText;
    public var link:String;
    public var accountId:int;

    /**
     * @param timestamp unix time in seconds
     * @param mode News.MODE_NEWS (narrow row) or News.MODE_DEATHS (wide row)
     */
    public function NewsItem(iconData:BitmapData, title:String, tagline:String, link:String, timestamp:int, accountId:int, mode:int = 2) {
        this.fameClicked = new Signal(int);
        super();
        switch (mode) {
            case News.MODE_NEWS:
                this.WIDTH = 325;
                break;
            case News.MODE_DEATHS:
                this.WIDTH = 415;
                break;
        }
        this.link = link;
        this.accountId = accountId;
        buttonMode = true;
        useHandCursor = true;
        tabEnabled = false;
        this.icon = new Bitmap();
        this.icon.bitmapData = iconData;
        this.icon.x = 12;
        this.icon.y = (((HEIGHT / 2) - (iconData.height / 2)) - 3);
        addChild(this.icon);
        this.titleText = this.createText(18, title);
        this.titleText.x = 73;
        addChild(this.titleText);
        this.taglineText_ = this.createText(14, tagline);
        this.taglineText_.x = 73;
        this.taglineText_.y = 24;
        addChild(this.taglineText_);
        this.timeText = this.createText(16, this.formatTimeAgo(timestamp));
        this.timeText.x = (this.WIDTH - this.timeText.width);
        addChild(this.timeText);
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
        addEventListener(MouseEvent.MOUSE_DOWN, this.onMouseDown);
    }

    private function createText(size:int, value:String):SimpleText {
        var field:SimpleText = new SimpleText(size, NORMAL_COLOR, false, 0, 0, "Myriad Pro");
        field.text = value;
        field.updateMetrics();
        field.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        return field;
    }

    private function formatTimeAgo(timestamp:int):String {
        var now:Number = (new Date().time / 1000);
        var seconds:int = (now - timestamp);
        if (seconds <= 0) {
            return "now";
        }
        if (seconds < 60) {
            return (seconds + " secs");
        }
        if (seconds < (60 * 60)) {
            return (int((seconds / 60)) + " mins");
        }
        if (seconds < ((60 * 60) * 24)) {
            return (int((seconds / (60 * 60))) + " hours");
        }
        return (int((seconds / ((60 * 60) * 24))) + " days");
    }

    protected function onMouseOver(event:MouseEvent):void {
        this.setColor(HOVER_COLOR);
    }

    protected function onRollOut(event:MouseEvent):void {
        this.setColor(NORMAL_COLOR);
    }

    protected function onMouseDown(event:MouseEvent):void {
        var parts:Array = this.link.split(":", 2);
        if (parts[0] == "fame") {
            this.fameClicked.dispatch(int(parts[1]));
            return;
        }
        navigateToURL(new URLRequest(this.link), "_blank");
    }

    private function setColor(color:uint):void {
        this.titleText.setColor(color);
        this.taglineText_.setColor(color);
        this.timeText.setColor(color);
    }

}
}
