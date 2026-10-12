package client.ui.screens {
import _011.MapInfo;

import com.company.ui.SimpleText;

import com.gskinner.motion.GTween;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.text.TextFieldAutoSize;
import flash.utils.Timer;

/**
 * Overlay shown while a map loads: map name, difficulty pips and an animated
 * two-frame character. Stays up for at least MIN_DISPLAY_MS after hide() was
 * requested, then fades out and removes itself.
 */
public class MapLoadingOverlay extends Sprite {

    public static const MIN_DISPLAY_MS:Number = 1000;
    public static const MAX_DIFFICULTY:int = 5;
    public static const FADE_DURATION:Number = 0.4;
    public static const TIMER_INTERVAL_MS:Number = 200;

    public var assetClass:Class = MapLoadingScreenAsset;

    private var screen:DisplayObjectContainer;
    private var mapNameText:SimpleText;
    private var difficultyIndicators:Vector.<DisplayObject>;
    private var difficultyContainer:MovieClip;
    private var charContainer:MovieClip;
    private var hideRequested:Boolean;
    private var loader:MovieClipAssetLoader;
    private var mapName:String;
    private var difficulty_:int;
    private var frame1:BitmapData;
    private var frame2:BitmapData;
    private var characterBitmap:Bitmap;
    private var timer:Timer;

    public function MapLoadingOverlay() {
        super();
        this.loader = new MovieClipAssetLoader(this.assetClass);
        this.loader.ready.addOnce(this.onAssetReady);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    public function display(mapInfo:MapInfo, difficulty:int, frame1:BitmapData, frame2:BitmapData):void {
        this.mapName = (mapInfo.conMessage_ != "") ? mapInfo.conMessage_ : ((mapInfo.name_) ? mapInfo.name_ : "");
        this.difficulty_ = difficulty;
        if (frame1 && frame2) {
            this.frame1 = frame1;
            this.frame2 = frame2;
            this.characterBitmap = new Bitmap(this.frame1);
        }
        this.refresh();
    }

    /** Request removal; the screen fades out once the minimum display time has passed. */
    public function hide(unused:Boolean = false):void {
        this.hideRequested = true;
        this.tryHide();
    }

    private function onAssetReady(loader:MovieClipAssetLoader):void {
        this.screen = (loader.content as MovieClip);
        var nameContainer:MovieClip = (this.screen.getChildByName("mapNameContainer") as MovieClip);
        this.mapNameText = new SimpleText(30, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.mapNameText.setBold(true);
        this.mapNameText.autoSize = TextFieldAutoSize.CENTER;
        this.mapNameText.updateMetrics();
        this.mapNameText.x = nameContainer.x;
        this.mapNameText.y = nameContainer.y;
        this.screen.addChild(this.mapNameText);
        this.charContainer = (this.screen.getChildByName("charContainer") as MovieClip);
        this.difficultyContainer = (this.screen.getChildByName("difficulty_indicators") as MovieClip);
        this.difficultyContainer.visible = true;
        this.screen.getChildByName("bgGroup").visible = false;
        this.difficultyIndicators = new Vector.<DisplayObject>(MAX_DIFFICULTY);
        var index:int = 1;
        while (index <= MAX_DIFFICULTY) {
            this.difficultyIndicators[(index - 1)] = this.difficultyContainer.getChildByName(("indicator_" + index));
            index++;
        }
        addChild(this.screen);
        this.timer = new Timer(TIMER_INTERVAL_MS);
        this.refresh();
    }

    private function refresh():void {
        if (!this.screen) {
            return;
        }
        this.mapNameText.text = this.mapName;
        if (this.difficulty_ <= 0) {
            this.screen.getChildByName("bgGroup").visible = false;
            this.difficultyContainer.visible = false;
        } else {
            this.screen.getChildByName("bgGroup").visible = true;
            this.difficultyContainer.visible = true;
            var index:int = 0;
            while (index < MAX_DIFFICULTY) {
                this.difficultyIndicators[index].visible = (index < this.difficulty_);
                index++;
            }
        }
        if (this.characterBitmap) {
            addChild(this.characterBitmap);
            this.characterBitmap.x = ((this.charContainer.x - (this.characterBitmap.width / 2)) + 5);
            this.characterBitmap.y = (this.charContainer.y - (this.characterBitmap.height / 2));
        }
        this.timer.addEventListener(TimerEvent.TIMER, this.onTimer);
        this.timer.start();
    }

    private function fadeOut():void {
        var tween:GTween = new GTween(this, FADE_DURATION, {"alpha": 0});
        tween.onComplete = this.onFadeComplete;
        mouseEnabled = false;
        mouseChildren = false;
    }

    private function onFadeComplete(tween:GTween):void {
        ((parent) && (parent.removeChild(this)));
    }

    private function tryHide():void {
        if (this.hideRequested && this.timer != null && this.timer.currentCount >= (MIN_DISPLAY_MS / TIMER_INTERVAL_MS)) {
            this.fadeOut();
        }
    }

    private function onTimer(event:TimerEvent):void {
        if (this.characterBitmap) {
            this.characterBitmap.bitmapData = (((this.characterBitmap.bitmapData == this.frame2)) ? this.frame1 : this.frame2);
        }
        this.tryHide();
    }

    private function onRemovedFromStage(event:Event):void {
        if (this.timer) {
            this.timer.stop();
            this.timer = null;
        }
    }

}
}
