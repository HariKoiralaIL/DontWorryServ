package picturebrowser {
import client.util.PNGDecoder;

import com.company.events.AddPictureEvent;
import com.company.events.DeletePictureEvent;

import events.GenericDataEvent;

import com.company.assembleegameclient.appengine._0B_u;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.tooltip.TitleDescriptionToolTip;
import com.company.assembleegameclient.ui.tooltip.ToolTip;
import com.company.assembleegameclient.util.TextureRedrawer;
import com.company.assembleegameclient.util._0B_c;
import com.company.assembleegameclient.util._J_H_;
import com.company.assembleegameclient.util._lJ_;
import com.company.rotmg.graphics.DeleteXGraphic;
import com.company.ui.SimpleText;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.net.URLLoaderDataFormat;
import flash.system.System;
import flash.utils.ByteArray;
import flash.utils.getTimer;

import spriteeditor.TextureCategory;

/**
 * A single picture in the picture grid. Downloads its image from the server,
 * previews it according to its category, and shows a tooltip and
 * (for owners/admins) action buttons on mouse over.
 */
public class PictureTile extends Sprite {

    public static const WIDTH:int = 100;
    public static const HEIGHT:int = 100;

    private static const PICTURE_PATH:String = "/picture";
    private static const FONT:String = "Myriad Pro";

    private static const BACKGROUND_COLOR:uint = 0x363636;
    private static const BACKGROUND_HOVER_COLOR:uint = 0x565656;

    private static const NAME_FONT_SIZE:int = 12;
    private static const NAME_COLOR:uint = 0xB3B3B3;
    private static const NAME_WIDTH:int = 98;
    private static const NAME_HEIGHT:int = 20;
    private static const NAME_Y:int = 80;

    private static const BUTTON_MARGIN:int = 5;
    private static const BUTTON_GAP:int = 10;

    private static const IMAGE_SIZE:int = 100;
    private static const IMAGE_Y_ADJUST:int = 10;

    /** Character sheets are 7 frames wide; sheets 16px wide or less are a single sprite. */
    private static const CHARACTER_SHEET_FRAMES:int = 7;
    private static const SINGLE_SPRITE_MAX_WIDTH:int = 16;
    private static const ANIMATION_PERIOD_MS:int = 400;

    private static const TOOLTIP_BACKGROUND:uint = 0x2A2A2A;
    private static const TOOLTIP_BORDER:uint = 0x9B9B9B;
    private static const TOOLTIP_WIDTH:int = 200;

    private static var addIconClass:Class = AddToSheetIcon;
    private static var copyIdIconClass:Class = CopyIdIcon;
    private static var toolTip:ToolTip = null;

    public var id:int;
    public var pictureName:String;
    public var dataType:int = 0;
    public var tags:String;
    public var isMine:Boolean;
    public var isAdmin:Boolean;
    public var bitmapData:BitmapData = null;
    public var animatedChar:_lJ_ = null;
    protected var bitmap:Bitmap;
    protected var nameText:SimpleText;
    protected var addToSheetButton:Sprite;
    protected var copyIdButton:Sprite;
    protected var deleteButton:DeleteXGraphic;

    public function PictureTile(xml:XML, isAdmin:Boolean) {
        this.id = int(xml.@id);
        this.pictureName = xml.PicName;
        this.dataType = int(xml.DataType);
        this.tags = xml.Tags;
        this.isMine = xml.hasOwnProperty("Mine");
        this.isAdmin = isAdmin;

        this.bitmap = new Bitmap();
        addChild(this.bitmap);

        this.nameText = new SimpleText(NAME_FONT_SIZE, NAME_COLOR, false, NAME_WIDTH, NAME_HEIGHT, FONT);
        this.nameText.htmlText = ('<p align="center">' + this.pictureName) + "</p>";
        this.nameText.wordWrap = true;
        this.nameText.multiline = true;
        this.nameText.updateMetrics();
        this.nameText.filters = [new DropShadowFilter(0, 0, 0)];
        this.nameText.x = (WIDTH / 2) - (this.nameText.width / 2);
        this.nameText.y = NAME_Y;
        addChild(this.nameText);

        this.addToSheetButton = new Sprite();
        this.addToSheetButton.addChild(new addIconClass());
        this.addToSheetButton.x = BUTTON_MARGIN;
        this.addToSheetButton.y = BUTTON_MARGIN;
        this.addToSheetButton.visible = false;
        this.addToSheetButton.addEventListener(MouseEvent.CLICK, this.onAddToSheetClick);
        addChild(this.addToSheetButton);

        this.copyIdButton = new Sprite();
        this.copyIdButton.addChild(new copyIdIconClass());
        this.copyIdButton.x = BUTTON_GAP + this.addToSheetButton.width;
        this.copyIdButton.y = BUTTON_MARGIN;
        this.copyIdButton.visible = false;
        this.copyIdButton.addEventListener(MouseEvent.CLICK, this.onCopyIdClick);
        addChild(this.copyIdButton);

        this.deleteButton = new DeleteXGraphic();
        this.deleteButton.x = (WIDTH - this.deleteButton.width) - BUTTON_MARGIN;
        this.deleteButton.y = BUTTON_MARGIN;
        this.deleteButton.visible = false;
        this.deleteButton.addEventListener(MouseEvent.CLICK, this.onDeleteClick);
        addChild(this.deleteButton);

        this.setBackground(BACKGROUND_COLOR);
        addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        this.sendRequest();
    }

    private function sendRequest():void {
        var request:_0B_u = new _0B_u(Parameters._fK_(), PICTURE_PATH, false);
        request._R_z(URLLoaderDataFormat.BINARY);
        request.addEventListener(GenericDataEvent.GENERIC_DATA, this.onURLLoadComplete);
        request.sendRequest("get", {"id": this.id.toString()});
    }

    private function startCharacterAnimation():void {
        var frameWidth:int = (this.bitmapData.width / CHARACTER_SHEET_FRAMES);
        var frameHeight:int = this.bitmapData.height;
        this.animatedChar = new _lJ_(new _J_H_(this.bitmapData, null), frameWidth, frameHeight, _lJ_.RIGHT);
        addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        this.updateAnimationFrame();
    }

    private function updateAnimationFrame():void {
        var time:int = getTimer();
        var actionFrame:int = ((time / ANIMATION_PERIOD_MS) % _lJ_._0E_Z_);
        var frameFraction:Number = ((time % ANIMATION_PERIOD_MS) / ANIMATION_PERIOD_MS);
        var frame:_J_H_ = this.animatedChar.imageFromDir(_lJ_.RIGHT, actionFrame, frameFraction);
        this.bitmap.bitmapData = TextureRedrawer.redraw(frame.image_, IMAGE_SIZE, true, 0, 0, true);
        this.centerBitmap();
    }

    private function showTextileOnPlayer():void {
        var player:_lJ_ = _0B_c._J_v("players", 0);
        var frame:_J_H_ = player.imageFromDir(_lJ_.RIGHT, _lJ_._sS_, 0);
        TextureRedrawer._rn = this.bitmapData;
        var image:BitmapData = TextureRedrawer.resize(frame.image_, frame.mask_, IMAGE_SIZE, true, 0xFFFFFFFF, 0);
        image = TextureRedrawer.outlineGlow(image, 0, 0);
        this.bitmap.bitmapData = image;
        this.centerBitmap();
    }

    private function showStaticImage():void {
        this.bitmap.bitmapData = TextureRedrawer.redraw(this.bitmapData, IMAGE_SIZE, true, 0, 0, false);
        this.centerBitmap();
    }

    private function centerBitmap():void {
        this.bitmap.x = (WIDTH / 2) - (this.bitmap.width / 2);
        this.bitmap.y = ((HEIGHT / 2) - (this.bitmap.height / 2)) - IMAGE_Y_ADJUST;
    }

    private function showToolTip():void {
        this.removeToolTip();
        if (this.bitmapData == null) {
            return;
        }
        var tagList:String = this.tags.split(",").join(", ");
        var description:String = "Type: " + TextureCategory.CATEGORIES[this.dataType].name_ + "\n"
                + "Size: " + this.bitmapData.width + " x " + this.bitmapData.height + "\n"
                + "Tags: " + tagList + "\n"
                + "Id: " + this.id;
        toolTip = new TitleDescriptionToolTip(TOOLTIP_BACKGROUND, TOOLTIP_BORDER, this.pictureName,
                description, TOOLTIP_WIDTH);
        stage.addChild(toolTip);
    }

    private function removeToolTip():void {
        if (toolTip != null && toolTip.parent != null) {
            toolTip.parent.removeChild(toolTip);
        }
        toolTip = null;
    }

    private function setBackground(color:uint):void {
        graphics.clear();
        graphics.beginFill(color, 1);
        graphics.drawRect(1, 1, (WIDTH - 2), (HEIGHT - 2));
        graphics.endFill();
    }

    private function onDeleteClick(event:MouseEvent):void {
        event.stopImmediatePropagation();
        dispatchEvent(new DeletePictureEvent(this.pictureName, this.id));
    }

    private function onAddToSheetClick(event:MouseEvent):void {
        event.stopImmediatePropagation();
        dispatchEvent(new AddPictureEvent(this.bitmapData));
    }

    private function onCopyIdClick(event:MouseEvent):void {
        event.stopImmediatePropagation();
        System.setClipboard(String(this.id));
    }

    private function onURLLoadComplete(event:GenericDataEvent):void {
        this.bitmapData = PNGDecoder.decodeImage((event.data as ByteArray));
        switch (this.dataType) {
            case TextureCategory.CHARACTER:
                if (this.bitmapData.width > SINGLE_SPRITE_MAX_WIDTH) {
                    this.startCharacterAnimation();
                } else {
                    this.showStaticImage();
                }
                break;
            case TextureCategory.TEXTILE:
                this.showTextileOnPlayer();
                break;
            default:
                this.showStaticImage();
        }
    }

    private function onEnterFrame(event:Event):void {
        this.updateAnimationFrame();
    }

    private function onMouseOver(event:MouseEvent):void {
        this.setBackground(BACKGROUND_HOVER_COLOR);
        this.showToolTip();
        if (this.isMine || this.isAdmin) {
            this.deleteButton.visible = true;
        }
        if (this.isAdmin) {
            this.addToSheetButton.visible = true;
            this.copyIdButton.visible = true;
        }
    }

    private function onMouseOut(event:MouseEvent):void {
        this.setBackground(BACKGROUND_COLOR);
        this.removeToolTip();
        this.deleteButton.visible = false;
        this.addToSheetButton.visible = false;
        this.copyIdButton.visible = false;
    }
}
}
