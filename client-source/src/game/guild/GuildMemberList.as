package game.guild {
    import account.Account;

    import com.company.assembleegameclient.appengine.AppEngineClient;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.ui.Scrollbar;
    import com.company.assembleegameclient.util.GuildUtil;
    import com.company.ui.SimpleText;
    import com.company.util.PropertyUtil;

    import events.GenericDataEvent;
    import events.TextErrorEvent;

    import flash.display.Bitmap;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.filters.DropShadowFilter;

    /** Loads and shows the guild roster from the /guild endpoint. */
    public class GuildMemberList extends Sprite {

        private static const FONT:String = "Myriad Pro";
        private static const TEXT_COLOR:uint = 0xB3B3B3;
        private static const STAGE_WIDTH:int = 800;
        private static const STAGE_HEIGHT:int = 600;
        private static const HEADER_HEIGHT:int = 32;
        private static const DIVIDER_Y:int = 100;
        private static const VIEW_HEIGHT:int = 400;

        private var count_:int;
        private var offset_:int;
        private var playerName_:String;
        private var playerRank_:int;
        private var request_:AppEngineClient;
        private var loadingText_:SimpleText;
        private var titleText_:SimpleText;
        private var fameText_:SimpleText;
        private var fameIcon_:Bitmap;
        private var divider_:Shape;
        private var viewport_:Sprite;
        private var list_:Sprite;
        private var openSlotsText_:SimpleText;
        private var scrollBar_:Scrollbar;

        public function GuildMemberList(count:int, offset:int, playerName:String = "", playerRank:int = 0) {
            super();
            this.count_ = count;
            this.offset_ = offset;
            this.playerName_ = playerName;
            this.playerRank_ = playerRank;

            this.loadingText_ = new SimpleText(22, TEXT_COLOR, false, 0, 0, FONT);
            this.loadingText_.setBold(true);
            this.loadingText_.text = "Loading...";
            this.loadingText_._08S_();
            this.loadingText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
            this.loadingText_.x = ((STAGE_WIDTH / 2) - (this.loadingText_.width / 2));
            this.loadingText_.y = ((STAGE_HEIGHT / 2) - (this.loadingText_.height / 2));
            addChild(this.loadingText_);

            this.request_ = new AppEngineClient(Parameters.serverAddress(), "/guild", true, 2);
            var params:Object = {
                "num": count,
                "offset": offset
            };
            PropertyUtil.copyProperties(params, Account.getInstance().credentials());
            this.request_.addEventListener(GenericDataEvent.GENERIC_DATA, this.onMembersLoaded);
            this.request_.addEventListener(TextErrorEvent.TEXT_ERROR, this.onLoadError);
            this.request_.sendRequest("listMembers", params);
        }

        private function build(xml:XML):void {
            removeChild(this.loadingText_);

            this.titleText_ = new SimpleText(32, TEXT_COLOR, false, 0, 0, FONT);
            this.titleText_.setBold(true);
            this.titleText_.text = String(xml.@name);
            this.titleText_._08S_();
            this.titleText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
            this.titleText_.y = 24;
            this.titleText_.x = ((STAGE_WIDTH / 2) - (this.titleText_.width / 2));
            addChild(this.titleText_);

            this.fameText_ = new SimpleText(22, 0xFFFFFF, false, 0, 0, FONT);
            this.fameText_.text = String(xml.CurrentFame);
            this.fameText_._08S_();
            this.fameText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
            this.fameText_.x = (0x0300 - this.fameText_.width);
            this.fameText_.y = ((HEADER_HEIGHT / 2) - (this.fameText_.height / 2));
            addChild(this.fameText_);

            this.fameIcon_ = new Bitmap(GuildUtil.getGuildFameIcon(40));
            this.fameIcon_.x = 760;
            this.fameIcon_.y = ((HEADER_HEIGHT / 2) - (this.fameIcon_.height / 2));
            addChild(this.fameIcon_);

            this.divider_ = new Shape();
            var g:Graphics = this.divider_.graphics;
            g.clear();
            g.lineStyle(2, 0x545454);
            g.moveTo(0, DIVIDER_Y);
            g.lineTo(STAGE_WIDTH, DIVIDER_Y);
            g.lineStyle();
            addChild(this.divider_);

            this.viewport_ = new Sprite();
            this.viewport_.x = 10;
            this.viewport_.y = 110;
            var maskShape:Shape = new Shape();
            g = maskShape.graphics;
            g.beginFill(0);
            g.drawRect(0, 0, GuildMemberRow.WIDTH, 430);
            g.endFill();
            this.viewport_.addChild(maskShape);
            this.viewport_.mask = maskShape;
            addChild(this.viewport_);

            this.list_ = new Sprite();
            var rowCount:int = 0;
            for each (var member:XML in xml.Member) {
                var name:String = String(member.Name);
                var row:GuildMemberRow = new GuildMemberRow(
                    ((this.offset_ + rowCount) + 1), name, int(member.Rank), int(member.Fame),
                    (this.playerName_ == name), this.playerRank_);
                row.y = (rowCount * GuildMemberRow.HEIGHT);
                this.list_.addChild(row);
                rowCount++;
            }

            var openSlots:int = (GuildUtil.MAX_RANK - (this.offset_ + rowCount));
            this.openSlotsText_ = new SimpleText(22, TEXT_COLOR, false, 0, 0, FONT);
            this.openSlotsText_.text = (openSlots + " open slots");
            this.openSlotsText_._08S_();
            this.openSlotsText_.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
            this.openSlotsText_.x = ((GuildMemberRow.WIDTH / 2) - (this.openSlotsText_.width / 2));
            this.openSlotsText_.y = (rowCount * GuildMemberRow.HEIGHT);
            this.list_.addChild(this.openSlotsText_);
            this.viewport_.addChild(this.list_);

            if (this.list_.height > VIEW_HEIGHT) {
                this.scrollBar_ = new Scrollbar(16, VIEW_HEIGHT);
                this.scrollBar_.x = ((STAGE_WIDTH - this.scrollBar_.width) - 4);
                this.scrollBar_.y = 104;
                this.scrollBar_.setIndicatorSize(VIEW_HEIGHT, this.list_.height);
                this.scrollBar_.addEventListener(Event.CHANGE, this.onScroll);
                addChild(this.scrollBar_);
            }
        }

        private function onMembersLoaded(e:GenericDataEvent):void {
            this.build(XML(e.data));
        }

        private function onLoadError(e:TextErrorEvent):void {
        }

        private function onScroll(e:Event):void {
            this.list_.y = (-(this.scrollBar_.getPosition()) * (this.list_.height - VIEW_HEIGHT));
        }
    }
}
