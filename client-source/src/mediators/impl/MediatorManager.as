package mediators.impl {
import mediators.IMediatorFactory;
import mediators.MediatorFactoryEvent;

import flash.utils.getDefinitionByName;
import flash.display.DisplayObject;
import flash.events.Event;

public class MediatorManager {

    private static const FLEX_AVAILABLE:Boolean = detectFlex();
    private static var UIComponentClass:Class;

    private static function detectFlex():Boolean {
        try {
            UIComponentClass = getDefinitionByName("mx.core::UIComponent") as Class;
        } catch (error:Error) {
        }
        return UIComponentClass != null;
    }

    private var _factory:IMediatorFactory;

    public function MediatorManager(factory:IMediatorFactory) {
        _factory = factory;
        _factory.addEventListener(MediatorFactoryEvent.MEDIATOR_CREATE, onMediatorCreate);
        _factory.addEventListener(MediatorFactoryEvent.MEDIATOR_REMOVE, onMediatorRemove);
    }

    private function initializeMediator(view:Object, mediator:Object):void {
        if (mediator.hasOwnProperty("viewComponent")) {
            mediator.viewComponent = view;
        }
        if (mediator.hasOwnProperty("initialize")) {
            mediator.initialize();
        }
    }

    private function destroyMediator(mediator:Object):void {
        if (mediator.hasOwnProperty("destroy")) {
            mediator.destroy();
        }
    }

    private function onMediatorCreate(event:MediatorFactoryEvent):void {
        var mediator:Object = event.mediator;
        var displayObject:DisplayObject = event.view as DisplayObject;
        if (!displayObject) {
            initializeMediator(event.view, mediator);
            return;
        }
        displayObject.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        if (FLEX_AVAILABLE && displayObject is UIComponentClass && !displayObject["initialized"]) {
            displayObject.addEventListener("creationComplete", function (e:Event):void {
                displayObject.removeEventListener("creationComplete", arguments.callee);
                if (_factory.getMediator(displayObject, event.mapping)) {
                    initializeMediator(displayObject, mediator);
                }
            });
        } else {
            initializeMediator(displayObject, mediator);
        }
    }

    private function onMediatorRemove(event:MediatorFactoryEvent):void {
        var displayObject:DisplayObject = event.view as DisplayObject;
        if (displayObject) {
            displayObject.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        }
        if (event.mediator) {
            destroyMediator(event.mediator);
        }
    }

    private function onRemovedFromStage(event:Event):void {
        _factory.removeMediators(event.target);
    }

}
}
