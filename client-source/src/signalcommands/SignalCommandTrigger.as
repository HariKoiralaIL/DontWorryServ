package signalcommands {
import robotlegs.bender.framework.impl.applyHooks;
import robotlegs.bender.framework.impl.guardsApprove;

import commands.ICommandTrigger;
import commands.ICommandMapping;

import injection.Injector;

import signals.ISignal;

import flash.utils.Dictionary;
import flash.utils.describeType;

// Formerly _02O_. A command trigger driven by a signal: when the signal dispatches, every
// mapped command whose guards approve is created through the injector, has its hooks
// applied, and is executed with the signal's values injected. If `once` is set, each
// mapping (and the signal listener) is removed after the first dispatch.
//
// NOTE: _00J_ (trigger interface), _K_T_ (command mapping, with commandClass, _0_R_ = guards
// and _7w = hooks), _08b (injector), _08P_ (signal), and the injector's _1Y_ (unmap) come
// from other packages. _J_w and _0A_W_ implement _00J_ (they mean addMapping / removeMapping)
// and must keep their names until that interface is refactored.
public class SignalCommandTrigger implements ICommandTrigger {

    private const mappings_:Vector.<ICommandMapping> = new Vector.<ICommandMapping>();   // formerly _0K_E_

    protected var injector_:Injector;                        // formerly _vz
    protected var signalCommandMap_:Dictionary;          // formerly _T_Z_: signal -> (commandClass -> listener)
    protected var verifiedCommandClasses_:Dictionary;    // formerly _0G_i
    private var signal_:ISignal;
    private var signalClass_:Class;                      // formerly _6I_
    private var once_:Boolean;

    public function SignalCommandTrigger(injector:Injector, signalClass:Class, once:Boolean = false) {
        this.injector_ = injector;
        this.signalClass_ = signalClass;
        this.once_ = once;
        this.signalCommandMap_ = new Dictionary(false);
        this.verifiedCommandClasses_ = new Dictionary(false);
    }

    // Meaning: addMapping. Name required by _00J_ for now.
    public function addMapping(mapping:ICommandMapping):void {
        this.verifyCommandClass(mapping);
        this.mappings_.push(mapping);
        if (this.mappings_.length == 1) {
            this.addSignal(mapping.commandClass);
        }
    }

    // Meaning: removeMapping. Name required by _00J_ for now.
    public function removeMapping(mapping:ICommandMapping):void {
        var index:int = this.mappings_.indexOf(mapping);
        if (index != -1) {
            this.mappings_.splice(index, 1);
            if (this.mappings_.length == 0) {
                this.removeSignal(mapping.commandClass);
            }
        }
    }

    // formerly _b4: commands must have an execute() method.
    protected function verifyCommandClass(mapping:ICommandMapping):void {
        if (this.verifiedCommandClasses_[mapping.commandClass]) {
            return;
        }
        if (describeType(mapping.commandClass).factory.method.(@name == "execute").length() == 0) {
            throw new Error("Command Class must expose an execute method");
        }
        this.verifiedCommandClasses_[mapping.commandClass] = true;
    }

    // formerly _wJ_: runs every approved command for one signal dispatch.
    protected function routeSignalToCommand(signal:ISignal, valueObjects:Array, commandClass:Class, once:Boolean):void {
        var mapping:ICommandMapping;
        var command:Object;
        var snapshot:Vector.<ICommandMapping> = this.mappings_.concat();
        for each (mapping in snapshot) {
            if (guardsApprove(mapping.guards, this.injector_)) {
                if (this.once_) {
                    this.removeMapping(mapping);
                }
                this.injector_.map(mapping.commandClass).asSingleton();
                command = this.createCommandInstance(signal.valueClasses, valueObjects, mapping.commandClass);
                applyHooks(mapping.hooks, this.injector_);
                this.injector_.unmap(mapping.commandClass);
                command.execute();
                this.unmapSignalValues(signal.valueClasses, valueObjects);
            }
        }
        if (this.once_) {
            this.removeSignal(commandClass);
        }
    }

    // formerly _yB_: makes the signal's values injectable by type.
    protected function mapSignalValues(valueClasses:Array, valueObjects:Array):void {
        for (var i:uint = 0; i < valueClasses.length; i++) {
            this.injector_.map(valueClasses[i]).toValue(valueObjects[i]);
        }
    }

    // formerly _5v (valueObjects is unused, as in the original)
    protected function unmapSignalValues(valueClasses:Array, valueObjects:Array):void {
        for (var i:uint = 0; i < valueClasses.length; i++) {
            this.injector_.unmap(valueClasses[i]);
        }
    }

    // formerly _Y_
    protected function createCommandInstance(valueClasses:Array, valueObjects:Array, commandClass:Class):Object {
        this.mapSignalValues(valueClasses, valueObjects);
        return this.injector_.getInstance(commandClass);
    }

    // formerly _T_z
    protected function hasSignalCommand(signal:ISignal, commandClass:Class):Boolean {
        var listeners:Dictionary = this.signalCommandMap_[signal];
        if (listeners == null) {
            return false;
        }
        return listeners[commandClass] != null;
    }

    // formerly _0H_z: creates the signal and starts listening to it.
    private function addSignal(commandClass:Class):void {
        if (this.hasSignalCommand(this.signal_, commandClass)) {
            return;
        }
        this.signal_ = this.injector_.getInstance(this.signalClass_);
        this.injector_.map(this.signalClass_).toValue(this.signal_);
        var listeners:Dictionary = (this.signalCommandMap_[this.signal_] = (this.signalCommandMap_[this.signal_] || new Dictionary(false)));
        var listener:Function = function():void {
            routeSignalToCommand(signal_, arguments, commandClass, once_);
        };
        listeners[commandClass] = listener;
        this.signal_.add(listener);
    }

    // formerly _C_y
    private function removeSignal(commandClass:Class):void {
        var listeners:Dictionary = this.signalCommandMap_[this.signal_];
        if (listeners == null) {
            return;
        }
        var listener:Function = listeners[commandClass];
        if (listener == null) {
            return;
        }
        this.signal_.remove(listener);
        delete listeners[commandClass];
    }
}
}
