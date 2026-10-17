package client.ui.screens {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.assembleegameclient.util.AnimatedCharLibrary;
import com.company.assembleegameclient.util.MaskedImage;
import com.company.assembleegameclient.util.FameUtil;
import com.company.assembleegameclient.util.AnimatedChar;
import com.company.audio.SoundEffects;
import com.company.rotmg.graphics.FameIconBackgroundDesign;
import com.company.ui.SimpleText;
import com.company.util.BitmapUtil;

import com.gskinner.motion.GTween;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.geom.Rectangle;

import signals.Signal;
import signals.nativesignals.NativeRelaySignal;

/**
 * Death / character-summary screen: portrait on a fame badge, title, death
 * date and killer, animated stats list, total fame and a continue button.
 */
public class DeathScreen extends Sprite {

    private static const TITLE_TEMPLATE:String = "${NAME}, Level ${LEVEL} ${TYPE}";
    private static const KILLED_TEMPLATE:String = "killed on ${DATE} by ${KILLER}";
    private static const DIED_TEMPLATE:String = "died ${DATE}";

    public var continueClicked:Signal;

    private var contentContainer:DisplayObjectContainer;
    private var fadeContainer:DisplayObjectContainer;
    private var title:SimpleText;
    private var date:SimpleText;
    private var statsPanel:StatsPanel;
    private var totalFameRow:StatRow;
    private var continueButton:MenuButton;
    private var skipAnimation:Boolean;
    private var fadeComplete:Boolean;
    private var dataReady:Boolean;

    public function DeathScreen() {
        addChild(new _charscreen());
        addChild((this.contentContainer = new Sprite()));
        addChild((this.fadeContainer = new Sprite()));
        this.continueButton = new MenuButton("continue", 36, false);
        this.continueClicked = new NativeRelaySignal(this.continueButton, MouseEvent.CLICK);
    }

    /** When true the stats appear instantly and no fade has to finish first. */
    public function setSkipAnimation(value:Boolean):void {
        this.skipAnimation = value;
    }

    /** Overlays the given picture and fades it out over two seconds. */
    public function playDeathFade(picture:BitmapData):void {
        this.fadeContainer.addChild(new Bitmap(picture));
        var tween:GTween = new GTween(this.fadeContainer, 2, {"alpha": 0});
        tween.onComplete = this.onFadeComplete;
        SoundEffects.play("death_screen");
    }

    public function setTitle(characterName:String, level:int, classType:int):void {
        this.title = new SimpleText(38, 0xCCCCCC, false, 0, 0, "Myriad Pro");
        this.title.setBold(true);
        this.title.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        this.title.text = TITLE_TEMPLATE.replace("${NAME}", characterName).replace("${LEVEL}", level).replace("${TYPE}", ObjectLibrary.typeToDisplayId_[classType]);
        this.title.updateMetrics();
        this.title.x = ((800 / 2) - (this.title.width / 2));
        this.title.y = 225;
        this.contentContainer.addChild(this.title);
    }

    public function setDeathInfo(deathDate:String, killer:String):void {
        this.date = new SimpleText(24, 0xCCCCCC, false, 0, 0, "Myriad Pro");
        this.date.setBold(true);
        this.date.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        this.date.text = ((killer) ? KILLED_TEMPLATE : DIED_TEMPLATE).replace("${DATE}", deathDate).replace("${KILLER}", killer);
        this.date.updateMetrics();
        this.date.x = ((800 / 2) - (this.date.width / 2));
        this.date.y = 272;
        this.contentContainer.addChild(this.date);
    }

    public function setCharacterPortrait(characterXML:XML):void {
        var badge:Sprite = new Sprite();
        var badgeBackground:Sprite = new FameIconBackgroundDesign();
        badgeBackground.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        badge.addChild(badgeBackground);
        var character:XML = new XML(characterXML);
        var baseXML:XML = ObjectLibrary.typeToXML_[int(character.ObjectType)];
        var skinId:int = int(character.hasOwnProperty("Skin") ? character.Skin : -1);
        var textureXML:XML = baseXML;
        if (skinId != -1) {
            var skinXML:XML = ObjectLibrary.typeToXML_[skinId];
            if (skinXML != null) {
                textureXML = skinXML;
            }
        }
        var animatedChar:AnimatedChar = AnimatedCharLibrary.getAnimatedChar(String(textureXML.AnimatedTexture.File), int(textureXML.AnimatedTexture.Index));
        var frame:MaskedImage = animatedChar.imageFromDir(AnimatedChar.RIGHT, AnimatedChar.STAND, 0);
        var portrait:BitmapData = TextureRedrawer.resize(frame.image_, frame.mask_, 250, true, int(character.Tex1), int(character.Tex2));
        portrait = TextureRedrawer.outlineGlow(portrait, 0, 0);
        var portraitBitmap:Bitmap = new Bitmap(portrait);
        portraitBitmap.x = ((badge.width / 2) - (portraitBitmap.width / 2));
        portraitBitmap.y = ((badge.height / 2) - (portraitBitmap.height / 2));
        badge.addChild(portraitBitmap);
        badge.y = 20;
        badge.x = ((800 / 2) - (badge.width / 2));
        this.contentContainer.addChild(badge);
    }

    public function setStats(totalFame:int, stats:XML):void {
        this.statsPanel = new StatsPanel(new Rectangle(0, 0, 784, 150), stats);
        this.statsPanel.x = 8;
        this.statsPanel.y = 316;
        this.contentContainer.addChild(this.statsPanel);
        var fameIcon:BitmapData = FameUtil.getFameIcon();
        fameIcon = BitmapUtil._Y_d(fameIcon, 6, 6, (fameIcon.width - 12), (fameIcon.height - 12));
        this.totalFameRow = new StatRow(24, 0xCCCCCC, 0xFFC800, "Total Fame Earned", null, totalFame, "", "", new Bitmap(fameIcon));
        this.totalFameRow.x = 10;
        this.totalFameRow.y = 470;
        this.contentContainer.addChild(this.totalFameRow);
        this.dataReady = true;
        if (this.skipAnimation || this.fadeComplete) {
            this.showContinue();
        }
    }

    private function onFadeComplete(tween:GTween):void {
        removeChild(this.fadeContainer);
        this.fadeComplete = true;
        if (this.dataReady) {
            this.showContinue();
        }
    }

    private function showContinue():void {
        this.continueButton.x = ((800 / 2) - (this.continueButton.width / 2));
        this.continueButton.y = 524;
        this.contentContainer.addChild(this.continueButton);
        if (this.skipAnimation) {
            this.statsPanel.skipAnimation();
        } else {
            this.statsPanel.startAnimation();
        }
    }

}
}
