// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.ui.guild.GuildBoardEditor

package client.ui.guild {
import flash.display.Sprite;

import flash.display.IGraphicsData;

import com.company.util.GraphicHelper;
import com.company.ui.SimpleText;
import com.company.assembleegameclient.ui._0K_B_;
import com.company.assembleegameclient.ui._7f;

import flash.display.GraphicsSolidFill;
import flash.display.GraphicsStroke;
import flash.display.GraphicsPath;
import flash.display.LineScaleMode;
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.display.Shape;
import flash.display.Graphics;
import flash.events.Event;
import flash.events.MouseEvent;


internal class GuildBoardEditor extends Sprite {

    public static const WIDTH:int = 400;
    public static const HEIGHT:int = 400;

    public function GuildBoardEditor(_arg1:String) {
        this.backgroundFill = new GraphicsSolidFill(0x2a2a2a, 1);
        this.outlineFill_ = new GraphicsSolidFill(0xFFFFFF, 1);
        this.outlineStroke = new GraphicsStroke(2, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, this.outlineFill_);
        this.path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        this.graphicsData_ = new <IGraphicsData>[outlineStroke, backgroundFill, path_, GraphicHelper.END_FILL, GraphicHelper.NO_STROKE];
        super();
        this.text_ = _arg1;
        this.textContainer = new Sprite();
        var _local2:Shape = new Shape();
        var _local3:Graphics = _local2.graphics;
        _local3.beginFill(0);
        _local3.drawRect(0, 0, WIDTH, HEIGHT);
        _local3.endFill();
        this.textContainer.addChild(_local2);
        this.textContainer.mask = _local2;
        addChild(this.textContainer);
        this.textField = new SimpleText(16, 0xB3B3B3, true, WIDTH, HEIGHT, "Myriad Pro");
        this.textField.border = false;
        this.textField.mouseEnabled = true;
        this.textField.multiline = true;
        this.textField.wordWrap = true;
        this.textField.text = _arg1;
        this.textField._08S_();
        this.textField.addEventListener(Event.CHANGE, this.onTextChange);
        this.textField.addEventListener(Event.SCROLL, this.onTextChange);
        this.textContainer.addChild(this.textField);
        this.scrollBar = new _0K_B_(16, (HEIGHT - 4));
        this.scrollBar.x = (WIDTH + 6);
        this.scrollBar.y = 0;
        this.scrollBar._fA_(400, this.textField.height);
        this.scrollBar.addEventListener(Event.CHANGE, this.onScroll);
        addChild(this.scrollBar);
        this.w_ = (WIDTH + 26);
        this.cancelButton = new _7f(14, "Cancel", 120);
        this.cancelButton.x = 4;
        this.cancelButton.y = (HEIGHT + 4);
        this.cancelButton.addEventListener(MouseEvent.CLICK, this.onCancel);
        addChild(this.cancelButton);
        this.saveButton = new _7f(14, "Save", 120);
        this.saveButton.x = ((this.w_ - this.saveButton.width) - 4);
        this.saveButton.y = (HEIGHT + 4);
        this.saveButton.addEventListener(MouseEvent.CLICK, this.onSave);
        addChild(this.saveButton);
        this.h_ = ((HEIGHT + this.saveButton.height) + 8);
        graphics.clear();
        GraphicHelper.clearPath(this.path_);
        GraphicHelper.drawUI(-6, -6, (this.w_ + 12), (this.h_ + 12), 4, [1, 1, 1, 1], this.path_);
        graphics.drawGraphicsData(this.graphicsData_);
        this.scrollBar._fA_(HEIGHT, this.textField.textHeight, false);
    }
    public var w_:int;
    public var h_:int;
    private var graphicsData_:Vector.<IGraphicsData>;
    private var text_:String;
    private var textField:SimpleText;
    private var textContainer:Sprite;
    private var scrollBar:_0K_B_;
    private var cancelButton:_7f;
    private var saveButton:_7f;
    private var backgroundFill:GraphicsSolidFill;
    private var outlineFill_:GraphicsSolidFill;
    private var outlineStroke:GraphicsStroke;
    private var path_:GraphicsPath;

    public function getText():String {
        return (this.textField.text);
    }

    private function onScroll(_arg1:Event):void {
        this.textField.scrollV = (1 + (this.scrollBar._Q_D_() * this.textField.maxScrollV));
    }

    private function onCancel(_arg1:Event):void {
        dispatchEvent(new Event(Event.CANCEL));
    }

    private function onSave(_arg1:Event):void {
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function onTextChange(_arg1:Event):void {
        if (this.scrollBar == null) {
            return;
        }
        this.scrollBar._fA_(HEIGHT, this.textField.textHeight, false);
        if (this.textField.maxScrollV == 1) {
            this.scrollBar._0D__(0);
        } else {
            this.scrollBar._0D__(((this.textField.scrollV - 1) / (this.textField.maxScrollV - 1)));
        }
    }

}
}//package client.ui.guild

