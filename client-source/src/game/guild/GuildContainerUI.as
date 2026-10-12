package game.guild {
    import client.ui.screens.MenuButton;

    import client.events.ResultEvent;

    import com.company.assembleegameclient.game.GameSprite;
    import com.company.assembleegameclient.objects.Player;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;

    import game.dialogs.Dialog;

    /** Full-screen guild window: shows the roster and applies rank changes / removals. */
    public class GuildContainerUI extends Sprite {

        private var gs_:GameSprite;
        private var memberList_:GuildMemberList;
        private var continueButton_:MenuButton;

        public function GuildContainerUI(gs:GameSprite) {
            super();
            this.gs_ = gs;
            graphics.clear();
            graphics.beginFill(0x2B2B2B, 0.8);
            graphics.drawRect(0, 0, 800, 600);
            graphics.endFill();
            this.showMemberList();
            this.continueButton_ = new MenuButton("continue", 36, false);
            this.continueButton_.addEventListener(MouseEvent.CLICK, this.onContinueClick);
            addChild(this.continueButton_);
            addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        }

        private function showMemberList():void {
            var player:Player = this.gs_.map_.player_;
            var playerName:String = (player == null) ? "" : player.name_;
            var playerRank:int = (player == null) ? 0 : player.guildRank_;
            this.memberList_ = new GuildMemberList(50, 0, playerName, playerRank);
            this.memberList_.addEventListener(GuildMemberEvent.SET_RANK, this.onSetRank);
            this.memberList_.addEventListener(GuildMemberEvent.REMOVE_MEMBER, this.onRemoveMember);
            addChild(this.memberList_);
        }

        private function removeMemberList():void {
            this.memberList_.removeEventListener(GuildMemberEvent.SET_RANK, this.onSetRank);
            this.memberList_.removeEventListener(GuildMemberEvent.REMOVE_MEMBER, this.onRemoveMember);
            removeChild(this.memberList_);
        }

        private function showError(text:String):void {
            var dialog:Dialog = new Dialog(text, "Error", "Ok", null, "/guildError");
            dialog.addEventListener(Dialog.BUTTON1_EVENT, this.onErrorDismissed);
            stage.addChild(dialog);
        }

        private function close():void {
            stage.focus = null;
            parent.removeChild(this);
        }

        private function onSetRank(e:GuildMemberEvent):void {
            this.removeMemberList();
            this.gs_.addEventListener(ResultEvent.GUILD_RESULT, this.onGuildResult);
            this.gs_.gsc_._k8(e.name_, e.rank_);
        }

        private function onRemoveMember(e:GuildMemberEvent):void {
            this.removeMemberList();
            this.gs_.addEventListener(ResultEvent.GUILD_RESULT, this.onGuildResult);
            this.gs_.gsc_.guildRemove(e.name_);
        }

        private function onGuildResult(e:ResultEvent):void {
            this.gs_.removeEventListener(ResultEvent.GUILD_RESULT, this.onGuildResult);
            if (!e.success_) {
                this.showError(e.errorText_);
            } else {
                this.showMemberList();
            }
        }

        private function onErrorDismissed(e:Event):void {
            var dialog:Dialog = (e.currentTarget as Dialog);
            stage.removeChild(dialog);
            this.showMemberList();
        }

        private function onContinueClick(e:MouseEvent):void {
            this.close();
        }

        private function onAddedToStage(e:Event):void {
            this.continueButton_.x = ((800 / 2) - (this.continueButton_.width / 2));
            this.continueButton_.y = 545;
            stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown, false, 1);
            stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUp, false, 1);
        }

        private function onRemovedFromStage(e:Event):void {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown, false);
            stage.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUp, false);
        }

        private function onKeyDown(e:KeyboardEvent):void {
            e.stopImmediatePropagation();
        }

        private function onKeyUp(e:KeyboardEvent):void {
            e.stopImmediatePropagation();
        }
    }
}
