package client.ui.screens {
import com.company.assembleegameclient.ui.SelectableLabel;
import com.company.assembleegameclient.ui.Scrollbar;
import com.company.assembleegameclient.ui.LeaderboardListItem;
import com.company.ui.SimpleText;

import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import signals.Signal;
import signals.nativesignals.NativeRelaySignal;

/** "Legends" hall-of-fame screen with Week / Month / All Time tabs. */
public class LegendsScreen extends Sprite {

    private static const TAB_LABELS:Array = ["Week", "Month", "All Time"];
    private static const TIMESPAN_BY_LABEL:Object = {
        "Week": "week",
        "Month": "month",
        "All Time": "all"
    };
    private static const VISIBLE_HEIGHT:int = 400;
    /** Marks "no character row to scroll to". */
    private static const NO_CHAR_Y:Number = Number.MIN_VALUE;

    /** Remembered across instances so the last-used tab stays selected. */
    private static var selectedTab:SelectableLabel;

    public var close:Signal;
    /** Dispatches the timespan ("week" / "month" / "all") whose list should be loaded. */
    public var timespanSelected:Signal;
    /** Dispatches (accountId, charId) of the clicked entry. */
    public var characterSelected:Signal;

    private var cache_:Object = {};
    private var titleText:SimpleText;
    private var loadingText:SimpleText;
    private var listContainer:Sprite;
    private var doneButton:MenuButton;
    private var separator:Shape;
    private var scrollBar:Scrollbar;
    private var tabs:Vector.<SelectableLabel> = new Vector.<SelectableLabel>();
    private var currentList:Sprite;
    private var accountId_:int;
    private var charId_:int;

    public function LegendsScreen() {
        super();
        this.timespanSelected = new Signal();
        this.characterSelected = new Signal();
        addChild(new _charscreen());
        this.titleText = new SimpleText(32, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.titleText.setBold(true);
        this.titleText.text = "Legends";
        this.titleText.updateMetrics();
        this.titleText.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        addChild(this.titleText);
        this.loadingText = new SimpleText(22, 0xB3B3B3, false, 0, 0, "Myriad Pro");
        this.loadingText.setBold(true);
        this.loadingText.text = "Loading...";
        this.loadingText._08S_();
        this.loadingText.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
        this.loadingText.x = ((800 / 2) - (this.loadingText.width / 2));
        this.loadingText.y = ((600 / 2) - (this.loadingText.height / 2));
        this.loadingText.visible = false;
        addChild(this.loadingText);
        this.listContainer = new Sprite();
        this.listContainer.x = 10;
        this.listContainer.y = 110;
        var listMask:Shape = new Shape();
        var maskGraphics:Graphics = listMask.graphics;
        maskGraphics.beginFill(0);
        maskGraphics.drawRect(0, 0, LeaderboardListItem.WIDTH, 430);
        maskGraphics.endFill();
        this.listContainer.addChild(listMask);
        this.listContainer.mask = listMask;
        addChild(this.listContainer);
        this.separator = new Shape();
        addChild(this.separator);
        this.scrollBar = new Scrollbar(16, VISIBLE_HEIGHT);
        this.scrollBar.x = ((800 - this.scrollBar.width) - 4);
        this.scrollBar.y = 104;
        addChild(this.scrollBar);
        var index:int = 0;
        while (index < TAB_LABELS.length) {
            var tab:SelectableLabel = new SelectableLabel(TAB_LABELS[index]);
            tab.x = (20 + (index * 90));
            tab.y = 70;
            tab.addEventListener(MouseEvent.MOUSE_DOWN, this.onTabMouseDown);
            addChild(tab);
            this.tabs.push(tab);
            index++;
        }
        this.doneButton = new MenuButton("done", 36, false);
        addChild(this.doneButton);
        this.setSelected(((selectedTab) || (this.tabs[0])));
        this.close = new NativeRelaySignal(this.doneButton, MouseEvent.CLICK);
    }

    public function initialize():void {
        this.titleText.y = 24;
        this.titleText.x = ((800 / 2) - (this.titleText.width / 2));
        var line:Graphics = this.separator.graphics;
        line.clear();
        line.lineStyle(2, 0xFFFFFF);
        line.moveTo(0, 100);
        line.lineTo(800, 100);
        line.lineStyle();
        this.doneButton.x = ((800 / 2) - (this.doneButton.width / 2));
        this.doneButton.y = 524;
    }

    /** Called with the server's fame list XML for one timespan. */
    public function showFameList(fameList:XML):void {
        this.loadingText.visible = false;
        var list:Sprite = new Sprite();
        var rank:int = 1;
        var charY:Number = NO_CHAR_Y;
        for each (var entry:XML in fameList.FameListElem) {
            var isOwnAccount:Boolean = (int(entry.@accountId) == this.accountId_);
            var row:LeaderboardListItem = new LeaderboardListItem(isOwnAccount, rank, entry);
            row.y = ((rank - 1) * LeaderboardListItem.HEIGHT);
            if (isOwnAccount && (int(entry.@charId) == this.charId_)) {
                charY = (row.y + (LeaderboardListItem.HEIGHT / 2));
            }
            row.addEventListener(MouseEvent.MOUSE_DOWN, this.onRowMouseDown);
            list.addChild(row);
            rank++;
        }
        if (charY == NO_CHAR_Y) {
            for each (var ownEntry:XML in fameList.MyFameListElem) {
                row = new LeaderboardListItem(true, -1, ownEntry);
                row.y = ((rank - 1) * LeaderboardListItem.HEIGHT);
                charY = (row.y + (LeaderboardListItem.HEIGHT / 2));
                row.addEventListener(MouseEvent.MOUSE_DOWN, this.onRowMouseDown);
                list.addChild(row);
                rank++;
            }
        }
        this.cache_[String(fameList.@timespan)] = {
            "listSprite": list,
            "charY": charY
        };
        this.showList(list, charY);
    }

    /** Error callback; currently does nothing (kept for the mediator). */
    public function onLoadError(message:String):void {
    }

    private function setSelected(tab:SelectableLabel):void {
        if (tab == selectedTab) {
            return;
        }
        for each (var other:SelectableLabel in this.tabs) {
            other.setSelected(false);
        }
        selectedTab = tab;
        selectedTab.setSelected(true);
        this.loadTimespan(TIMESPAN_BY_LABEL[selectedTab.label_]);
    }

    private function loadTimespan(timespan:String):void {
        if (this.currentList != null) {
            this.listContainer.removeChild(this.currentList);
            this.currentList = null;
        }
        this.scrollBar.visible = false;
        if (this.cache_.hasOwnProperty(timespan)) {
            var cached:Object = this.cache_[timespan];
            this.showList(cached["listSprite"], cached["charY"]);
        } else {
            this.timespanSelected.dispatch(timespan);
            this.loadingText.visible = true;
        }
    }

    private function showList(list:Sprite, charY:Number):void {
        this.currentList = list;
        this.listContainer.addChild(this.currentList);
        if (this.currentList.height > VISIBLE_HEIGHT) {
            this.scrollBar.visible = true;
            this.scrollBar.setIndicatorSize(VISIBLE_HEIGHT, this.currentList.height);
            this.scrollBar.addEventListener(Event.CHANGE, this.onScroll);
            if (charY != NO_CHAR_Y) {
                this.scrollBar.setPosition(((charY - 200) / (this.currentList.height - VISIBLE_HEIGHT)));
            }
        } else {
            this.scrollBar.visible = false;
        }
    }

    private function onTabMouseDown(event:MouseEvent):void {
        this.setSelected((event.currentTarget as SelectableLabel));
    }

    private function onScroll(event:Event):void {
        this.currentList.y = (-(this.scrollBar.getPosition()) * (this.currentList.height - VISIBLE_HEIGHT));
    }

    private function onRowMouseDown(event:MouseEvent):void {
        if (this.currentList != null) {
            this.listContainer.removeChild(this.currentList);
            this.currentList = null;
        }
        var row:LeaderboardListItem = (event.currentTarget as LeaderboardListItem);
        this.characterSelected.dispatch(row.accountId_, row.charId_);
    }

}
}
