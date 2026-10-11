package mediators.impl {
import mediators.IMediatorViewHandler;
import mediators.IMediatorFactory;
import mediators.IMediatorMapping;

import flash.utils.Dictionary;
import flash.display.DisplayObject;

public class MediatorViewHandler implements IMediatorViewHandler {

    private const _mappings:Array = [];
    // item type -> matching mappings, or false when nothing matches (weak keys)
    private var _knownMappings:Dictionary = new Dictionary(true);
    private var _factory:IMediatorFactory;

    public function MediatorViewHandler(factory:IMediatorFactory) {
        _factory = factory;
    }

    public function addMapping(mapping:IMediatorMapping):void {
        if (_mappings.indexOf(mapping) > -1) {
            return;
        }
        _mappings.push(mapping);
        flushCache();
    }

    public function removeMapping(mapping:IMediatorMapping):void {
        var index:int = _mappings.indexOf(mapping);
        if (index == -1) {
            return;
        }
        _mappings.splice(index, 1);
        flushCache();
    }

    public function handleView(view:DisplayObject, type:Class):void {
        handleItem(view, type);
    }

    public function handleItem(item:Object, type:Class):void {
        var mappings:Array = getMappings(item, type);
        if (mappings) {
            _factory.createMediators(item, type, mappings);
        }
    }

    private function flushCache():void {
        _knownMappings = new Dictionary(true);
    }

    private function getMappings(item:Object, type:Class):Array {
        var mapping:IMediatorMapping;
        if (_knownMappings[type] === false) {
            return null;
        }
        if (_knownMappings[type] == undefined) {
            _knownMappings[type] = false;
            for each (mapping in _mappings) {
                mapping.validate();
                if (mapping.matcher.matches(item)) {
                    _knownMappings[type] = _knownMappings[type] || [];
                    _knownMappings[type].push(mapping);
                }
            }
            if (_knownMappings[type] === false) {
                return null;
            }
        }
        return _knownMappings[type] as Array;
    }

}
}
