package beginnersoffer {

  import beginnersoffer.*;

  import robotlegs.bender.framework.api.IConfig;

import injection.Injector;

import mediators.IMediatorMap;

import commandmap.ISignalCommandMap;

import offers.IOffersModel;
import offers.OffersModel;
import offers.IBeginnersOfferModel;
import offers.BeginnersOfferModel;

import layers.AddViewToLayerSignal;

import beginnersoffer.ShowBeginnersOfferCommand;

public class BeginnersOfferConfig implements IConfig {

    [Inject]
    public var injector:Injector;
    [Inject]
    public var mediatorMap:IMediatorMap;
    [Inject]
    public var signalCommandMap:ISignalCommandMap;

    public function configure():void {
        injector.map(IOffersModel).toSingleton(OffersModel);
        injector.map(IBeginnersOfferModel).toSingleton(BeginnersOfferModel);
        mediatorMap.map(BeginnersOfferButton).toMediator(BeginnersOfferButtonMediator);
        mediatorMap.map(BeginnersOfferDialogView).toMediator(BeginnersOfferDialogMediator);
        mediatorMap.map(DarkOverlay).toMediator(DarkOverlayMediator);
        signalCommandMap.map(AddViewToLayerSignal).toCommand(ShowBeginnersOfferCommand);
    }

}
}
