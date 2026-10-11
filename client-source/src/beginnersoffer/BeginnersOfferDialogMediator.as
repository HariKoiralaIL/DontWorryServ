package beginnersoffer {
import game.dialogs.NotRegisteredDialog;

import robotlegs.bender.bundles.mvcs.Mediator;

import client.payment.IPaymentService;
import client.payment.PurchaseRequest;

import account.Account;

import client.signals.typed.BooleanSignal;

import env.ClientEnv;
import env.PlatformType;

import offers.IBeginnersOfferModel;
import offers.IOffersModel;

import rootview.Layers;

public class BeginnersOfferDialogMediator extends Mediator {

    private static const NOT_REGISTERED_MESSAGE:String =
            "In order to buy the Beginners package, you must be a registered user.";

    [Inject]
    public var view:BeginnersOfferDialogView;
    [Inject]
    public var inputEnabledSignal:BooleanSignal;
    [Inject]
    public var beginnersPackage:IBeginnersOfferModel;
    [Inject]
    public var offersModel:IOffersModel;
    [Inject]
    public var layers:Layers;
    [Inject]
    public var platform:ClientEnv;
    [Inject]
    public var purchaseService:IPaymentService;
    private var daysLeft:int;
    private var purchaseData:PurchaseRequest;

    override public function initialize():void {
        this.view.buy.add(this.onBuy);
        this.inputEnabledSignal.dispatch(false);
        this.beginnersPackage.clearShowNow();
        if (Account.getInstance().isRegistered()) {
            this.beginnersPackage.timeLeftUpdated.addOnce(this.onTimeLeftUpdated);
            this.beginnersPackage.requestTimeLeft();
        } else {
            this.showLimitedOffer();
        }
    }

    override public function destroy():void {
        this.view.buy.remove(this.onBuy);
        this.inputEnabledSignal.dispatch(true);
    }

    private function onTimeLeftUpdated():void {
        this.daysLeft = this.beginnersPackage.getTimeLeft();
        if (this.daysLeft == 0) {
            this.view.showOfferExpired();
        } else {
            this.loadOffers();
        }
    }

    private function loadOffers():void {
        this.offersModel.offersUpdated.addOnce(this.showLimitedOffer);
        this.offersModel.loadOffers();
    }

    private function showLimitedOffer():void {
        this.view.showLimitedOffer(this.daysLeft);
    }

    private function onBuy():void {
        if (Account.getInstance().isRegistered()) {
            this.startPurchase();
        } else {
            this.showRegistrationRequired();
        }
    }

    private function startPurchase():void {
        this.purchaseData = new PurchaseRequest();
        this.purchaseData.offer = this.beginnersPackage.getBeginnersOffer();
        this.purchaseService.complete.addOnce(this.onPurchaseComplete);
        switch (this.platform.getPlatform()) {
            case PlatformType.STEAM:
            case PlatformType.WEB:
                this.view.showPaymentMethods();
                this.view.paymentMethodSelected.addOnce(this.onPaymentMethodSelected);
                break;
            default:
                this.purchaseService.purchase(this.purchaseData);
        }
    }

    private function onPaymentMethodSelected(method:String):void {
        this.purchaseData.paymentMethod = method;
        this.purchaseService.purchase(this.purchaseData);
    }

    private function onPurchaseComplete():void {
        this.beginnersPackage.expireOffer();
        this.view.destroy();
    }

    private function showRegistrationRequired():void {
        this.layers.overlay.addChild(new NotRegisteredDialog(NOT_REGISTERED_MESSAGE));
        this.view.destroy();
    }
}
}
