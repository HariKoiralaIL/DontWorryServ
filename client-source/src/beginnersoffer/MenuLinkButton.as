package beginnersoffer {
import audio.SoundEffects;

import com.company.assembleegameclient.ui.tooltip.TitleDescriptionToolTip;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.net.URLRequest;
import flash.net.navigateToURL;

/**
 * Small menu button with an optional icon and a label.
 * Clicking it runs one of the ACTION_* actions.
 */
public class MenuLinkButton extends Sprite {

    public static const WIDTH:int = 280;
    public static const HEIGHT:int = 185;

    public static const ACTION_UPDATE:String = "UPDATE";
    public static const ACTION_DONATE:String = "DONATE";
    public static const ACTION_DISCORD:String = "DISCORD";
    public static const ACTION_RAID:String = "RAID";

    private static const DONATE_URL:String = "http://bledixon.com/donate";
    private static const DISCORD_URL:String = "https://discord.gg/kUBTYRm";

    private static const ICON_SPRITE_SHEET:String = "lofiInterface2";
    private static const ICON_SCALE:int = 40;
    private static const ICON_X:int = -5;
    private static const ICON_Y:int = -8;

    private static const FONT:String = "Myriad Pro";
    private static const FONT_SIZE:int = 16;
    private static const TEXT_X_WITH_ICON:int = 28;
    private static const TEXT_X_WITHOUT_ICON:int = 10;
    private static const TEXT_Y:int = 3;

    private static const CLICK_SOUND:String = "button_click";

    private var hasIcon:Boolean;
    private var icon:Bitmap;
    private var background:Sprite;
    private var label:SimpleText;
    private var action:String;
    private var tooltip:TitleDescriptionToolTip = new TitleDescriptionToolTip(
            0x2A2A2A, 0x9B9B9B, "Halloween Raid", "To access it simply type /raid hw!", 200);

    public function MenuLinkButton(hasIcon:Boolean = true, iconIndex:int = 15, labelText:String = "Updates",
                                   action:String = "UPDATE", textColor:int = 0xFFFFFF, buttonWidth:int = 89) {
        this.hasIcon = hasIcon;
        if (this.hasIcon) {
            var iconData:BitmapData = TextureRedrawer.redraw(
                    AssetLibrary.getImageFromSet(ICON_SPRITE_SHEET, iconIndex), ICON_SCALE, true, 0, 0);
            this.icon = new Bitmap(iconData);
            this.icon.x = ICON_X;
            this.icon.y = ICON_Y;
        }
        this.background = RoundedBackground.create(buttonWidth);
        this.background.mouseChildren = false;
        this.background.mouseEnabled = true;
        this.label = new SimpleText(FONT_SIZE, textColor, false, 0, 0, FONT);
        this.label.text = labelText;
        this.label.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        this.draw();
        this.label.x = this.hasIcon ? TEXT_X_WITH_ICON : TEXT_X_WITHOUT_ICON;
        this.label.y = TEXT_Y;
        this.action = action.toUpperCase();
        this.background.addEventListener(MouseEvent.CLICK, this.openUI);
        this.background.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        this.background.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
    }

    public function openUI(event:MouseEvent):void {
        switch (this.action) {
            case ACTION_DONATE:
                navigateToURL(new URLRequest(DONATE_URL));
                break;
            case ACTION_DISCORD:
                navigateToURL(new URLRequest(DISCORD_URL));
                break;
            case ACTION_UPDATE:
            case ACTION_RAID:
            default:
                break;
        }
        SoundEffects.play(CLICK_SOUND);
    }

    public function draw():void {
        addChild(this.background);
        addChild(this.label);
        if (this.hasIcon) {
            addChild(this.icon);
        }
    }

    private function onMouseOver(event:MouseEvent):void {
        stage.addChild(this.tooltip);
    }

    private function onMouseOut(event:MouseEvent):void {
        stage.removeChild(this.tooltip);
    }
}
}
