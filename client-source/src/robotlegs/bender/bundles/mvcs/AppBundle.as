package robotlegs.bender.bundles.mvcs {

import robotlegs.bender.framework.api.IBundle;
import robotlegs.bender.framework.api.IContext;

import logging.LoggerProviderExtension;
import logging.TraceLoggingExtension;

import robotlegs.bender.extensions.contextView.ContextViewExtension;

import extensions.EventDispatcherExtension;

import robotlegs.bender.extensions.modularity.ModularityExtension;

import extensions.CommandMapExtension;

import commandextensions.EventCommandMapExtension;

import extensions.EventMapExtension;

import viewextensions.ViewManagerExtension;
import viewextensions.ManualStageObserverExtension;
import viewextensions.StageObserverExtension;

import robotlegs.bender.extensions.mediatorMap.MediatorMapExtension;

import stagesync.StageSyncExtension;

import contextview.ContextViewConfig;

/**
 * Bundle for the application context: installs the extensions the client
 * depends on, then applies the main config.
 *
 * Note: extend(...) and configure(...) are methods of the context type
 * (_L_y), so they keep their current names until that class is refactored.
 */
public class AppBundle implements IBundle {

    public function extend(context:IContext):void {
        context.extend(LoggerProviderExtension, TraceLoggingExtension, ContextViewExtension, EventDispatcherExtension, ModularityExtension, CommandMapExtension, EventCommandMapExtension, EventMapExtension, ViewManagerExtension, ManualStageObserverExtension, StageObserverExtension, MediatorMapExtension, StageSyncExtension);
        context.configure(ContextViewConfig);
    }

}
}//package robotlegs.bender.bundles.mvcs
