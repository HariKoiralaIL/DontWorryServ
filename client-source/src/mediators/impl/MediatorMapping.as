package mediators.impl {
import mediators.IMediatorMapping;
import mediators.IMediatorMappingConfig;

import robotlegs.bender.framework.impl.MappingConfigValidator;

import matching.ITypeFilter;

public class MediatorMapping implements IMediatorMapping, IMediatorMappingConfig {

    private var _validator:MappingConfigValidator;
    private var _matcher:ITypeFilter;
    private var _mediatorClass:Class;
    private var _guards:Array = [];
    private var _hooks:Array = [];

    public function MediatorMapping(matcher:ITypeFilter, mediatorClass:Class) {
        _matcher = matcher;
        _mediatorClass = mediatorClass;
    }

    public function get matcher():ITypeFilter {
        return _matcher;
    }

    public function get mediatorClass():Class {
        return _mediatorClass;
    }

    public function get guards():Array {
        return _guards;
    }

    public function get hooks():Array {
        return _hooks;
    }

    public function withGuards(... guards):IMediatorMappingConfig {
        _validator && _validator.checkGuards(guards);
        _guards = _guards.concat.apply(null, guards);
        return this;
    }

    public function withHooks(... hooks):IMediatorMappingConfig {
        _validator && _validator.checkHooks(hooks);
        _hooks = _hooks.concat.apply(null, hooks);
        return this;
    }

    public function validate():void {
        if (!_validator) {
            createValidator();
        } else if (!_validator.valid) {
            _validator.validate(_guards, _hooks);
        }
    }

    internal function invalidate():void {
        if (_validator) {
            _validator.invalidate();
        } else {
            createValidator();
        }
        _guards = [];
        _hooks = [];
    }

    private function createValidator():void {
        _validator = new MappingConfigValidator(_guards.slice(), _hooks.slice(), _matcher, _mediatorClass);
    }

}
}
