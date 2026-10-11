package arrows
{
    import menus.Menu;
    import menus.PlayerListMenu;

    import com.company.assembleegameclient.objects.GameObject;
    import com.company.assembleegameclient.objects.Player;
    import com.company.assembleegameclient.ui.tooltip.PlayerListToolTip;

    import flash.events.MouseEvent;

    public class PartyMemberArrow extends ScreenArrow
    {
        public function PartyMemberArrow()
        {
            super(0xFFFFFF, 0x3FC752, false);
        }

        protected function createMenu():Menu
        {
            var player:Player = go_ as Player;
            if (player == null || player.map_ == null)
            {
                return null;
            }
            var localPlayer:Player = player.map_.player_;
            if (localPlayer == null)
            {
                return null;
            }
            return new PlayerListMenu(player.map_, this.getPlayers());
        }

        override protected function onMouseOver(event:MouseEvent):void
        {
            super.onMouseOver(event);
            setToolTip(new PlayerListToolTip(this.getPlayers(), false));
        }

        override protected function onMouseOut(event:MouseEvent):void
        {
            super.onMouseOut(event);
            setToolTip(null);
        }

        override protected function onMouseDown(event:MouseEvent):void
        {
            super.onMouseDown(event);
            closeOpenMenu();
            showMenu(this.createMenu());
        }

        private function getPlayers():Vector.<Player>
        {
            var obj:GameObject;
            var players:Vector.<Player> = new <Player>[go_ as Player];
            for each (obj in extraObjects_)
            {
                players.push(obj as Player);
            }
            return players;
        }
    }
}
