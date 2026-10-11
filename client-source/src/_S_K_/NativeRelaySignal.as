package _S_K_ {
import signals.SlotList;

import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.utils.getQualifiedClassName;

// Formerly _u3. A NativeSignal that "relays" a native event: instead of passing the Event
// itself to listeners, it passes values produced by a mapping function (see mapTo()) and
// type-checks them against valueClasses.
public class NativeRelaySignal extends NativeSignal {

    private var mappingFunction_:Function = null;   // formerly _I_

    public function NativeRelaySignal(target:IEventDispatcher, eventType:String, eventClass:Class = null, ...valueClasses) {
        super(target, eventType, eventClass);
        this.valueClasses = valueClasses;
    }

    override public function get eventClass():Class {
        return eventClass_;
    }

    override public function set eventClass(value:Class):void {
        eventClass_ = value;
    }

    override public function set valueClasses(classes:Array):void {
        _valueClasses = classes ? classes.slice() : [];
        var i:int = _valueClasses.length;
        while (i--) {
            if (!(_valueClasses[i] is Class)) {
                throw new ArgumentError("Invalid valueClasses argument: item at index " + i
                    + " should be a Class but was:<" + _valueClasses[i] + ">." + getQualifiedClassName(_valueClasses[i]));
            }
        }
    }

    // formerly _oS_
    protected function get mappingFunction():Function {
        return this.mappingFunction_;
    }

    // Sets how an event is turned into listener arguments: either a function taking zero
    // or one Event argument, or a fixed list of values.
    public function mapTo(...objectListOrFunction):NativeRelaySignal {
        if (objectListOrFunction.length == 1 && objectListOrFunction[0] is Function) {
            this.mappingFunction_ = objectListOrFunction[0] as Function;
            if (this.mappingFunction_.length > 1) {
                throw new ArgumentError("Mapping function has " + this.mappingFunction_.length
                    + " arguments but it needs zero or one of type Event");
            }
        } else {
            this.mappingFunction_ = function():Object {
                return objectListOrFunction;
            };
        }
        return this;
    }

    override public function dispatchEvent(event:Event):Boolean {
        var mapped:Object = this.mapEvent(event);
        var count:int = valueClasses.length;
        if (mapped is Array) {
            var values:Array = mapped as Array;
            for (var i:int = 0; i < count; i++) {
                var value:Object = values[i];
                var valueClass:Class = valueClasses[i];
                if (!(value === null || value is valueClass)) {
                    throw new ArgumentError("Value object <" + value + "> is not an instance of <" + valueClass + ">.");
                }
            }
        } else {
            if (count > 1) {
                throw new ArgumentError("Expected more than one value.");
            }
            if (!(mapped is valueClasses[0])) {
                throw new ArgumentError("Mapping returned " + getQualifiedClassName(mapped) + ", expected " + valueClasses[0] + ".");
            }
        }
        return super.dispatchEvent(event);
    }

    override protected function onNativeEvent(event:Event):void {
        var mapped:Object = this.mapEvent(event);
        var node:SlotList = slots;
        if (mapped is Array) {
            if (valueClasses.length == 1 && valueClasses[0] == Array) {
                // The single expected value is itself an Array: pass it as one argument.
                while (node.nonEmpty) {
                    node.head.execute1(mapped);
                    node = node.tail;
                }
            } else {
                var values:Array = mapped as Array;
                while (node.nonEmpty) {
                    node.head.execute(values);
                    node = node.tail;
                }
            }
        } else {
            while (node.nonEmpty) {
                node.head.execute1(mapped);
                node = node.tail;
            }
        }
    }

    // formerly _0o
    protected function mapEvent(event:Event):Object {
        if (this.mappingFunction != null) {
            if (this.mappingFunction.length == 1) {
                return this.mappingFunction(event);
            }
            return this.mappingFunction();
        }
        if (valueClasses.length == 0) {
            return [];
        }
        throw new ArgumentError("There are valueClasses set to be dispatched <" + valueClasses
            + "> but mappingFunction is null.");
    }
}
}
