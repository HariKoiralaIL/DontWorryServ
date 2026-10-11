package mediators.impl {
import mediators.IMediatorMapper;
import mediators.IMediatorMappingFinder;
import mediators.IMediatorUnmapper;
import mediators.IMediatorViewHandler;
import mediators.IMediatorMappingConfig;
import mediators.IMediatorMapping;

import flash.utils.Dictionary;

import matching.ITypeFilter;

public class MediatorMapper implements IMediatorMapper, IMediatorMappingFinder, IMediatorUnmapper {

    private const _mappings:Dictionary = new Dictionary();
    private var _matcher:ITypeFilter;
    private var _handler:IMediatorViewHandler;

    public function MediatorMapper(matcher:ITypeFilter, handler:IMediatorViewHandler) {
        _matcher = matcher;
        _handler = handler;
    }

    public function toMediator(mediatorClass:Class):IMediatorMappingConfig {
        return reuseMapping(mediatorClass) || createMapping(mediatorClass);
    }

    public function forMediator(mediatorClass:Class):IMediatorMapping {
        return _mappings[mediatorClass];
    }

    public function fromMediator(mediatorClass:Class):void {
        var mapping:IMediatorMapping = _mappings[mediatorClass];
        delete _mappings[mediatorClass];
        _handler.removeMapping(mapping);
    }

    public function fromMediators():void {
        var mapping:IMediatorMapping;
        for each (mapping in _mappings) {
            delete _mappings[mapping.mediatorClass];
            _handler.removeMapping(mapping);
        }
    }

    private function createMapping(mediatorClass:Class):MediatorMapping {
        var mapping:MediatorMapping = new MediatorMapping(_matcher, mediatorClass);
        _handler.addMapping(mapping);
        _mappings[mediatorClass] = mapping;
        return mapping;
    }

    private function reuseMapping(mediatorClass:Class):MediatorMapping {
        var mapping:MediatorMapping = _mappings[mediatorClass];
        if (mapping) {
            mapping.invalidate();
        }
        return mapping;
    }

}
}
