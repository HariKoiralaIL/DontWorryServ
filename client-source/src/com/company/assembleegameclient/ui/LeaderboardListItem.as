package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.assembleegameclient.util.AnimatedChar;
import com.company.assembleegameclient.util.AnimatedCharLibrary;
import com.company.assembleegameclient.util.MaskedImage;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;
import com.company.util.BitmapUtil;
import com.company.util.ConversionUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

/**
 * One row of a character leaderboard: rank, portrait, name, equipment and fame.
 * Highlights on hover.
 *
 * Formerly: _Q_y
 */
public class LeaderboardListItem extends Sprite {

    public static const WIDTH:int = 756;
    public static const HEIGHT:int = 56;

    private static const NORMAL_COLOR:uint = 0xFFFFFF;
    private static const CURRENT_PLAYER_COLOR:uint = 0xFCC219;
    private static const FIRST_PLACE_COLOR:uint = 0xFDFF8F;

    public var accountId_:int;
    public var charId_:int;

    private var rankText_:SimpleText;
    private var bitmap_:Bitmap;
    private var nameText_:SimpleText;
    private var inventory_:Inventory;
    private var fameText_:SimpleText;
    private var fameIcon_:Bitmap;
    private var over_:Boolean = false;
    private var equipment_:Vector.<int>;

    /**
     * @param isCurrentPlayer highlights the row as the viewer's own character
     * @param rank            1-based rank, or -1 when unranked
     * @param charXml         character data (account / char ids, name, texture, equipment, fame)
     */
    public function LeaderboardListItem(isCurrentPlayer:Boolean, rank:int, charXml:XML) {
        super();
        this.accountId_ = charXml.@accountId;
        this.charId_ = charXml.@charId;
        var textColor:uint = NORMAL_COLOR;
        if (isCurrentPlayer) {
            textColor = CURRENT_PLAYER_COLOR;
        } else if (rank == 1) {
            textColor = FIRST_PLACE_COLOR;
        }
        this.rankText_ = new SimpleText(22, textColor, false, 0, 0, "Myriad Pro");
        this.rankText_.setBold(rank != -1);
        this.rankText_.text = (rank == -1) ? "---" : (rank.toString() + ".");
        this.rankText_._08S_();
        this.rankText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.rankText_.x = 82 - this.rankText_.width;
        this.rankText_.y = (HEIGHT / 2) - (this.rankText_.height / 2);
        addChild(this.rankText_);

        var objectXml:XML = ObjectLibrary.typeToXML_[int(charXml.ObjectType)];
        var tex1:int = charXml.hasOwnProperty("Tex1") ? charXml.Tex1 : 0;
        var tex2:int = charXml.hasOwnProperty("Tex2") ? charXml.Tex2 : 0;
        var skinType:int = charXml.hasOwnProperty("Skin") ? charXml.Skin : -1;
        var textureXml:XML = objectXml;
        if (skinType != -1) {
            var skinXml:XML = ObjectLibrary.typeToXML_[skinType];
            if (skinXml != null) {
                textureXml = skinXml;
            }
        }
        var animatedChar:AnimatedChar = AnimatedCharLibrary.getAnimatedChar(String(textureXml.AnimatedTexture.File), int(textureXml.AnimatedTexture.Index));
        var maskedImage:MaskedImage = animatedChar.imageFromDir(AnimatedChar.RIGHT, AnimatedChar.STAND, 0);
        var portrait:BitmapData = TextureRedrawer.resize(maskedImage.image_, maskedImage.mask_, 100, false, tex1, tex2);
        portrait = TextureRedrawer.outlineGlow(portrait, 0, 0);
        portrait = BitmapUtil.crop(portrait, 6, 6, portrait.width - 12, portrait.height - 6);
        this.bitmap_ = new Bitmap(portrait);
        this.bitmap_.x = 104;
        this.bitmap_.y = ((HEIGHT / 2) - (this.bitmap_.height / 2)) - 2;
        addChild(this.bitmap_);

        this.nameText_ = new SimpleText(22, textColor, false, 0, 0, "Myriad Pro");
        this.nameText_.setBold(true);
        this.nameText_.text = charXml.Name;
        this.nameText_._08S_();
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.nameText_.x = 170;
        this.nameText_.y = (HEIGHT / 2) - (this.nameText_.height / 2);
        addChild(this.nameText_);

        this.equipment_ = ConversionUtil.toIntVector(charXml.Equipment);
        this.equipment_.length = 4;
        var slotTypes:Vector.<int> = ConversionUtil.toIntVector(objectXml.SlotTypes);
        slotTypes.length = 4;
        this.inventory_ = new Inventory(null, null, "Inventory", slotTypes, 4, false);
        this.inventory_.x = 400;
        this.inventory_.y = (HEIGHT / 2) - (Slot.HEIGHT / 2);
        addChild(this.inventory_);

        this.fameText_ = new SimpleText(22, textColor, false, 0, 0, "Myriad Pro");
        this.fameText_.setBold(true);
        this.fameText_.text = charXml.TotalFame;
        this.fameText_._08S_();
        this.fameText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.fameText_.x = 660 - this.fameText_.width;
        this.fameText_.y = (HEIGHT / 2) - (this.fameText_.height / 2);
        addChild(this.fameText_);
        var fameImage:BitmapData = AssetLibrary.getImageFromSet("lofiObj3", 224);
        this.fameIcon_ = new Bitmap(TextureRedrawer.redraw(fameImage, 40, true, 0, 0));
        this.fameIcon_.x = 652;
        this.fameIcon_.y = (HEIGHT / 2) - (this.fameIcon_.height / 2);
        addChild(this.fameIcon_);

        this.draw();
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
    }

    private function draw():void {
        graphics.clear();
        graphics.beginFill(0, this.over_ ? 0.4 : 0.001);
        graphics.drawRect(0, 0, WIDTH, HEIGHT);
        graphics.endFill();
    }

    private function onAddedToStage(event:Event):void {
        this.inventory_.draw(this.equipment_);
    }

    private function onMouseOver(event:MouseEvent):void {
        this.over_ = true;
        this.draw();
    }

    private function onRollOut(event:MouseEvent):void {
        this.over_ = false;
        this.draw();
    }
}
}
