package mediators.impl {
import mediators.IMediatorFactory;
import mediators.IMediatorMapping;
import mediators.MediatorFactoryEvent;

import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import injection.Injector;

import matching.ITypeFilter;

import robotlegs.bender.framework.impl.guardsApprove;
import robotlegs.bender.framework.impl.applyHooks;

public class MediatorFactory extends EventDispatcher implements IMediatorFactory {

    // item -> (mapping -> mediator)
    private const _mediators:Dictionary = new Dictionary();
    private var _injector:Injector;

    public function MediatorFactory(injector:Injector) {
        _injector = injector;
    }

    public function getMediator(item:Object, mapping:IMediatorMapping):Object {
        return _mediators[item] ? _mediators[item][mapping] : null;
    }

    public function createMediators(item:Object, type:Class, mappings:Array):Array {
        var filter:ITypeFilter;
        var mediator:Object;
        var mapping:IMediatorMapping;
        var created:Array = [];
        for each (mapping in mappings) {
            mediator = getMediator(item, mapping);
            if (!mediator) {
                filter = mapping.matcher;
                mapMatchedTypes(filter, type, item);
                mediator = createMediator(item, mapping);
                unmapMatchedTypes(filter, type, item);
            }
            if (mediator) {
                created.push(mediator);
            }
        }
        return created;
    }

    public function removeMediators(item:Object):void {
        var key:Object;
        var itemMediators:Dictionary = _mediators[item];
        if (!itemMediators) {
            return;
        }
        if (hasEventListener(MediatorFactoryEvent.MEDIATOR_REMOVE)) {
            for (key in itemMediators) {
                dispatchEvent(new MediatorFactoryEvent(MediatorFactoryEvent.MEDIATOR_REMOVE, itemMediators[key], item, key as IMediatorMapping, this));
            }
        }
        delete _mediators[item];
    }

    public function removeAllMediators():void {
        var item:Object;
        for (item in _mediators) {
            removeMediators(item);
        }
    }

    private function createMediator(item:Object, mapping:IMediatorMapping):Object {
        var mediator:Object = getMediator(item, mapping);
        if (mediator) {
            return mediator;
        }
        if (guardsApprove(mapping.guards, _injector)) {
            mediator = _injector.getInstance(mapping.mediatorClass);
            _injector.map(mapping.mediatorClass).toValue(mediator);
            applyHooks(mapping.hooks, _injector);
            _injector.unmap(mapping.mediatorClass);
            addMediator(mediator, item, mapping);
        }
        return mediator;
    }

    private function addMediator(mediator:Object, item:Object, mapping:IMediatorMapping):void {
        _mediators[item] = _mediators[item] || new Dictionary();
        _mediators[item][mapping] = mediator;
        if (hasEventListener(MediatorFactoryEvent.MEDIATOR_CREATE)) {
            dispatchEvent(new MediatorFactoryEvent(MediatorFactoryEvent.MEDIATOR_CREATE, mediator, item, mapping, this));
        }
    }

    private function mapMatchedTypes(filter:ITypeFilter, type:Class, item:Object):void {
        var matchedType:Class;
        for each (matchedType in requiredTypes(filter, type)) {
            _injector.map(matchedType).toValue(item);
        }
    }

    private function unmapMatchedTypes(filter:ITypeFilter, type:Class, item:Object):void {
        var matchedType:Class;
        for each (matchedType in requiredTypes(filter, type)) {
            if (_injector.satisfiesDirectly(matchedType)) {
                _injector.unmap(matchedType);
            }
        }
    }

    private function requiredTypes(filter:ITypeFilter, type:Class):Vector.<Class> {
        var types:Vector.<Class> = filter.allOfTypes.concat(filter.anyOfTypes);
        if (types.indexOf(type) == -1) {
            types.push(type);
        }
        return types;
    }

}
}
