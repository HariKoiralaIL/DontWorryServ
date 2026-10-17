package client.config {

import robotlegs.bender.framework.api.IConfig;

import injection.Injector;

import mediators.IMediatorMap;

import commandmap.ISignalCommandMap;

import game.signals.NoArgSignal3;
import game.signals.DeathSignal;
import game.signals.SavedCharacterSignal2;
import game.signals.SavedCharacterSignal;

import screencommands.ChooseInitialScreenCommand;
import screencommands.ContinueAfterDeathCommand;
import screencommands.AddCornerViewCommand;

import commands.ShowCharacterOverlayCommand;
import commands.ShowOverlayViewCommand;

import client.ui.screens.LoadingScreen;
import client.ui.screens.AccountLoadingScreen;
import client.ui.screens.ServersScreen;
import client.ui.screens.CreditsScreen;
import client.ui.screens.CurrentCharacterScreen;
import client.ui.screens.BaseScreen;
import client.ui.screens.TitleScreen;
import client.ui.screens.LegendsScreen;
import client.ui.screens.NewCharacterScreen;
import client.ui.screens.DeathScreen;
import client.ui.screens.NewsItem;
import client.ui.screens.MapLoadingOverlay;

import ui.mediators.HtmlTextMediator;
import ui.mediators.BackToTitleMediator;
import ui.mediators.ServersScreenMediator;
import ui.mediators.CreditsScreenMediator;
import ui.mediators.CurrentCharacterScreenMediator;
import ui.mediators.TooltipScreenMediator;
import ui.mediators.TitleScreenMediator;
import ui.mediators.LegendsScreenMediator;
import ui.mediators.NewCharacterScreenMediator;
import ui.mediators.MapEditorScreenMediator;
import ui.mediators.CurrentCharacterRectMediator;
import ui.mediators.CharacterRectListMediator;
import ui.mediators.BuyingCharSlotDialogMediator;
import ui.mediators.ErrorDialogMediator;
import ui.mediators.FameScreenMediator;
import ui.mediators.AccountCharactersScreenMediator;
import ui.mediators.DeleteCharacterConfirmationMediator;
import ui.mediators.DeletingCharacterDialogMediator;
import ui.mediators.MapLoadingScreenMediator;
import ui.mediators.KeyPanel;
import ui.mediators.KeyPanelMediator;
import ui.mediators.InvTabsMediator;

import mapeditor.MapEditorScreen;

import game.dialogs.BuyingCharSlotDialog;
import game.dialogs.ErrorDialog;
import game.dialogs.DeleteCharacterConfirmation;
import game.dialogs.DeletingCharacterDialog;

import client.signals.DataSignalB;
import client.signals.DataSignalA;
import client.signals.EmptySignal;

import com.company.assembleegameclient.screens.charrects.CurrentCharacterRect;
import com.company.assembleegameclient.screens.charrects.CharacterRectList;
import com.company.assembleegameclient.ui.PlayerPanel;

/**
 * Robotlegs config for the UI layer: signal-to-command mappings,
 * view-to-mediator mappings and the shared signal instances.
 * Formerly _U_.UIConfig.
 */
public class UIConfig implements IConfig {

    [Inject]
    public var injector:Injector;
    [Inject]
    public var mediatorMap:IMediatorMap;
    [Inject]
    public var signalCommandMap:ISignalCommandMap;

    public function configure():void {
        this.signalCommandMap.map(NoArgSignal3, true).toCommand(ChooseInitialScreenCommand);
        this.signalCommandMap.map(DeathSignal).toCommand(ContinueAfterDeathCommand);
        this.signalCommandMap.map(SavedCharacterSignal2).toCommand(ShowCharacterOverlayCommand);
        this.signalCommandMap.map(SavedCharacterSignal).toCommand(ShowOverlayViewCommand);
        this.mediatorMap.map(LoadingScreen).toMediator(HtmlTextMediator);
        this.mediatorMap.map(AccountLoadingScreen).toMediator(BackToTitleMediator);
        this.mediatorMap.map(ServersScreen).toMediator(ServersScreenMediator);
        this.mediatorMap.map(CreditsScreen).toMediator(CreditsScreenMediator);
        this.mediatorMap.map(CurrentCharacterScreen).toMediator(CurrentCharacterScreenMediator);
        this.mediatorMap.map(BaseScreen).toMediator(TooltipScreenMediator);
        this.mediatorMap.map(TitleScreen).toMediator(TitleScreenMediator);
        this.mediatorMap.map(LegendsScreen).toMediator(LegendsScreenMediator);
        this.mediatorMap.map(NewCharacterScreen).toMediator(NewCharacterScreenMediator);
        this.mediatorMap.map(MapEditorScreen).toMediator(MapEditorScreenMediator);
        this.mediatorMap.map(CurrentCharacterRect).toMediator(CurrentCharacterRectMediator);
        this.mediatorMap.map(CharacterRectList).toMediator(CharacterRectListMediator);
        this.mediatorMap.map(BuyingCharSlotDialog).toMediator(BuyingCharSlotDialogMediator);
        this.mediatorMap.map(ErrorDialog).toMediator(ErrorDialogMediator);
        this.mediatorMap.map(DeathScreen).toMediator(FameScreenMediator);
        this.mediatorMap.map(NewsItem).toMediator(AccountCharactersScreenMediator);
        this.mediatorMap.map(DeleteCharacterConfirmation).toMediator(DeleteCharacterConfirmationMediator);
        this.mediatorMap.map(DeletingCharacterDialog).toMediator(DeletingCharacterDialogMediator);
        this.mediatorMap.map(MapLoadingOverlay).toMediator(MapLoadingScreenMediator);
        this.configureAdditional();
    }

    private function configureAdditional():void {
        this.injector.map(DataSignalB).toValue(new DataSignalB());
        this.injector.map(DataSignalA).toValue(new DataSignalA());
        this.signalCommandMap.map(EmptySignal).toCommand(AddCornerViewCommand);
        this.mediatorMap.map(KeyPanel).toMediator(KeyPanelMediator);
        this.mediatorMap.map(PlayerPanel).toMediator(InvTabsMediator);
    }

}
}
