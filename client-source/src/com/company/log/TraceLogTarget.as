package com.company.log {
import robotlegs.bender.framework.api.LogLevel;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.ILogTarget;

// Formerly _4A_. A log target that writes each entry to trace() as:
//   <timestamp> <level name> <context> <source> - <formatted message>
//
// NOTE: _fq (the log-target interface), _L_y (the context type) and _C_P_ (the level
// names) come from package _0_p and keep their obfuscated names until that is refactored.
public class TraceLogTarget implements ILogTarget {

    private const formatter_:LogMessageFormatter = new LogMessageFormatter();   // formerly _Z_p
    private var context_:IContext;                                                 // formerly _rA_

    public function TraceLogTarget(context:IContext) {
        this.context_ = context;
    }

    public function log(source:Object, level:uint, timestamp:int, message:String, params:Array = null):void {
        trace(timestamp + " " + LogLevel.NAME[level] + " " + this.context_ + " " + source + " - "
            + this.formatter_.format(message, params));
    }
}
}
