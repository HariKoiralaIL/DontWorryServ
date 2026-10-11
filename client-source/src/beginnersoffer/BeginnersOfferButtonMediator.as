package beginnersoffer {
import robotlegs.bender.bundles.mvcs.Mediator;

import layers.AddViewToLayerSignal;

import offers.IBeginnersOfferModel;

public class BeginnersOfferButtonMediator extends Mediator {

    [Inject]
    public var view:BeginnersOfferButton;
    [Inject]
    public var openOfferSignal:AddViewToLayerSignal;
    [Inject]
    public var beginnersPackage:IBeginnersOfferModel;

    override public function initialize():void {
        this.view.click.add(this.onButtonClick);
        this.beginnersPackage.offerExpired.addOnce(this.onOfferExpired);
        this.view.setDaysLeft(this.beginnersPackage.getTimeLeft());
    }

    override public function destroy():void {
        this.view.click.remove(this.onButtonClick);
        this.beginnersPackage.offerExpired.remove(this.onOfferExpired);
    }

    private function onButtonClick():void {
        this.openOfferSignal.dispatch();
    }

    private function onOfferExpired():void {
        this.view.destroy();
    }
}
}
