package picturebrowser {
import _0L_C_._qO_;

import _tg.AddPictureEvent;
import _tg.DeletePictureEvent;
import _tg.LoadCompleteEvent;

import _zm.DropdownBox;

import events.GenericDataEvent;
import events.TextErrorEvent;

import account.Account;

import com.company.assembleegameclient.appengine._0B_u;
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui.TextButton;
import com.company.assembleegameclient.ui._7f;
import com.company.assembleegameclient.util.Dispatcher;
import com.company.rotmg.graphics.DeleteXGraphic;
import com.company.ui.SimpleText;
import com.company.util.GraphicHelper;
import com.company.util._H_U_;

import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.IGraphicsData;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;
import flash.net.FileReference;
import flash.utils.ByteArray;

import spriteeditor.TextureCategory;

/**
 * Modal "Load" dialog for browsing, searching, loading and deleting
 * pictures stored on the server. Dispatches LoadCompleteEvent when the
 * user picks a picture, and can export chosen pictures as a sprite sheet.
 */
public class LoadPictureDialog extends Sprite {

    private static const WIDTH:int = 640;
    private static const HEIGHT:int = 540;
    private static const STAGE_WIDTH:int = 800;
    private static const STAGE_HEIGHT:int = 600;

    private static const COLUMNS:int = 6;
    private static const ROWS:int = 4;
    private static const PAGE_SIZE:int = ROWS * COLUMNS;

    private static const MARGIN:int = 20;
    private static const FILTER_ROW_Y:int = 40;
    private static const FILTER_WIDTH:int = 120;
    private static const FILTER_HEIGHT:int = 30;
    private static const FILTER_GAP:int = 10;
    private static const FOOTER_Y:int = HEIGHT - 50;
    private static const GRID_X:int = 20;
    private static const GRID_Y:int = 80;

    private static const BOX_CORNER_RADIUS:int = 4;
    private static const BOX_FILL_COLOR:uint = 0x2A2A2A;
    private static const BOX_OUTLINE_COLOR:uint = 0xFFFFFF;
    private static const DIM_ALPHA:Number = 0.8;

    private static const FONT:String = "Myriad Pro";
    private static const TITLE_COLOR:uint = 0x57AD62;
    private static const TITLE_FONT_SIZE:int = 22;
    private static const TITLE_Y:int = 4;
    private static const TITLE_HTML:String = '<p align="center">Load</p>';
    private static const BUTTON_FONT_SIZE:int = 16;
    private static const CLOSE_BUTTON_MARGIN:int = 10;
    private static const COUNT_TEXT_COLOR:uint = 0xB3B3B3;

    private static const PICTURE_PATH:String = "/picture";
    private static const SPRITE_SHEET_FILE_NAME:String = "spritesheet.png";
    private static const ADMIN_GUID:String = "administrator@wildshadow.com";

    private static const OWNER_MINE:String = "Mine";
    private static const OWNER_ALL:String = "All";
    private static const OWNER_WILD_SHADOW:String = "Wild Shadow";

    private static const SEARCH_CATEGORIES:Vector.<int> = new <int>[
        TextureCategory.INVALID,
        TextureCategory.CHARACTER,
        TextureCategory.ITEM,
        TextureCategory.ENVIRONMENT,
        TextureCategory.PROJECTILE,
        TextureCategory.TEXTILE,
        TextureCategory.INTERFACE,
        TextureCategory.MISCELLANEOUS
    ];

    public var eventDispatch:Dispatcher;

    protected var dimmer:Shape;
    protected var box:Sprite;
    protected var boxBackground:Shape;
    protected var titleText:SimpleText = null;
    protected var pictureGrid:PictureGrid = null;
    protected var closeButton:DeleteXGraphic = null;
    protected var searchButton:_7f;
    protected var previousButton:TextButton;
    protected var nextButton:TextButton;
    protected var tagSearchBox:TagSearchBox;
    protected var ownerFilter:DropdownBox;
    protected var categoryFilter:DropdownBox;
    protected var spriteSheet:SpriteSheetBuilder = null;
    protected var bitmapCountText:SimpleText = null;
    protected var downloadButton:TextButton = null;
    protected var downloadPanel:Sprite = null;

    private var graphicsData:Vector.<IGraphicsData>;
    private var outlineFill:GraphicsSolidFill;
    private var outlineStroke:GraphicsStroke;
    private var boxFill:GraphicsSolidFill;
    private var boxPath:GraphicsPath;
    private var isDrawn:Boolean = false;

    public function LoadPictureDialog() {
        this.box = new Sprite();
        this.outlineFill = new GraphicsSolidFill(BOX_OUTLINE_COLOR, 1);
        this.outlineStroke = new GraphicsStroke(1, false, LineScaleMode.NORMAL, CapsStyle.NONE,
                JointStyle.ROUND, 3, this.outlineFill);
        this.boxFill = new GraphicsSolidFill(BOX_FILL_COLOR, 1);
        this.boxPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        this.graphicsData = new <IGraphicsData>[this.outlineStroke, this.boxFill, this.boxPath,
            GraphicHelper.END_FILL, GraphicHelper._H_B_];
        createTitle();
        createCloseButton();
        createSearchButton();
        createPageButtons();
        createFilters();
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
    }

    private function createTitle():void {
        this.titleText = new SimpleText(TITLE_FONT_SIZE, TITLE_COLOR, false, WIDTH, 0, FONT);
        this.titleText.setBold(true);
        this.titleText.htmlText = TITLE_HTML;
        this.titleText.updateMetrics();
        this.titleText.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 1)];
        this.titleText.y = TITLE_Y;
        this.box.addChild(this.titleText);
    }

    private function createCloseButton():void {
        this.closeButton = new DeleteXGraphic();
        this.closeButton.addEventListener(MouseEvent.CLICK, this.onCloseClick);
        this.closeButton.x = (WIDTH - this.closeButton.width) - CLOSE_BUTTON_MARGIN;
        this.closeButton.y = CLOSE_BUTTON_MARGIN;
        this.box.addChild(this.closeButton);
    }

    private function createSearchButton():void {
        this.searchButton = new _7f(BUTTON_FONT_SIZE, "Search", FILTER_WIDTH);
        this.searchButton.x = (WIDTH - this.searchButton.width) - MARGIN;
        this.searchButton.y = FILTER_ROW_Y;
        this.searchButton.addEventListener(MouseEvent.CLICK, this.onSearchClick);
        this.box.addChild(this.searchButton);
    }

    private function createPageButtons():void {
        this.previousButton = new TextButton(BUTTON_FONT_SIZE, true, "Previous");
        this.previousButton.visible = false;
        this.previousButton.x = MARGIN;
        this.previousButton.y = FOOTER_Y;
        this.previousButton.addEventListener(MouseEvent.CLICK, this.onPreviousClick);
        this.box.addChild(this.previousButton);

        this.nextButton = new TextButton(BUTTON_FONT_SIZE, true, "Next");
        this.nextButton.visible = false;
        this.nextButton.x = (WIDTH - this.nextButton.width) - MARGIN;
        this.nextButton.y = FOOTER_Y;
        this.nextButton.addEventListener(MouseEvent.CLICK, this.onNextClick);
        this.box.addChild(this.nextButton);
    }

    private function createFilters():void {
        var categoryId:int;
        this.ownerFilter = new DropdownBox(new <String>[OWNER_MINE, OWNER_ALL, OWNER_WILD_SHADOW],
                FILTER_WIDTH, FILTER_HEIGHT);
        this.ownerFilter.x = MARGIN;
        this.ownerFilter.y = FILTER_ROW_Y;
        this.box.addChild(this.ownerFilter);

        var categoryNames:Vector.<String> = new Vector.<String>();
        for each (categoryId in SEARCH_CATEGORIES) {
            categoryNames.push(TextureCategory.CATEGORIES[categoryId].name_);
        }
        this.categoryFilter = new DropdownBox(categoryNames, FILTER_WIDTH, FILTER_HEIGHT);
        this.categoryFilter.x = (this.ownerFilter.x + this.ownerFilter.width) + FILTER_GAP;
        this.categoryFilter.y = FILTER_ROW_Y;
        this.box.addChild(this.categoryFilter);

        this.tagSearchBox = new TagSearchBox();
        this.tagSearchBox.x = (this.categoryFilter.x + this.categoryFilter.width) + FILTER_GAP;
        this.tagSearchBox.y = FILTER_ROW_Y;
        this.box.addChild(this.tagSearchBox);
    }

    private function search(offset:int):void {
        var request:_0B_u = new _0B_u(Parameters._fK_(), PICTURE_PATH, false);
        request.addEventListener(GenericDataEvent.GENERIC_DATA, this.onSearchResults);
        request.addEventListener(TextErrorEvent.TEXT_ERROR, this.onSearchError);
        var params:Object = {};
        params["myGUID"] = Account.getInstance().guid();
        if (this.ownerFilter.getValue() == OWNER_MINE) {
            params["guid"] = Account.getInstance().guid();
        } else if (this.ownerFilter.getValue() == OWNER_WILD_SHADOW) {
            params["guid"] = ADMIN_GUID;
        }
        var categoryName:String = this.categoryFilter.getValue();
        var categoryIndex:int = TextureCategory.indexOfName(categoryName);
        if (categoryIndex != 0) {
            params["dataType"] = categoryIndex.toString();
        }
        var tags:String = this.tagSearchBox.getTags();
        if (tags != "") {
            params["tags"] = tags;
        }
        if (offset != 0) {
            params["offset"] = offset;
        }
        params["num"] = PAGE_SIZE;
        request.sendRequest("list", params);
        this.searchButton._A_w(false);
    }

    private function updateDownloadPanel():void {
        if (this.downloadPanel == null) {
            this.downloadPanel = new Sprite();
            this.bitmapCountText = new SimpleText(BUTTON_FONT_SIZE, COUNT_TEXT_COLOR, false, 0, 0, FONT);
            this.bitmapCountText.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8, 1)];
            this.bitmapCountText.y = FOOTER_Y;
            this.downloadPanel.addChild(this.bitmapCountText);
            this.downloadButton = new TextButton(BUTTON_FONT_SIZE, true, "download");
            this.downloadButton.y = FOOTER_Y;
            this.downloadButton.addEventListener(MouseEvent.CLICK, this.onDownloadClick);
            this.downloadPanel.addChild(this.downloadButton);
            this.box.addChild(this.downloadPanel);
        }
        this.bitmapCountText.text = (this.spriteSheet.bitmaps.length.toString() + " bitmaps - ");
        this.bitmapCountText.updateMetrics();
        this.bitmapCountText.x = ((WIDTH / 2) - ((this.bitmapCountText.width + this.downloadButton.width) / 2));
        this.downloadButton.x = (this.bitmapCountText.x + this.bitmapCountText.width);
    }

    private function draw():void {
        var boxGraphics:Graphics;
        var dimGraphics:Graphics;
        GraphicHelper._0L_6(this.boxPath);
        GraphicHelper.drawUI(0, 0, WIDTH, HEIGHT, BOX_CORNER_RADIUS, [1, 1, 1, 1], this.boxPath);
        this.boxBackground = new Shape();
        boxGraphics = this.boxBackground.graphics;
        boxGraphics.drawGraphicsData(this.graphicsData);
        this.box.addChildAt(this.boxBackground, 0);
        this.box.x = ((STAGE_WIDTH / 2) - (this.box.width / 2));
        this.box.y = ((STAGE_HEIGHT / 2) - (this.box.height / 2));
        this.box.filters = [new DropShadowFilter(0, 0, 0, 1, 16, 16, 1)];
        addChild(this.box);
        this.dimmer = new Shape();
        dimGraphics = this.dimmer.graphics;
        dimGraphics.clear();
        dimGraphics.beginFill(0, DIM_ALPHA);
        dimGraphics.drawRect(0, 0, STAGE_WIDTH, STAGE_HEIGHT);
        dimGraphics.endFill();
        addChildAt(this.dimmer, 0);
        this.search(0);
    }

    private function onCloseClick(event:MouseEvent):void {
        parent.removeChild(this);
    }

    private function onSearchClick(event:MouseEvent):void {
        this.search(0);
    }

    private function onPreviousClick(event:MouseEvent):void {
        if (this.pictureGrid == null || this.pictureGrid.offset <= 0) {
            return;
        }
        this.search(Math.max(0, (this.pictureGrid.offset - PAGE_SIZE)));
    }

    private function onNextClick(event:MouseEvent):void {
        if (this.pictureGrid == null || this.pictureGrid.pictureCount < PAGE_SIZE) {
            return;
        }
        this.search(this.pictureGrid.offset + PAGE_SIZE);
    }

    private function onSearchResults(event:GenericDataEvent):void {
        if (this.pictureGrid != null && this.box.contains(this.pictureGrid)) {
            this.box.removeChild(this.pictureGrid);
        }
        var xml:XML = new XML(event.data);
        this.pictureGrid = new PictureGrid(xml, COLUMNS, ROWS);
        this.pictureGrid.x = GRID_X;
        this.pictureGrid.y = GRID_Y;
        this.pictureGrid.addEventListener(LoadCompleteEvent.LOAD_COMPLETE_EVENT, this.onPictureSelected);
        this.pictureGrid.addEventListener(DeletePictureEvent.DELETE_PICTURE_EVENT, this.onDeletePictureRequested);
        this.pictureGrid.addEventListener(AddPictureEvent.ADD_PICTURE_EVENT, this.onAddPicture);
        this.box.addChildAt(this.pictureGrid, 1);
        this.searchButton._A_w(true);
        this.nextButton.visible = (this.pictureGrid.pictureCount >= PAGE_SIZE);
        this.previousButton.visible = (this.pictureGrid.offset != 0);
    }

    private function onSearchError(event:TextErrorEvent):void {
    }

    private function onPictureSelected(event:LoadCompleteEvent):void {
        dispatchEvent(event.clone());
        parent.removeChild(this);
    }

    private function onDeletePictureRequested(event:DeletePictureEvent):void {
        var dialog:DeletePictureConfirmDialog = new DeletePictureConfirmDialog(event.name_, event.id_);
        dialog.addEventListener(_qO_.BUTTON1_EVENT, this.onDeleteCancelled);
        dialog.addEventListener(_qO_.BUTTON2_EVENT, this.onDeleteConfirmed);
        addChild(dialog);
    }

    private function onAddPicture(event:AddPictureEvent):void {
        if (this.spriteSheet == null) {
            this.spriteSheet = new SpriteSheetBuilder();
        }
        this.spriteSheet.addBitmap(event.bitmapData_);
        this.updateDownloadPanel();
    }

    private function onDownloadClick(event:MouseEvent):void {
        var pngBytes:ByteArray = this.spriteSheet.encodePng();
        var file:FileReference = new FileReference();
        file.save(pngBytes, SPRITE_SHEET_FILE_NAME);
        this.box.removeChild(this.downloadPanel);
        this.spriteSheet = null;
        this.downloadPanel = null;
        this.bitmapCountText = null;
        this.downloadButton = null;
    }

    private function onDeleteCancelled(event:Event):void {
        var dialog:DeletePictureConfirmDialog = (event.target as DeletePictureConfirmDialog);
        dialog.parent.removeChild(dialog);
    }

    private function onDeleteConfirmed(event:Event):void {
        var dialog:DeletePictureConfirmDialog = (event.target as DeletePictureConfirmDialog);
        dialog.parent.removeChild(dialog);
        this.pictureGrid.visible = false;
        var request:_0B_u = new _0B_u(Parameters._fK_(), PICTURE_PATH, false);
        request.addEventListener(GenericDataEvent.GENERIC_DATA, this.onDeleteComplete);
        var params:Object = {"id": dialog.pictureId.toString()};
        _H_U_._t2(params, Account.getInstance().credentials());
        request.sendRequest("delete", params);
    }

    private function onDeleteComplete(event:GenericDataEvent):void {
        this.search(this.pictureGrid.offset);
    }

    private function onAddedToStage(event:Event):void {
        if (!this.isDrawn) {
            this.draw();
            this.isDrawn = true;
        }
    }
}
}
