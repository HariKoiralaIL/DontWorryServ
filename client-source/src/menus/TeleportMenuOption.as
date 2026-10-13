package menus
{
    import com.company.assembleegameclient.objects.Player;
    import com.company.ui.SimpleText;
    import com.company.util.AssetLibrary;

    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.ColorTransform;

    public class TeleportMenuOption extends MenuOption
    {
        private static const COOLDOWN_TRANSFORM:ColorTransform = new ColorTransform(84 / 0xFF, 84 / 0xFF, 84 / 0xFF);

        private var player_:Player;
        private var isMouseOver_:Boolean = false;
        private var cooldownText_:SimpleText;
        private var cooldownTextWidth_:int;

        public function TeleportMenuOption(player:Player)
        {
            super(AssetLibrary._xK_("lofiInterfaceBig", 11), 0xFFFFFF, "Teleport");
            this.player_ = player;
            this.cooldownText_ = new SimpleText(18, 0xFFFFFF, false, 0, 0, "Myriad Pro");
            this.cooldownText_.setBold(true);
            this.cooldownText_.text = "Teleport";
            this.cooldownText_.updateMetrics();
            this.cooldownText_.x = text_.x;
            this.cooldownText_.y = text_.y;
            this.cooldownTextWidth_ = this.cooldownText_.width;
            addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        }

        override protected function onMouseOver(event:MouseEvent):void
        {
            this.isMouseOver_ = true;
        }

        override protected function onMouseOut(event:MouseEvent):void
        {
            this.isMouseOver_ = false;
        }

        private function onAddedToStage(event:Event):void
        {
            addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        }

        private function onRemovedFromStage(event:Event):void
        {
            removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        }

        private function onEnterFrame(event:Event):void
        {
            var cooldown:int = this.player_.msUntilTeleport();
            if (cooldown > 0)
            {
                if (!contains(this.cooldownText_))
                {
                    addChild(this.cooldownText_);
                }
                this.cooldownText_.width = this.cooldownTextWidth_ * (1 - (cooldown / Player.TELEPORT_COOLDOWN_MS));
                setColorTransform(COOLDOWN_TRANSFORM);
            }
            else
            {
                if (contains(this.cooldownText_))
                {
                    removeChild(this.cooldownText_);
                }
                if (this.isMouseOver_)
                {
                    setColorTransform(HOVER_TRANSFORM);
                }
                else
                {
                    setColorTransform(null);
                }
            }
        }
    }
}
