package game.guild {
    import com.company.assembleegameclient.util._07E_;
    import com.company.rotmg.graphics.DeleteXGraphic;
    import com.company.ui.SimpleText;
    import com.company.util.MoreColorUtil;

    import flash.display.Bitmap;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.geom.ColorTransform;

    import game.dialogs.Dialog;

    /** One guild member line: position, name, fame, rank, and promote / demote / remove controls. */
    internal class GuildMemberRow extends Sprite {

        public static const WIDTH:int = 756;
        public static const HEIGHT:int = 32;

        private static const FONT:String = "Myriad Pro";
        private static const TEXT_COLOR:uint = 0xB3B3B3;
        private static const SELF_COLOR:uint = 0xFCC219;
        private static const HOVER_TRANSFORM:ColorTransform = new ColorTransform(1, (220 / 0xFF), (133 / 0xFF));

        private var name_:String;
        private var rank_:int;
        private var positionText_:SimpleText;
        private var nameText_:SimpleText;
        private var fameText_:SimpleText;
        private var fameIcon_:Bitmap;
        private var rankIcon_:Bitmap;
        private var rankText_:SimpleText;
        private var promoteButton_:Sprite;
        private var demoteButton_:Sprite;
        private var removeButton_:Sprite;

        public function GuildMemberRow(position:int, name:String, rank:int, fame:int, isSelf:Boolean, viewerRank:int) {
            super();
            this.name_ = name;
            this.rank_ = rank;
            var color:uint = isSelf ? SELF_COLOR : TEXT_COLOR;

            this.positionText_ = this.createText(position.toString() + ".", color, true);
            this.positionText_.x = (60 - this.positionText_.width);
            this.positionText_.y = this.centeredY(this.positionText_);
            addChild(this.positionText_);

            this.nameText_ = this.createText(name, color, true);
            this.nameText_.x = 100;
            this.nameText_.y = this.centeredY(this.nameText_);
            addChild(this.nameText_);

            this.fameText_ = this.createText(fame.toString(), color, false);
            this.fameText_.x = (408 - this.fameText_.width);
            this.fameText_.y = this.centeredY(this.fameText_);
            addChild(this.fameText_);

            this.fameIcon_ = new Bitmap(_07E_._oO_(40));
            this.fameIcon_.x = 400;
            this.fameIcon_.y = ((HEIGHT / 2) - (this.fameIcon_.height / 2));
            addChild(this.fameIcon_);

            this.rankIcon_ = new Bitmap(_07E_._wS_(rank, 10));
            this.rankIcon_.x = 548;
            this.rankIcon_.y = ((HEIGHT / 2) - (this.rankIcon_.height / 2));
            addChild(this.rankIcon_);

            this.rankText_ = this.createText(_07E_._0C_n(rank), color, false);
            this.rankText_.x = 580;
            this.rankText_.y = this.centeredY(this.rankText_);
            addChild(this.rankText_);

            if (_07E_._0D_e(viewerRank, rank)) {
                this.promoteButton_ = this.createArrowButton(true);
                this.promoteButton_.addEventListener(MouseEvent.CLICK, this.onPromoteClick);
                this.promoteButton_.x = (670 + 6);
                this.promoteButton_.y = (HEIGHT / 2);
                addChild(this.promoteButton_);
            }
            if (_07E_._z0(viewerRank, rank)) {
                this.demoteButton_ = this.createArrowButton(false);
                this.demoteButton_.addEventListener(MouseEvent.CLICK, this.onDemoteClick);
                this.demoteButton_.x = (700 + 6);
                this.demoteButton_.y = (HEIGHT / 2);
                addChild(this.demoteButton_);
            }
            if (_07E_._dn(viewerRank, rank)) {
                this.removeButton_ = new DeleteXGraphic();
                this.addHover(this.removeButton_);
                this.removeButton_.addEventListener(MouseEvent.CLICK, this.onRemoveClick);
                this.removeButton_.x = 730;
                this.removeButton_.y = ((HEIGHT / 2) - (this.removeButton_.height / 2));
                addChild(this.removeButton_);
            }
        }

        private function createText(text:String, color:uint, bold:Boolean):SimpleText {
            var field:SimpleText = new SimpleText(22, color, false, 0, 0, FONT);
            if (bold) {
                field.setBold(true);
            }
            field.text = text;
            field._08S_();
            field.filters = [new DropShadowFilter(0, 0, 0, 1, 8, 8)];
            return field;
        }

        private function centeredY(field:SimpleText):Number {
            return ((HEIGHT / 2) - (field.height / 2));
        }

        /** Small triangle: pointing up for promote (rotated), down for demote. */
        private function createArrowButton(promote:Boolean):Sprite {
            var button:Sprite = new Sprite();
            var g:Graphics = button.graphics;
            g.beginFill(0xFFFFFF);
            g.moveTo(-8, -6);
            g.lineTo(8, -6);
            g.lineTo(0, 6);
            g.lineTo(-8, -6);
            if (promote) {
                button.rotation = 180;
            }
            this.addHover(button);
            return button;
        }

        private function addHover(button:Sprite):void {
            button.addEventListener(MouseEvent.MOUSE_OVER, this.onHoverOver);
            button.addEventListener(MouseEvent.ROLL_OUT, this.onHoverOut);
        }

        private function onHoverOver(e:MouseEvent):void {
            (e.currentTarget as Sprite).transform.colorTransform = HOVER_TRANSFORM;
        }

        private function onHoverOut(e:MouseEvent):void {
            (e.currentTarget as Sprite).transform.colorTransform = MoreColorUtil.identity;
        }

        private function showConfirm(message:String, title:String, confirmLabel:String, analyticsPage:String, onConfirm:Function):void {
            var dialog:Dialog = new Dialog(message, title, "Cancel", confirmLabel, analyticsPage);
            dialog.addEventListener(Dialog.BUTTON1_EVENT, this.closeDialog);
            dialog.addEventListener(Dialog.BUTTON2_EVENT, onConfirm);
            stage.addChild(dialog);
        }

        private function closeDialog(e:Event):void {
            stage.removeChild(e.currentTarget as Dialog);
        }

        private function onPromoteClick(e:MouseEvent):void {
            this.showConfirm(
                "Are you sure you want to promote " + this.name_ + " to " + _07E_._0C_n(_07E_._0H_q(this.rank_)) + "?",
                "Promote " + this.name_, "Promote", "/promote", this.onPromoteConfirmed);
        }

        private function onPromoteConfirmed(e:Event):void {
            this.closeDialog(e);
            dispatchEvent(new GuildMemberEvent(GuildMemberEvent.SET_RANK, this.name_, _07E_._0H_q(this.rank_)));
        }

        private function onDemoteClick(e:MouseEvent):void {
            this.showConfirm(
                "Are you sure you want to demote " + this.name_ + " to " + _07E_._0C_n(_07E_._4J_(this.rank_)) + "?",
                "Demote " + this.name_, "Demote", "/demote", this.onDemoteConfirmed);
        }

        private function onDemoteConfirmed(e:Event):void {
            this.closeDialog(e);
            dispatchEvent(new GuildMemberEvent(GuildMemberEvent.SET_RANK, this.name_, _07E_._4J_(this.rank_)));
        }

        private function onRemoveClick(e:MouseEvent):void {
            this.showConfirm(
                "Are you sure you want to remove " + this.name_ + " from the guild?",
                "Remove " + this.name_, "Remove", "/removeFromGuild", this.onRemoveConfirmed);
        }

        private function onRemoveConfirmed(e:Event):void {
            this.closeDialog(e);
            dispatchEvent(new GuildMemberEvent(GuildMemberEvent.REMOVE_MEMBER, this.name_));
        }
    }
}
