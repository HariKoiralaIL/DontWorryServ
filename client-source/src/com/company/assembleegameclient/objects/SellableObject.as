package com.company.assembleegameclient.objects {
    import com.company.assembleegameclient.ui.tooltip.ToolTip;

    import flash.display.BitmapData;

    import client.ui.panels.SellableObjectPanel;

    import com.company.assembleegameclient.game.GameSprite;

    import client.ui.panels.Panel;

    public class SellableObject extends GameObject implements IInteractable {

        public function SellableObject(xml:XML) {
            super(xml);
            isInteractive_ = true;
        }
        public var price_:int = 0;
        public var currency_:int = -1;
        public var rankReq_:int = 0;
        public var guildRankReq_:int = -1;

        public function setPrice(price:int):void {
            this.price_ = price;
        }

        public function setCurrency(currency:int):void {
            this.currency_ = currency;
        }

        public function setRankReq(rank:int):void {
            this.rankReq_ = rank;
        }

        public function soldObjectName():String {
            return (null);
        }

        public function soldObjectInternalName():String {
            return (null);
        }

        public function getTooltip():ToolTip {
            return (null);
        }

        public function getIcon():BitmapData {
            return (null);
        }

        public function getPanel(gs:GameSprite):Panel {
            return (new SellableObjectPanel(gs, this));
        }

    }
}//package com.company.assembleegameclient.objects
