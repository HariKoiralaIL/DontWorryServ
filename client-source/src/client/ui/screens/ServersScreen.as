package client.ui.screens {
import com.company.assembleegameclient.appengine.CharListEvent;
import com.company.assembleegameclient.ui._0K_B_;
import com.company.ui.SimpleText;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import signals.Signal;

/** "Select Server" screen. */
public class ServersScreen extends BaseScreen {

    private static const LIST_TOP:int = 100;
    private static const VISIBLE_HEIGHT:int = 400;

    public var done:Signal;

    private var doneButton:MenuButton;
    private var titleText:SimpleText;
    private var separator:Shape;
    private var listContainer:Sprite;
    private var serverListView:ServerListView;
    private var scrollBar:_0K_B_;

    public function ServersScreen() {
        addChild(new _charscreen());
        this.done = new Signal();
        super(TitleScreen);
    }

    override public function initialize(model:CharListEvent):void {
        super.initialize(model);
        this.titleText = new SimpleText(18, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        this.titleText.setBold(true);
        this.titleText.text = "Select Server";
        this.titleText.updateMetrics();
        this.titleText.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.titleText.x = 18;
        this.titleText.y = 72;
        addChild(this.titleText);
        this.separator = new Shape();
        addChild(this.separator);
        this.listContainer = new Sprite();
        this.listContainer.x = 4;
        this.listContainer.y = LIST_TOP;
        var listMask:Shape = new Shape();
        listMask.graphics.beginFill(0xFFFFFF);
        listMask.graphics.drawRect(0, 0, 776, 430);
        listMask.graphics.endFill();
        this.listContainer.addChild(listMask);
        this.listContainer.mask = listMask;
        addChild(this.listContainer);
        this.serverListView = new ServerListView(model.servers_);
        this.serverListView.y = 8;
        this.serverListView.addEventListener(Event.COMPLETE, this.onDone);
        this.listContainer.addChild(this.serverListView);
        if (this.serverListView.height > VISIBLE_HEIGHT) {
            this.scrollBar = new _0K_B_(16, VISIBLE_HEIGHT);
            this.scrollBar.x = ((800 - this.scrollBar.width) - 4);
            this.scrollBar.y = 104;
            this.scrollBar._fA_(VISIBLE_HEIGHT, this.serverListView.height);
            this.scrollBar.addEventListener(Event.CHANGE, this.onScroll);
            addChild(this.scrollBar);
        }
        this.doneButton = new MenuButton("done", 36, false);
        this.doneButton.addEventListener(MouseEvent.CLICK, this.onDone);
        addChild(this.doneButton);
        var line:Graphics = this.separator.graphics;
        line.clear();
        line.lineStyle(2, 0xEE9327);
        line.moveTo(0, LIST_TOP);
        line.lineTo(800, LIST_TOP);
        line.lineStyle();
        this.doneButton.x = ((800 / 2) - (this.doneButton.width / 2));
        this.doneButton.y = 545;
    }

    private function onScroll(event:Event):void {
        this.serverListView.y = (8 - (this.scrollBar._Q_D_() * (this.serverListView.height - VISIBLE_HEIGHT)));
    }

    private function onDone(event:Event):void {
        this.done.dispatch();
    }

}
}
