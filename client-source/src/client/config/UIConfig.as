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

import _F_1._zf;
import _F_1._E_r;
import _F_1._01_;
import _F_1._0H_h;
import _F_1.CurrentCharacterScreen;
import _F_1._05p;
import _F_1._C_Q_;
import _F_1._3V_;
import _F_1._0H_2;
import _F_1._U_W_;
import _F_1._0B_m;
import _F_1._02a;

import _zD_._0D_h;
import _zD_._uf;
import _zD_._N_N_;
import _zD_._0F_Q_;
import _zD_._xF_;
import _zD_._V_M_;
import _zD_.__for;
import _zD_._fy;
import _zD_._2H_;
import _zD_._0D_L_;
import _zD_._9M_;
import _zD_._G_I_;
import _zD_._1k;
import _zD_._E_G_;
import _zD_._09b;
import _zD_.__else;
import _zD_._Q_q;
import _zD_._G_9;
import _zD_._jT_;
import _zD_._Y_w;
import _zD_._yP_;
import _zD_._B_9;

import mapeditor.MapEditorScreen;

import _0L_C_._0G_y;
import _0L_C_._Z_t;
import _0L_C_._0D_W_;
import _0L_C_._s7;

import client.signals.DataSignalB;
import client.signals.DataSignalA;
import client.signals.EmptySignal;

import com.company.assembleegameclient.screens.charrects.CurrentCharacterRect;
import com.company.assembleegameclient.screens.charrects.CharacterRectList;
import com.company.assembleegameclient.ui.InvTabs;

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
        this.mediatorMap.map(_zf).toMediator(_0D_h);
        this.mediatorMap.map(_E_r).toMediator(_uf);
        this.mediatorMap.map(_01_).toMediator(_N_N_);
        this.mediatorMap.map(_0H_h).toMediator(_0F_Q_);
        this.mediatorMap.map(CurrentCharacterScreen).toMediator(_xF_);
        this.mediatorMap.map(_05p).toMediator(_V_M_);
        this.mediatorMap.map(_C_Q_).toMediator(__for);
        this.mediatorMap.map(_3V_).toMediator(_fy);
        this.mediatorMap.map(_0H_2).toMediator(_2H_);
        this.mediatorMap.map(MapEditorScreen).toMediator(_0D_L_);
        this.mediatorMap.map(CurrentCharacterRect).toMediator(_9M_);
        this.mediatorMap.map(CharacterRectList).toMediator(_G_I_);
        this.mediatorMap.map(_0G_y).toMediator(_1k);
        this.mediatorMap.map(_Z_t).toMediator(_E_G_);
        this.mediatorMap.map(_U_W_).toMediator(_09b);
        this.mediatorMap.map(_0B_m).toMediator(__else);
        this.mediatorMap.map(_0D_W_).toMediator(_Q_q);
        this.mediatorMap.map(_s7).toMediator(_G_9);
        this.mediatorMap.map(_02a).toMediator(_jT_);
        this.configureAdditional();
    }

    private function configureAdditional():void {
        this.injector.map(DataSignalB).toValue(new DataSignalB());
        this.injector.map(DataSignalA).toValue(new DataSignalA());
        this.signalCommandMap.map(EmptySignal).toCommand(AddCornerViewCommand);
        this.mediatorMap.map(_Y_w).toMediator(_yP_);
        this.mediatorMap.map(InvTabs).toMediator(_B_9);
    }

}
}
