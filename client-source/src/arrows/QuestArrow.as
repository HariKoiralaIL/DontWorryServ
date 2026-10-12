package arrows
{
    import com.company.assembleegameclient.map.Quest;
    import com.company.assembleegameclient.map.GameCamera;
    import com.company.assembleegameclient.map.GameMap;
    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.ui.tooltip.PortraitToolTip;
    import com.company.assembleegameclient.ui.tooltip.QuestToolTip;
    import com.company.assembleegameclient.ui.tooltip.ToolTip;

    import flash.events.MouseEvent;
    import flash.utils.getTimer;

    public class QuestArrow extends ScreenArrow
    {
        public var map_:GameMap;

        public function QuestArrow(map:GameMap)
        {
            super(0xF98441, 0xC52222, true);
            this.map_ = map;
        }

        override public function draw(time:int, camera:GameCamera):void
        {
            var hadQuestToolTip:Boolean;
            var wantsQuestToolTip:Boolean;
            var questObject:GameObject = this.map_.quest_.getObject(time);
            if (questObject != go_)
            {
                setGameObject(questObject);
                setToolTip(this.getToolTip(questObject, time));
            }
            else if (go_ != null)
            {
                hadQuestToolTip = toolTip_ is QuestToolTip;
                wantsQuestToolTip = this.shouldShowQuestToolTip(time);
                if (hadQuestToolTip != wantsQuestToolTip)
                {
                    setToolTip(this.getToolTip(questObject, time));
                }
            }
            super.draw(time, camera);
        }

        public function refreshToolTip():void
        {
            setToolTip(this.getToolTip(go_, getTimer()));
        }

        override protected function onMouseOver(event:MouseEvent):void
        {
            super.onMouseOver(event);
            this.refreshToolTip();
        }

        override protected function onMouseOut(event:MouseEvent):void
        {
            super.onMouseOut(event);
            this.refreshToolTip();
        }

        private function getToolTip(obj:GameObject, time:int):ToolTip
        {
            if (obj == null || obj.texture_ == null)
            {
                return null;
            }
            if (this.shouldShowQuestToolTip(time))
            {
                return new QuestToolTip(go_);
            }
            if (Parameters.data_.showQuestPortraits)
            {
                return new PortraitToolTip(obj);
            }
            return null;
        }

        private function shouldShowQuestToolTip(time:int):Boolean
        {
            var quest:Quest = this.map_.quest_;
            return isMouseOver_ || quest.isNew(time);
        }
    }
}
