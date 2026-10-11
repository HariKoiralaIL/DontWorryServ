package beginnersoffer {
import signals.nativesignals.NativeRelaySignal;

import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import signals.Signal;

/**
 * HUD button showing a loot bag icon and the number of days
 * left on the beginner's offer.
 */
public class BeginnersOfferButton extends Sprite {

    private static const FONT:String = "Myriad Pro";
    private static const FONT_SIZE:int = 18;
    private static const TEXT_COLOR:uint = 0xFFFFFF;

    private static const ICON_SPRITE_SHEET:String = "redLootBag";
    private static const ICON_SPRITE_INDEX:int = 0;
    private static const ICON_SCALE:int = 40;

    private static const TEXT_OFFSET_X:int = 30;
    private static const TEXT_Y:int = 5;

    private static const CLICK_AREA_X:int = -33;
    private static const CLICK_AREA_Y:int = 7;
    private static const CLICK_AREA_WIDTH:int = 95;
    private static const CLICK_AREA_HEIGHT:int = 25;
    private static const CLICK_AREA_CORNER_RADIUS:int = 12;

    public var click:Signal;
    private var daysText:SimpleText;
    private var icon:Bitmap;
    private var clickArea:Sprite;
    private var daysLeft:int = -1;

    public function BeginnersOfferButton() {
        tabChildren = false;
        tabEnabled = false;
        build();
        this.click = new NativeRelaySignal(this.clickArea, MouseEvent.CLICK);
    }

    public function setDaysLeft(days:int):void {
        if (this.daysLeft != days) {
            this.daysLeft = days;
            updateText();
        }
    }

    public function destroy():void {
        parent.removeChild(this);
    }

    private function build():void {
        createIcon();
        createDaysText();
        setDaysLeft(0);
        createClickArea();
    }

    private function createIcon():void {
        var bitmapData:BitmapData = AssetLibrary._xK_(ICON_SPRITE_SHEET, ICON_SPRITE_INDEX);
        bitmapData = TextureRedrawer.redraw(bitmapData, ICON_SCALE, true, 0, 0);
        this.icon = new Bitmap(bitmapData);
        this.icon.x = -this.icon.width;
        addChild(this.icon);
    }

    private function createDaysText():void {
        this.daysText = new SimpleText(FONT_SIZE, TEXT_COLOR, false, 0, 0, FONT);
        this.daysText.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        updateText();
        addChild(this.daysText);
    }

    private function updateText():void {
        this.daysText.text = this.daysLeft.toString() + " day" + ((this.daysLeft > 1) ? "s" : "");
        this.daysText.x = this.icon.x + TEXT_OFFSET_X;
        this.daysText.y = TEXT_Y;
    }

    private function createClickArea():void {
        this.clickArea = new Sprite();
        this.clickArea.graphics.beginFill(0, 0);
        this.clickArea.graphics.drawRoundRect(0, 0, CLICK_AREA_WIDTH, CLICK_AREA_HEIGHT,
                CLICK_AREA_CORNER_RADIUS, CLICK_AREA_CORNER_RADIUS);
        this.clickArea.graphics.endFill();
        this.clickArea.buttonMode = true;
        this.clickArea.x = CLICK_AREA_X;
        this.clickArea.y = CLICK_AREA_Y;
        addChild(this.clickArea);
    }
}
}
