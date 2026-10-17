// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.ui.guild.GuildBoardViewer

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

import com.company.util.XmlUtil;

import flash.events.Event;
import flash.events.MouseEvent;


internal class GuildBoardViewer extends Sprite {

    public static const WIDTH:int = 400;
    public static const HEIGHT:int = 400;
    private static const URL_PATTERN:RegExp = /((https?|ftp):((\/\/)|(\\\\))+[\w\d:#@%\/;$()~_?\+-=\\\.&]*)/g;

    public function GuildBoardViewer(_arg1:String, _arg2:Boolean) {
        this.backgroundFill = new GraphicsSolidFill(0x2a2a2a, 1);
        this.outlineFill_ = new GraphicsSolidFill(0xFFFFFF, 1);
        this.outlineStroke = new GraphicsStroke(2, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.ROUND, 3, this.outlineFill_);
        this.path_ = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
        this.graphicsData_ = new <IGraphicsData>[outlineStroke, backgroundFill, path_, GraphicHelper.END_FILL, GraphicHelper.NO_STROKE];
        super();
        this.text_ = _arg1;
        this.textContainer = new Sprite();
        var _local3:Shape = new Shape();
        var _local4:Graphics = _local3.graphics;
        _local4.beginFill(0);
        _local4.drawRect(0, 0, WIDTH, HEIGHT);
        _local4.endFill();
        this.textContainer.addChild(_local3);
        this.textContainer.mask = _local3;
        addChild(this.textContainer);
        var _local5:String = XmlUtil.escapeXml(_arg1);
        _local5.replace(URL_PATTERN, ('<font color="#7777EE"><a href="$1" target="_blank">' + "$1</a></font>"));
        _local5 = _arg1;
        this.textField = new SimpleText(16, 0xB3B3B3, false, WIDTH, 0, "Myriad Pro");
        this.textField.border = false;
        this.textField.mouseEnabled = true;
        this.textField.multiline = true;
        this.textField.wordWrap = true;
        this.textField.htmlText = _local5;
        this.textField._08S_();
        this.textContainer.addChild(this.textField);
        var _local6 = (this.textField.height > 400);
        if (_local6) {
            this.scrollBar = new _0K_B_(16, (HEIGHT - 4));
            this.scrollBar.x = (WIDTH + 6);
            this.scrollBar.y = 0;
            this.scrollBar._fA_(400, this.textField.height);
            this.scrollBar.addEventListener(Event.CHANGE, this.onScroll);
            addChild(this.scrollBar);
        }
        this.w_ = (WIDTH + ((_local6) ? 26 : 0));
        this.editButton = new _7f(14, "Edit", 120);
        this.editButton.x = 4;
        this.editButton.y = (HEIGHT + 4);
        this.editButton.addEventListener(MouseEvent.CLICK, this.onEdit);
        addChild(this.editButton);
        this.editButton.visible = _arg2;
        this.closeButton = new _7f(14, "Close", 120);
        this.closeButton.x = ((this.w_ - this.closeButton.width) - 4);
        this.closeButton.y = (HEIGHT + 4);
        this.closeButton.addEventListener(MouseEvent.CLICK, this.onClose);
        addChild(this.closeButton);
        this.h_ = ((HEIGHT + this.closeButton.height) + 8);
        graphics.clear();
        GraphicHelper.clearPath(this.path_);
        GraphicHelper.drawUI(-6, -6, (this.w_ + 12), (this.h_ + 12), 4, [1, 1, 1, 1], this.path_);
        graphics.drawGraphicsData(this.graphicsData_);
    }
    public var w_:int;
    public var h_:int;
    private var graphicsData_:Vector.<IGraphicsData>;
    private var text_:String;
    private var textField:SimpleText;
    private var textContainer:Sprite;
    private var scrollBar:_0K_B_;
    private var editButton:_7f;
    private var closeButton:_7f;
    private var backgroundFill:GraphicsSolidFill;
    private var outlineFill_:GraphicsSolidFill;
    private var outlineStroke:GraphicsStroke;
    private var path_:GraphicsPath;

    private function onScroll(_arg1:Event):void {
        this.textField.y = (-(this.scrollBar._Q_D_()) * (this.textField.height - 400));
    }

    private function onEdit(_arg1:Event):void {
        dispatchEvent(new Event(Event.CHANGE));
    }

    private function onClose(_arg1:Event):void {
        dispatchEvent(new Event(Event.COMPLETE));
    }

}
}//package client.ui.guild

