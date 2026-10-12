package client.ui.screens {
import com.company.assembleegameclient.ui._0K_B_;
import com.company.assembleegameclient.util._Z_B_;
import com.company.util.BitmapUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.utils.getTimer;

/**
 * Scrollable, animated list of a dead character's stats (shots, accuracy,
 * kills, dungeons, base fame and bonus fame) shown on the death screen.
 * Dispatches Event.COMPLETE once every row has been revealed.
 */
public class StatsPanel extends Sprite {

    private static const ROW_HEIGHT:int = 28;
    private static const ANIMATION_DURATION_MS:int = 2000;
    private static const ROW_FONT_SIZE:int = 20;
    private static const LABEL_COLOR:uint = 0xB3B3B3;
    private static const STAT_COLOR:uint = 0x57AD62;
    private static const FAME_COLOR:uint = 0xFFC800;

    private var rect_:Rectangle;
    private var mask_:Shape = new Shape();
    private var rowContainer:Sprite = new Sprite();
    private var rows:Vector.<StatRow> = new Vector.<StatRow>();
    private var scrollBar:_0K_B_;
    private var startTime_:int;

    public function StatsPanel(rect:Rectangle, stats:XML) {
        super();
        this.rect_ = rect;
        graphics.lineStyle(1, 0x494949, 2);
        graphics.drawRect((this.rect_.x + 1), (this.rect_.y + 1), (this.rect_.width - 2), (this.rect_.height - 2));
        graphics.lineStyle();
        this.scrollBar = new _0K_B_(16, this.rect_.height);
        this.scrollBar.addEventListener(Event.CHANGE, this.onScroll);
        this.mask_.graphics.beginFill(0xFFFFFF, 1);
        this.mask_.graphics.drawRect(this.rect_.x, this.rect_.y, this.rect_.width, this.rect_.height);
        this.mask_.graphics.endFill();
        addChild(this.mask_);
        mask = this.mask_;
        addChild(this.rowContainer);
        this.addRows(stats);
    }

    /** Reveal all rows immediately, with values already at their final number. */
    public function skipAnimation():void {
        this.startAnimation();
        this.startTime_ = -(int.MAX_VALUE);
        for each (var row:StatRow in this.rows) {
            row.skipAnimation();
        }
    }

    public function startAnimation():void {
        this.startTime_ = getTimer();
        addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function addRows(stats:XML):void {
        this.addRow("Shots", null, stats.Shots, false, STAT_COLOR);
        if (int(stats.Shots) != 0) {
            this.addRow("Accuracy", null, ((100 * Number(stats.ShotsThatDamage)) / Number(stats.Shots)), true, STAT_COLOR, "", "%");
        }
        this.addRow("Tiles Seen", null, stats.TilesUncovered, false, STAT_COLOR);
        this.addRow("Monster Kills", null, stats.MonsterKills, false, STAT_COLOR);
        this.addRow("God Kills", null, stats.GodKills, false, STAT_COLOR);
        this.addRow("Oryx Kills", null, stats.OryxKills, false, STAT_COLOR);
        this.addRow("Quests Completed", null, stats.QuestsCompleted, false, STAT_COLOR);
        var dungeonsCompleted:int = ((((((int(stats.PirateCavesCompleted) + int(stats.UndeadLairsCompleted))
                + int(stats.AbyssOfDemonsCompleted)) + int(stats.SnakePitsCompleted))
                + int(stats.SpiderDensCompleted)) + int(stats.SpriteWorldsCompleted))
                + int(stats.TombsCompleted));
        this.addRow("Dungeons Completed", null, dungeonsCompleted, false, STAT_COLOR);
        this.addRow("Party Member Level Ups", null, stats.LevelUpAssists, false, STAT_COLOR);
        var fameIcon:BitmapData = _Z_B_._qf();
        fameIcon = BitmapUtil._Y_d(fameIcon, 6, 6, (fameIcon.width - 12), (fameIcon.height - 12));
        this.addRow("Base Fame Earned", null, stats.BaseFame, true, FAME_COLOR, "", "", new Bitmap(fameIcon));
        for each (var bonus:XML in stats.Bonus) {
            this.addRow(("Bonus: " + bonus.@id), bonus.@desc, int(bonus), true, FAME_COLOR, "+", "", new Bitmap(fameIcon));
        }
    }

    /** Rows with a zero value are skipped unless `alwaysShow` is set. */
    private function addRow(label:String, tooltipText:String, value:int, alwaysShow:Boolean, valueColor:uint, prefix:String = "", suffix:String = "", icon:DisplayObject = null):void {
        if (value == 0 && !alwaysShow) {
            return;
        }
        this.rows.push(new StatRow(ROW_FONT_SIZE, LABEL_COLOR, valueColor, label, tooltipText, value, prefix, suffix, icon));
    }

    private function showScrollBar():void {
        graphics.clear();
        graphics.lineStyle(1, 0x494949, 2);
        graphics.drawRect((this.rect_.x + 1), (this.rect_.y + 1), (this.rect_.width - 26), (this.rect_.height - 2));
        graphics.lineStyle();
        this.scrollBar.x = (this.rect_.width - 16);
        this.scrollBar._fA_(this.mask_.height, this.rowContainer.height);
        this.scrollBar._0D__(1);
        addChild(this.scrollBar);
    }

    private function onScroll(event:Event):void {
        var scrollPosition:Number = this.scrollBar._Q_D_();
        this.rowContainer.y = ((scrollPosition * ((this.rect_.height - this.rowContainer.height) - 15)) + 5);
    }

    private function onEnterFrame(event:Event):void {
        var finishTime:Number = (this.startTime_ + ((ANIMATION_DURATION_MS * (this.rows.length - 1)) / 2));
        var now:Number = getTimer();
        var visibleRows:int = Math.min(this.rows.length, (((2 * (getTimer() - this.startTime_)) / ANIMATION_DURATION_MS) + 1));
        var index:int = 0;
        while (index < visibleRows) {
            var row:StatRow = this.rows[index];
            row.y = (ROW_HEIGHT * index);
            this.rowContainer.addChild(row);
            index++;
        }
        this.rowContainer.y = ((this.rect_.height - this.rowContainer.height) - 10);
        if (now > (finishTime + 1000)) {
            this.showScrollBar();
            dispatchEvent(new Event(Event.COMPLETE));
            removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        }
    }

}
}
