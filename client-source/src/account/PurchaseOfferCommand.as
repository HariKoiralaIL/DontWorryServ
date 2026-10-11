package account
{
    import com.company.assembleegameclient.account.web.PurchaseMediator;
    import com.company.assembleegameclient.util.offer.Offer;
    import com.company.assembleegameclient.util.offer.Offers;

    public class PurchaseOfferCommand
    {
        public var mediator:PurchaseMediator;
        public var offers:Offers;
        public var offer:Offer;
        public var paymentMethod:String;

        public function execute():void
        {
        }
    }
}
