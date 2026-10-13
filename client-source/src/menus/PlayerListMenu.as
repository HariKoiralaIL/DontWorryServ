package menus
{
    import com.company.assembleegameclient.map.GameMap;
    import com.company.assembleegameclient.objects.Player;
    import com.company.assembleegameclient.parameters.Parameters;
    import com.company.assembleegameclient.ui._return;
    import com.company.assembleegameclient.ui.ui_playerslist;

    import flash.events.Event;
    import flash.events.MouseEvent;

    public class PlayerListMenu extends Menu
    {
        public var map_:GameMap;
        public var players_:Vector.<Player>;
        public var teleportOption_:MenuOption;
        public var divider_:_return;
        private var playerRows_:Vector.<ui_playerslist> = new Vector.<ui_playerslist>();

        public function PlayerListMenu(map:GameMap, players:Vector.<Player>)
        {
            var player:Player;
            var row:ui_playerslist;
            super(0x2A2A2A, 0xFFFFFF);
            this.map_ = map;
            this.players_ = players.concat();
            var rowY:int = 4;
            if (this.map_.allowPlayerTeleport_)
            {
                this.teleportOption_ = new TeleportMenuOption(this.map_.player_);
                this.teleportOption_.x = 8;
                this.teleportOption_.y = 8;
                this.teleportOption_.addEventListener(MouseEvent.CLICK, this.onTeleport);
                addChild(this.teleportOption_);
                this.divider_ = new _return(width - 24, 0x2D2D2D);
                this.divider_.x = 6;
                this.divider_.y = 40;
                addChild(this.divider_);
                rowY = 52;
            }
            for each (player in this.players_)
            {
                row = new ui_playerslist(0xB3B3B3, true, player);
                row.x = 0;
                row.y = rowY;
                addChild(row);
                this.playerRows_.push(row);
                rowY += 32;
            }
        }

        private function onTeleport(event:Event):void
        {
            var candidate:Player;
            var localPlayer:Player = this.map_.player_;
            var target:Player;
            for each (candidate in this.players_)
            {
                if (localPlayer.canTeleportTo(candidate))
                {
                    target = candidate;
                    break;
                }
            }
            if (target != null)
            {
                localPlayer.teleportTo(target);
            }
            else
            {
                this.map_.gs_.textBox_.addText(Parameters.SendError, "No players are eligible for teleporting");
            }
            remove();
        }
    }
}
