package game.dialogs {
    import account.Account;

    import com.company.assembleegameclient.appengine.AppEngineClient;
    import com.company.assembleegameclient.parameters.Parameters;

    import events.GenericDataEvent;
    import events.TextErrorEvent;

    import flash.events.Event;

    /** Shows a progress message while the character slot purchase request runs. */
    public class BuyingCharSlotDialog extends Dialog {

        public var price_:int;

        public function BuyingCharSlotDialog(price:int) {
            super("Buying Character Slot...", null, null, null, "/buyingCharSlot");
            this.price_ = price;
            var request:AppEngineClient = new AppEngineClient(Parameters.serverAddress(), "/account", true, 2);
            request.addEventListener(GenericDataEvent.GENERIC_DATA, this.onPurchaseSuccess);
            request.addEventListener(TextErrorEvent.TEXT_ERROR, this.onPurchaseError);
            request.sendRequest("purchaseCharSlot", Account.getInstance().credentials());
        }

        private function onPurchaseSuccess(e:Event):void {
            dispatchEvent(new Event(Event.COMPLETE));
        }

        private function onPurchaseError(e:TextErrorEvent):void {
            dispatchEvent(e.clone());
        }
    }
}
