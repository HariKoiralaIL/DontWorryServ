package config {

import flash.display.DisplayObjectContainer;

import commandmap.ISignalCommandMap;
import commands.AllowDomainsCommand;
import commands.EnableServerListCommand;
import commands.InitAnalyticsCommand;
import commands.RecordDeathCommand;
import commands.ShowViewCommand;
import commands.TrackEventCommand;
import commands.TrackPageViewCommand;
import env.ClientEnv;
import env.DeathRecord;
import env.Deployment;
import env.Domain;
import env.ServerListState;
import injection.Injector;
import mediators.IMediatorMap;
import robotlegs.bender.framework.api.IConfig;
import robotlegs.bender.framework.api.IContext;
import rootview.Layers;
import rootview.ScreensView;
import rootview.ScreensViewMediator;
import rootview.UncaughtErrorMediator;

import services.LoadCharacterListTask;
import services.DeleteCharacterTask;
import services.AnalyticsTracker;
import services.LoadFameTask;
import client.tasks.TaskTracker;
import _U_5._01W_;
import _U_5._06a;
import _U_5._0K_2;
import _U_5._0_D_;
import _U_5._6J_;
import _U_5._7e;
import _U_5._M_d;
import _U_5._bo;
import _U_5._D_c;
import _U_5._dd;
import _U_5._sC_;
import _U_5._sT_;
import _U_5._zz;

/**
 * The main application config. Sets up the injector mappings (models, services,
 * signals and signal -> command bindings), creates the layer container, maps views
 * to their mediators and, once the context has initialized, mediates the existing
 * views and adds the first view to the menu layer.
 *
 * Formerly _F_y. Other former names: contextView = _fR_, injector = _O_R_,
 * signalCommandMap = _1G_, layers = _Q_l, mapModels = _A_v, mapSignalCommands = _ml,
 * mapServices = _T_u, mapSignals = _M_7, createLayersAndMapMediators = _xD_.
 *
 * NOTE: all mapped types come from other packages and keep their obfuscated names.
 * The names of the mapXxx() methods are guesses based on which package the mapped
 * types come from (_U_5 contains signals, for example); adjust them once those
 * packages are refactored. Also unchanged: the mediator mapper call _Y_u (to mediator)
 * and the root-package view class `projectblogo`.
 */
public class ApplicationConfig implements IConfig {

    [Inject]
    public var context:IContext;
    [Inject]
    public var contextView:DisplayObjectContainer;
    [Inject]
    public var injector:Injector;
    [Inject]
    public var signalCommandMap:ISignalCommandMap;
    [Inject]
    public var mediatorMap:IMediatorMap;

    private var layers:Layers;

    public function configure():void {
        this.mapModels();
        this.mapSignalCommands();
        this.mapServices();
        this.mapSignals();
        this.createLayersAndMapMediators();
        this.context.lifecycle.afterInitializing(this.init);
    }

    private function mapModels():void {
        this.injector.map(ClientEnv).asSingleton();
        this.injector.map(Deployment).asSingleton();
        this.injector.map(Domain).asSingleton();
        this.injector.map(ServerListState).asSingleton();
        this.injector.map(DeathRecord).asSingleton();
    }

    /**
     * Binds signals to the commands they trigger.
     * The analytics bindings are disabled; the commands are still imported
     * so they can simply be uncommented.
     */
    private function mapSignalCommands():void {
        this.signalCommandMap.map(_D_c, true).toCommand(AllowDomainsCommand);
        //this.signalCommandMap.map(_D_c, true).toCommand(InitAnalyticsCommand);
        //this.signalCommandMap.map(_7e).toCommand(TrackEventCommand);
        //this.signalCommandMap.map(_0_D_).toCommand(TrackPageViewCommand);
        this.signalCommandMap.map(_M_d).toCommand(EnableServerListCommand);
        this.signalCommandMap.map(_01W_).toCommand(ShowViewCommand);
        this.signalCommandMap.map(_06a).toCommand(RecordDeathCommand);
    }

    /**
     * _0D_5, _Y_p and _0F_A_ are not singletons: they get a new instance per request.
     */
    private function mapServices():void {
        this.injector.map(TaskTracker).asSingleton();
        this.injector.map(LoadCharacterListTask);
        this.injector.map(LoadFameTask);
        this.injector.map(DeleteCharacterTask);
        this.injector.map(AnalyticsTracker).asSingleton();
    }

    private function mapSignals():void {
        this.injector.map(_dd).asSingleton();
        this.injector.map(_6J_).asSingleton();
        this.injector.map(_0K_2).asSingleton();
        this.injector.map(_sC_).asSingleton();
        this.injector.map(_sT_).asSingleton();
        this.injector.map(_bo).asSingleton();
        this.injector.map(_zz).toValue(new _zz());
    }

    private function createLayersAndMapMediators():void {
        this.layers = new Layers();
        this.injector.map(Layers).toValue(this.layers);
        this.contextView.addChild(this.layers);
        this.mediatorMap.map(projectblogo).toMediator(UncaughtErrorMediator);
        this.mediatorMap.map(ScreensView).toMediator(ScreensViewMediator);
    }

    private function init():void {
        this.mediatorMap.mediate(this.contextView);
        this.layers.menu.addChild(new ScreensView());
    }

}
}
