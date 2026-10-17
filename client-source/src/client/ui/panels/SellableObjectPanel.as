package client.ui.panels {
import game.dialogs.NotRegisteredDialog;

import account.Account;

import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.objects.SellableObject;
import com.company.assembleegameclient.ui._u5;
import com.company.assembleegameclient.ui.tooltip.ToolTip;
import com.company.assembleegameclient.util.Currency;
import com.company.assembleegameclient.util.ConfirmPurchaseModal;
import com.company.assembleegameclient.util.GuildUtil;
import com.company.ui.SimpleText;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

import signals.Signal;

/** Shows an item for sale with its price, or the rank needed to buy it. */
public class SellableObjectPanel extends Panel {

    private static const BUY_BUTTON_BOTTOM_OFFSET:int = 10;

    private static function createGuildRankRequiredText(rank:int):SimpleText {
        var text:SimpleText = new SimpleText(16, 0xFF0000, false, 0, 0, "Myriad Pro");
        text.setBold(true);
        text.text = GuildUtil.getRankName(rank) + " Rank Required";
        text._08S_();
        text.filters = [new DropShadowFilter(0, 0, 0)];
        return text;
    }

    public var event:Signal;
    private var sellable:SellableObject;
    private var modal:ConfirmPurchaseModal;
    private var nameText:SimpleText;
    private var buyButton:_u5;
    private var rankRequiredLabel:Sprite = null;
    private var guildRankLabel:SimpleText = null;
    private var iconHolder:Sprite;
    private var bitmap:Bitmap;
    private var toolTip:ToolTip;

    public function SellableObjectPanel(gs:GameSprite, obj:SellableObject) {
        super(gs);
        this.event = new Signal(SellableObject);
        this.nameText = PanelUtil.createLabel("Thing For Sale", 16, 0xFFFFFF, WIDTH - 44);
        addChild(this.nameText);
        this.iconHolder = new Sprite();
        addChild(this.iconHolder);
        this.bitmap = new Bitmap(null);
        this.iconHolder.addChild(this.bitmap);
        this.buyButton = new _u5("Buy for ", 16, 0, Currency.INVALID);
        this.buyButton.addEventListener(MouseEvent.CLICK, this.onBuyClick);
        addChild(this.buyButton);
        this.setObject(obj);
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    override public function draw():void {
        var player:Player = gs_.map_.player_;
        this.nameText.y = (this.nameText.height > 30) ? 0 : 12;
        var starsRequired:int = this.sellable.rankReq_;
        if (player.numStars_ < starsRequired) {
            this.removeIfPresent(this.buyButton);
            if (this.rankRequiredLabel == null || !contains(this.rankRequiredLabel)) {
                this.rankRequiredLabel = PanelUtil.createRankRequiredLabel(starsRequired);
                this.rankRequiredLabel.x = (WIDTH / 2) - (this.rankRequiredLabel.width / 2);
                this.rankRequiredLabel.y = (HEIGHT - (this.rankRequiredLabel.height / 2)) - 20;
                addChild(this.rankRequiredLabel);
            }
        } else if (player.guildRank_ < this.sellable.guildRankReq_) {
            this.removeIfPresent(this.buyButton);
            if (this.guildRankLabel == null || !contains(this.guildRankLabel)) {
                this.guildRankLabel = createGuildRankRequiredText(this.sellable.guildRankReq_);
                this.guildRankLabel.x = (WIDTH / 2) - (this.guildRankLabel.width / 2);
                this.guildRankLabel.y = (HEIGHT - (this.guildRankLabel.height / 2)) - 20;
                addChild(this.guildRankLabel);
            }
        } else {
            this.buyButton.setPrice(this.sellable.price_, this.sellable.currency_);
            this.buyButton._A_w(gs_.gsc_.outstandingBuy_ == null);
            this.buyButton.x = (WIDTH / 2) - (this.buyButton.w_ / 2);
            this.buyButton.y = (HEIGHT - (this.buyButton.height / 2)) - BUY_BUTTON_BOTTOM_OFFSET;
            if (!contains(this.buyButton)) {
                addChild(this.buyButton);
            }
            this.removeIfPresent(this.rankRequiredLabel);
            this.removeIfPresent(this.guildRankLabel);
        }
    }

    /** Points the panel at a (new) sellable object. */
    public function setObject(obj:SellableObject):void {
        if (obj == this.sellable) {
            return;
        }
        this.sellable = obj;
        this.buyButton.setPrice(this.sellable.price_, this.sellable.currency_);
        this.nameText.htmlText = '<p align="center">' + this.sellable.soldObjectName() + "</p>";
        this.bitmap.bitmapData = this.sellable.getIcon();
    }

    private function removeIfPresent(child:DisplayObject):void {
        if (child != null && contains(child)) {
            removeChild(child);
        }
    }

    private function removeToolTip():void {
        if (this.toolTip != null) {
            if (this.toolTip.parent != null) {
                this.toolTip.parent.removeChild(this.toolTip);
            }
            this.toolTip = null;
        }
    }

    private function buy():void {
        if (!Account.getInstance().isRegistered()) {
            stage.addChild(new NotRegisteredDialog("In order to use " + Currency.getName(this.sellable.currency_)
                    + ", you must be a registered user."));
        } else {
            this.modal = new ConfirmPurchaseModal(this.event, this.sellable, this.buyButton.width, gs_);
            parent.addChild(this.modal);
        }
    }

    private function onAddedToStage(e:Event):void {
        this.iconHolder.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        this.iconHolder.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
        this.iconHolder.x = -4;
        this.iconHolder.y = -8;
        this.nameText.x = 44;
    }

    private function onRemovedFromStage(e:Event):void {
        this.iconHolder.removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        this.iconHolder.removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
        this.removeToolTip();
        if (parent != null && this.modal != null && this.modal.open) {
            parent.removeChild(this.modal);
        }
    }

    private function onMouseOver(e:MouseEvent):void {
        this.removeToolTip();
        this.toolTip = this.sellable.getTooltip();
        stage.addChild(this.toolTip);
    }

    private function onMouseOut(e:MouseEvent):void {
        this.removeToolTip();
    }

    private function onBuyClick(e:MouseEvent):void {
        if (ConfirmPurchaseModal.isClosed) {
            this.buy();
        }
    }

    private function onKeyDown(e:KeyboardEvent):void {
        if (PanelUtil.isInteractKey(e) && ConfirmPurchaseModal.isClosed) {
            this.buy();
        }
    }
}
}
