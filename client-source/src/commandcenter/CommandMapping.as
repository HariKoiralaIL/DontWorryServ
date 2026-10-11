package commandcenter {
import commands.ICommandMapping;
import commands.CommandMappingError;

import commands.ICommandMappingConfig;

import robotlegs.bender.framework.impl.MappingConfigValidator;

public class CommandMapping implements ICommandMapping, ICommandMappingConfig {

    private var _commandClass:Class;
    private var _guards:Array;
    private var _hooks:Array;
    private var _once:Boolean;
    private var _next:ICommandMapping;
    private var _validator:MappingConfigValidator;

    public function CommandMapping(commandClass:Class) {
        _guards = [];
        _hooks = [];
        super();
        _commandClass = commandClass;
    }

    public function get commandClass():Class {
        return _commandClass;
    }

    public function get guards():Array {
        return _guards;
    }

    public function get hooks():Array {
        return _hooks;
    }

    public function get fireOnce():Boolean {
        return _once;
    }

    public function get next():ICommandMapping {
        return _next;
    }

    public function set next(value:ICommandMapping):void {
        _next = value;
    }

    public function withGuards(...guards):ICommandMappingConfig {
        _validator && _validator.checkGuards(guards);
        _guards = _guards.concat.apply(null, guards);
        return this;
    }

    public function withHooks(...hooks):ICommandMappingConfig {
        _validator && _validator.checkHooks(hooks);
        _hooks = _hooks.concat.apply(null, hooks);
        return this;
    }

    public function once(value:Boolean = true):ICommandMappingConfig {
        if (_validator && !_once) {
            throwMappingError("You attempted to change an existing mapping for " + _commandClass + " by setting once(). Please unmap first.");
        }
        _once = value;
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

    private function throwMappingError(message:String):void {
        throw new CommandMappingError(message);
    }

    private function createValidator():void {
        _validator = new MappingConfigValidator(_guards.slice(), _hooks.slice(), null, _commandClass);
    }

}
}
