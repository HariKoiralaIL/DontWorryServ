package menus
{
    import com.company.assembleegameclient.game.GameSprite;
    import com.company.assembleegameclient.objects.Player;
    import com.company.assembleegameclient.ui.ui_playerslist;
    import com.company.assembleegameclient.util._07E_;
    import com.company.util.AssetLibrary;

    import flash.events.Event;
    import flash.events.MouseEvent;

    public class PlayerMenu extends Menu
    {
        public var gs_:GameSprite;
        public var playerName_:String;
        public var player_:Player;
        public var playerRow_:ui_playerslist;

        public function PlayerMenu(gameSprite:GameSprite, player:Player)
        {
            var teleportOption:TeleportMenuOption;
            super(0x2A2A2A, 0xFFFFFF);
            this.gs_ = gameSprite;
            this.playerName_ = player.name_;
            this.player_ = player;
            this.playerRow_ = new ui_playerslist(0xB3B3B3, true, this.player_);
            addChild(this.playerRow_);
            if (Player._e_D)
            {
                this.addTextOption(10, "Kick", this.onKick);
                this.addTextOption(10, "Autotrade", this.onAutotrade);
                this.addTextOption(4, "Mute", this.onMute);
                this.addTextOption(3, "UnMute", this.onUnmute);
            }
            if (this.gs_.map_.allowPlayerTeleport_ && this.player_._0D_X_(this.player_))
            {
                teleportOption = new TeleportMenuOption(this.gs_.map_.player_);
                teleportOption.addEventListener(MouseEvent.CLICK, this.onTeleport);
                addOption(teleportOption);
            }
            if (this.player_._0D_X_(this.player_))
            {
                this.addTextOption(4, "Tell", this.onTell);
            }
            if (this.gs_.map_.player_.guildRank_ >= _07E_._f3 && (player.guildName_ == null || player.guildName_.length == 0))
            {
                this.addTextOption(10, "Invite", this.onInvite);
            }
            if (((this.gs_.map_.player_.partyID_ != -1 && this.gs_.map_.player_.partyLeader) || this.gs_.map_.player_.partyID_ == -1) && player.partyID_ == -1)
            {
                this.addTextOption(10, "Party", this.onParty);
            }
            if (!this.player_.starred_)
            {
                this.addTextOption(0, "Lock", this.onLock);
            }
            else
            {
                this.addTextOption(1, "Unlock", this.onUnlock);
            }
            this.addTextOption(7, "Trade", this.onTrade);
            if (!this.player_._0M_w)
            {
                this.addTextOption(8, "Ignore", this.onIgnore);
            }
            else
            {
                this.addTextOption(9, "Unignore", this.onUnignore);
            }
        }

        private function addTextOption(iconIndex:int, label:String, handler:Function):void
        {
            var option:MenuOption = new MenuOption(AssetLibrary._xK_("lofiInterfaceBig", iconIndex), 0xFFFFFF, label);
            option.addEventListener(MouseEvent.CLICK, handler);
            addOption(option);
        }

        private function onTeleport(event:Event):void
        {
            this.gs_.map_.player_.teleportTo(this.player_);
            remove();
        }

        private function onInvite(event:Event):void
        {
            this.gs_.gsc_.guildInvite(this.playerName_);
            remove();
        }

        private function onParty(event:Event):void
        {
            this.gs_.gsc_.partyInvite(this.playerName_);
            remove();
        }

        private function onLock(event:Event):void
        {
            this.gs_.map_.party_.lockPlayer(this.player_);
            remove();
        }

        private function onUnlock(event:Event):void
        {
            this.gs_.map_.party_.unlockPlayer(this.player_);
            remove();
        }

        private function onKick(event:Event):void
        {
            this.gs_.gsc_.playerText("/kick " + this.player_.name_);
            remove();
        }

        private function onMute(event:Event):void
        {
            this.gs_.gsc_.playerText("/mute " + this.player_.name_);
            remove();
        }

        private function onUnmute(event:Event):void
        {
            this.gs_.gsc_.playerText("/unmute " + this.player_.name_);
            remove();
        }

        private function onAutotrade(event:Event):void
        {
            this.gs_.gsc_.playerText("/autotrade " + this.player_.name_);
            remove();
        }

        private function onTrade(event:Event):void
        {
            this.gs_.gsc_.requestTrade(this.playerName_);
            remove();
        }

        private function onIgnore(event:Event):void
        {
            this.gs_.map_.party_.ignorePlayer(this.player_);
            remove();
        }

        private function onUnignore(event:Event):void
        {
            this.gs_.map_.party_.unignorePlayer(this.player_);
            remove();
        }

        private function onTell(event:Event):void
        {
            this.gs_.gsc_.playerText("/tell " + this.player_.name_);
            remove();
        }
    }
}
