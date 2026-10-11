package signalcommands {
import commandmap.ISignalCommandMap;

import commands.ICommandTrigger;
import commands.ICommandCenter;

import injection.Injector;

import commands.ICommandMapper;
import commands.ICommandUnmapper;

import flash.utils.Dictionary;

// Formerly _T_7. Maps signal classes to commands: map(SomeSignal) returns the usual
// command mapper, backed by one SignalCommandTrigger per signal class.
//
// NOTE: _U_A_ (the interface), _F_B_ (command map), _08b (injector), _00J_ (trigger), _00d /
// _06n (mapper / unmapper) come from other packages. map() and _1Y_() implement _U_A_
// (_1Y_ means unmap) and must keep their names until that interface is refactored.
public class SignalCommandMap implements ISignalCommandMap {

    private const triggers_:Dictionary = new Dictionary();   // formerly _2I_: signal class -> trigger

    private var injector_:Injector;        // formerly _vz
    private var commandMap_:ICommandCenter;     // formerly _4U_

    public function SignalCommandMap(injector:Injector, commandMap:ICommandCenter) {
        this.injector_ = injector;
        this.commandMap_ = commandMap;
    }

    public function map(signalClass:Class, once:Boolean = false):ICommandMapper {
        var trigger:ICommandTrigger = (this.triggers_[signalClass] = (this.triggers_[signalClass] || this.createTrigger(signalClass, once)));
        return this.commandMap_.map(trigger);
    }

    // Meaning: unmap. Name required by _U_A_ for now.
    public function unmap(signalClass:Class):ICommandUnmapper {
        return this.commandMap_.unmap(this.getTrigger(signalClass));
    }

    // formerly _F_q
    private function createTrigger(signalClass:Class, once:Boolean = false):ICommandTrigger {
        return new SignalCommandTrigger(this.injector_, signalClass, once);
    }

    // formerly _8R_
    private function getTrigger(signalClass:Class):ICommandTrigger {
        return this.triggers_[signalClass];
    }
}
}
