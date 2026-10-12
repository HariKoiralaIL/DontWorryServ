package spriteeditor {
import client.ui.screens.BaseScreen;

import editorcommands.CommandQueue;

import spriteeditor.BitmapEditor;

import preview.PreviewBase;

import picturebrowser.LoadPictureDialog;

import spriteeditor.PixelEvent;

import editorcommands.CommandEvent;

import flash.events.Event;

import com.company.events.LoadCompleteEvent;

import com.company.util.IntPoint;

import spriteeditor.PixelGrid;
import spriteeditor.AnimatedSpriteEditor;
import spriteeditor.SetPixelsEvent;

import preview.TexturePreview;
import preview.AnimationPreview;
import preview.PlayerTexturePreview;

import editorcommands.CommandList;

import spriteeditor.PixelChange;

import flash.display.BitmapData;

import texturesave.SaveTextureDialog;


/**
 * Main sprite editor screen: toolbar, color picker, pixel canvas and live preview.
 * The editing mode (objects / characters / textiles) decides which size dropdown,
 * canvas and preview classes are used.
 */
public class SpriteEditorScreen extends BaseScreen {

    private static const MODE_DROPDOWN_X:int = 240;
    private static const DROPDOWN_Y:int = 32;
    private static const SIZE_DROPDOWN_X:int = (MODE_DROPDOWN_X + 190);

    private static const CANVAS_X:int = 110;
    private static const CANVAS_Y:int = 100;
    private static const CANVAS_SIZE:int = 360;

    private static const PREVIEW_X:int = 485;
    private static const PREVIEW_Y:int = 100;
    private static const PREVIEW_WIDTH:int = 300;
    private static const PREVIEW_HEIGHT:int = 360;

    private var toolbar_:EditorToolbar;
    private var history_:CommandQueue;
    private var colorPicker_:ColorPicker;
    private var modeDropdown_:ModeDropdown;
    private var sizeDropdown_:SizeDropdown;
    private var canvas_:BitmapEditor;
    private var preview_:PreviewBase;
    private var loader_:LoadPictureDialog;
    private var name_:String = "";
    private var type_:int = 0;
    private var extraText_:String = "";
    private var lastTempPixelEvent_:PixelEvent = null;

    public function SpriteEditorScreen() {
        addChild(new _charscreen());
        super(null);
        this.toolbar_ = new EditorToolbar();
        this.toolbar_.x = 15;
        this.toolbar_.y = 40;
        this.toolbar_.addEventListener(CommandEvent.UNDO_COMMAND_EVENT, this.onUndo);
        this.toolbar_.addEventListener(CommandEvent.REDO_COMMAND_EVENT, this.onRedo);
        this.toolbar_.addEventListener(CommandEvent.CLEAR_COMMAND_EVENT, this.onClear);
        this.toolbar_.addEventListener(CommandEvent.LOAD_COMMAND_EVENT, this.onLoad);
        this.toolbar_.addEventListener(CommandEvent.SAVE_COMMAND_EVENT, this.onSave);
        addChild(this.toolbar_);
        this.history_ = new CommandQueue();
        this.colorPicker_ = new ColorPicker();
        this.colorPicker_.x = 20;
        this.colorPicker_.y = 480;
        this.colorPicker_.addEventListener(Event.CHANGE, this.onColorChange);
        addChild(this.colorPicker_);
        this.modeDropdown_ = new ModeDropdown();
        this.modeDropdown_.x = MODE_DROPDOWN_X;
        this.modeDropdown_.y = DROPDOWN_Y;
        this.modeDropdown_.addEventListener(Event.CHANGE, this.onModeChange);
        addChild(this.modeDropdown_);
        this.loader_ = new LoadPictureDialog();
        this.loader_.addEventListener(LoadCompleteEvent.LOAD_COMPLETE_EVENT, this.onLoadComplete);
        this.createSizeDropdown();
        this.createCanvas();
        this.createPreview();
    }

    /** Forgets the name/type/extra text of the previously loaded texture. */
    protected function resetMetadata():void {
        this.name_ = "";
        this.type_ = 0;
        this.extraText_ = "";
    }

    private function refreshPreview():void {
        this.preview_.setBitmap(this.canvas_.getBitmapData());
    }

    private function createSizeDropdown():void {
        if (this.sizeDropdown_ != null) {
            removeChild(this.sizeDropdown_);
        }
        var mode:String = this.modeDropdown_.getValue();
        switch (mode) {
            case ModeDropdown.OBJECTS:
                this.sizeDropdown_ = new ObjectSizeDropdown();
                break;
            case ModeDropdown.CHARACTERS:
                this.sizeDropdown_ = new CharacterSizeDropdown();
                break;
            case ModeDropdown.TEXTILES:
                this.sizeDropdown_ = new TextileSizeDropdown();
                break;
        }
        this.sizeDropdown_.x = SIZE_DROPDOWN_X;
        this.sizeDropdown_.y = DROPDOWN_Y;
        this.sizeDropdown_.addEventListener(Event.CHANGE, this.onSizeChange);
        addChild(this.sizeDropdown_);
    }

    private function createCanvas():void {
        this.resetMetadata();
        if (this.canvas_ != null) {
            removeChild(this.canvas_);
        }
        var mode:String = this.modeDropdown_.getValue();
        var size:IntPoint = this.sizeDropdown_.getSelectedSize();
        switch (mode) {
            case ModeDropdown.OBJECTS:
                this.canvas_ = new PixelGrid(CANVAS_SIZE, CANVAS_SIZE, size.x_, size.y_, true);
                break;
            case ModeDropdown.CHARACTERS:
                this.canvas_ = new AnimatedSpriteEditor(CANVAS_SIZE, CANVAS_SIZE, size.x_, size.y_);
                break;
            case ModeDropdown.TEXTILES:
                this.canvas_ = new PixelGrid(CANVAS_SIZE, CANVAS_SIZE, size.x_, size.y_, false);
                break;
        }
        this.canvas_.x = CANVAS_X;
        this.canvas_.y = CANVAS_Y;
        this.canvas_.addEventListener(PixelEvent.PIXEL_EVENT, this.onPixelEvent);
        this.canvas_.addEventListener(PixelEvent.TEMP_PIXEL_EVENT, this.onTempPixelEvent);
        this.canvas_.addEventListener(PixelEvent.UNDO_TEMP_EVENT, this.onUndoTempPixel);
        this.canvas_.addEventListener(SetPixelsEvent.SET_PIXELS_EVENT, this.onSetPixels);
        this.canvas_.addEventListener(Event.CHANGE, this.onCanvasChange);
        addChild(this.canvas_);
        if (this.preview_ != null) {
            this.refreshPreview();
        }
        this.history_.clear();
    }

    private function createPreview():void {
        if (this.preview_ != null) {
            removeChild(this.preview_);
        }
        var mode:String = this.modeDropdown_.getValue();
        switch (mode) {
            case ModeDropdown.OBJECTS:
                this.preview_ = new TexturePreview(PREVIEW_WIDTH, PREVIEW_HEIGHT);
                break;
            case ModeDropdown.CHARACTERS:
                this.preview_ = new AnimationPreview(PREVIEW_WIDTH, PREVIEW_HEIGHT);
                break;
            case ModeDropdown.TEXTILES:
                this.preview_ = new PlayerTexturePreview(PREVIEW_WIDTH, PREVIEW_HEIGHT);
                break;
        }
        this.preview_.x = PREVIEW_X;
        this.preview_.y = PREVIEW_Y;
        this.refreshPreview();
        addChild(this.preview_);
    }

    /** Picking a color switches the toolbar back to the draw tool. */
    private function onColorChange(event:Event):void {
        this.toolbar_.selectByValue(EditorToolbar.MODE_DRAW);
    }

    private function onSizeChange(event:Event):void {
        this.createCanvas();
    }

    private function onModeChange(event:Event):void {
        this.createSizeDropdown();
        this.createCanvas();
        this.createPreview();
    }

    private function onCanvasChange(event:Event):void {
        this.refreshPreview();
    }

    /** A committed pixel edit: draw/erase push an undoable command, sample just picks the color. */
    private function onPixelEvent(event:PixelEvent):void {
        var command:CommandList;
        switch (this.toolbar_.getSelectedValue()) {
            case EditorToolbar.MODE_DRAW:
                if (this.colorPicker_.getColor().equals(event.cell_.color_)) {
                    return;
                }
                command = new CommandList();
                command.addCommand(new SetPixelColorCommand(event.cell_, event.cell_.color_, this.colorPicker_.getColor()));
                this.history_.addCommandList(command);
                break;
            case EditorToolbar.MODE_ERASE:
                if (event.cell_.color_ == null) {
                    return;
                }
                command = new CommandList();
                command.addCommand(new SetPixelColorCommand(event.cell_, event.cell_.color_, null));
                this.history_.addCommandList(command);
                break;
            case EditorToolbar.MODE_SAMPLE:
                if (event.cell_.color_ == null) {
                    return;
                }
                this.colorPicker_.setColor(event.cell_.color_);
                break;
        }
        this.refreshPreview();
    }

    /** A provisional (hover/drag) pixel edit that is not added to the undo history. */
    private function onTempPixelEvent(event:PixelEvent):void {
        switch (this.toolbar_.getSelectedValue()) {
            case EditorToolbar.MODE_DRAW:
                if (this.colorPicker_.getColor().equals(event.cell_.color_)) {
                    return;
                }
                event.cell_.setColor(this.colorPicker_.getColor());
                break;
            case EditorToolbar.MODE_ERASE:
                if (event.cell_.color_ == null) {
                    return;
                }
                event.cell_.setColor(null);
                break;
        }
        this.lastTempPixelEvent_ = event;
        this.refreshPreview();
    }

    private function onUndoTempPixel(event:PixelEvent):void {
        if (this.lastTempPixelEvent_ == null) {
            return;
        }
        this.lastTempPixelEvent_.cell_.setColor(this.lastTempPixelEvent_.color_);
        this.refreshPreview();
        this.lastTempPixelEvent_ = null;
    }

    /** Bulk pixel change (e.g. fill): recorded as a single undoable step. */
    private function onSetPixels(event:SetPixelsEvent):void {
        var change:PixelChange;
        var command:CommandList = new CommandList();
        for each (change in event.changes_) {
            command.addCommand(new SetPixelColorCommand(change.cell_, change.cell_.color_, change.color_));
        }
        if (command.isEmpty()) {
            return;
        }
        this.history_.addCommandList(command);
        this.refreshPreview();
    }

    private function onUndo(event:CommandEvent):void {
        this.history_.undo();
        this.refreshPreview();
    }

    private function onRedo(event:CommandEvent):void {
        this.history_.redo();
        this.refreshPreview();
    }

    private function onClear(event:CommandEvent):void {
        this.canvas_.clear();
    }

    private function onLoad(event:CommandEvent):void {
        stage.addChild(this.loader_);
    }

    private function onLoadComplete(event:LoadCompleteEvent):void {
        var bitmapData:BitmapData = event.bitmapData_;
        switch (event.type_) {
            case TextureCategory.CHARACTER:
                this.modeDropdown_.setValue(ModeDropdown.CHARACTERS);
                break;
            case TextureCategory.TEXTILE:
                this.modeDropdown_.setValue(ModeDropdown.TEXTILES);
                break;
            default:
                this.modeDropdown_.setValue(ModeDropdown.OBJECTS);
        }
        var spriteWidth:int = bitmapData.width;
        if (spriteWidth > 16) {
            spriteWidth = (spriteWidth / 7);
        }
        this.sizeDropdown_.selectSize(spriteWidth, bitmapData.height);
        this.name_ = event.name_;
        this.type_ = event.type_;
        this.extraText_ = event.extraText_;
        this.canvas_.loadBitmapData(bitmapData);
    }

    private function onSave(event:CommandEvent):void {
        var allowedCategories:Vector.<int>;
        switch (this.modeDropdown_.getValue()) {
            case ModeDropdown.OBJECTS:
                allowedCategories = new <int>[TextureCategory.INVALID, TextureCategory.CHARACTER, TextureCategory.ITEM, TextureCategory.ENVIRONMENT, TextureCategory.PROJECTILE, TextureCategory.INTERFACE, TextureCategory.MISCELLANEOUS];
                break;
            case ModeDropdown.CHARACTERS:
                allowedCategories = new <int>[TextureCategory.CHARACTER];
                break;
            case ModeDropdown.TEXTILES:
                allowedCategories = new <int>[TextureCategory.TEXTILE];
                break;
        }
        var dialog:SaveTextureDialog = new SaveTextureDialog(this.name_, this.type_, this.extraText_, this.canvas_.getBitmapData(), allowedCategories);
        stage.addChild(dialog);
    }

}
}//package spriteeditor
