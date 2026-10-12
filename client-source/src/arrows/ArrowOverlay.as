package arrows
{
    import com.company.assembleegameclient.map.GameCamera;
    import com.company.assembleegameclient.map.GameMap;
    import com.company.assembleegameclient.objects.Player;
    import com.company.assembleegameclient.objects._ez;

    import flash.display.Sprite;
    import flash.events.Event;

    public class ArrowOverlay extends Sprite
    {
        public var map_:GameMap;
        public var partyArrows_:Vector.<PartyMemberArrow> = null;
        public var questArrow_:QuestArrow;

        public function ArrowOverlay(map:GameMap)
        {
            var arrow:PartyMemberArrow;
            super();
            this.map_ = map;
            this.partyArrows_ = new Vector.<PartyMemberArrow>(_ez._tn, true);
            for (var i:int = 0; i < _ez._tn; i++)
            {
                arrow = new PartyMemberArrow();
                this.partyArrows_[i] = arrow;
                addChild(arrow);
            }
            this.questArrow_ = new QuestArrow(this.map_);
            addChild(this.questArrow_);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        }

        public function draw(camera:GameCamera, time:int):void
        {
            var arrow:PartyMemberArrow;
            var member:Player;
            var j:int;
            var other:PartyMemberArrow;
            var dx:Number;
            var dy:Number;
            if (this.map_.player_ == null)
            {
                return;
            }
            var party:_ez = this.map_.party_;
            for (var i:int = 0; i < _ez._tn; i++)
            {
                arrow = this.partyArrows_[i];
                if (arrow.isMouseOver_)
                {
                    continue;
                }
                if (i >= party._X_e.length)
                {
                    arrow.setGameObject(null);
                    continue;
                }
                member = party._X_e[i];
                if (member._1D_ || member.map_ == null || member._aE_)
                {
                    arrow.setGameObject(null);
                    continue;
                }
                arrow.setGameObject(member);
                for (j = 0; j < i; j++)
                {
                    other = this.partyArrows_[j];
                    dx = arrow.x - other.x;
                    dy = arrow.y - other.y;
                    if ((dx * dx) + (dy * dy) < 64)
                    {
                        if (!other.isMouseOver_)
                        {
                            other.addExtraObject(member);
                        }
                        arrow.setGameObject(null);
                        break;
                    }
                }
                arrow.draw(time, camera);
            }
            if (!this.questArrow_.isMouseOver_)
            {
                this.questArrow_.draw(time, camera);
            }
        }

        private function onRemovedFromStage(event:Event):void
        {
            ScreenArrow.closeOpenMenu();
        }
    }
}
