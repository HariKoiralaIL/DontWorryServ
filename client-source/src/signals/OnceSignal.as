package signals {
import flash.errors.IllegalOperationError;
import flash.utils.getQualifiedClassName;

public class OnceSignal implements IOnceSignal {

    protected var _valueClasses:Array;
    protected var slots:SlotList;

    public function OnceSignal(...valueClasses) {
        slots = SlotList.NIL;
        super();
        this.valueClasses = (valueClasses.length == 1 && valueClasses[0] is Array) ? valueClasses[0] : valueClasses;
    }

    public function get valueClasses():Array {
        return _valueClasses;
    }

    public function set valueClasses(value:Array):void {
        _valueClasses = value ? value.slice() : [];
        var i:int = _valueClasses.length;
        while (i--) {
            if (!(_valueClasses[i] is Class)) {
                throw new ArgumentError("Invalid valueClasses argument: item at index " + i + " should be a Class but was:<" + _valueClasses[i] + ">." + getQualifiedClassName(_valueClasses[i]));
            }
        }
    }

    public function get numListeners():uint {
        return slots.length;
    }

    public function addOnce(listener:Function):ISlot {
        return registerListener(listener, true);
    }

    public function remove(listener:Function):ISlot {
        var slot:ISlot = slots.find(listener);
        if (!slot) {
            return null;
        }
        slots = slots.filterNot(listener);
        return slot;
    }

    public function removeAll():void {
        slots = SlotList.NIL;
    }

    public function dispatch(...valueObjects):void {
        var numClasses:int = _valueClasses.length;
        var numValues:int = valueObjects.length;
        if (numValues < numClasses) {
            throw new ArgumentError("Incorrect number of arguments. Expected at least " + numClasses + " but received " + numValues + ".");
        }
        var i:int = 0;
        while (i < numClasses) {
            if (!(valueObjects[i] is _valueClasses[i] || valueObjects[i] === null)) {
                throw new ArgumentError("Value object <" + valueObjects[i] + "> is not an instance of <" + _valueClasses[i] + ">.");
            }
            i++;
        }
        var node:SlotList = slots;
        if (node.nonEmpty) {
            while (node.nonEmpty) {
                node.head.execute(valueObjects);
                node = node.tail;
            }
        }
    }

    protected function registerListener(listener:Function, once:Boolean = false):ISlot {
        var slot:ISlot;
        if (registrationPossible(listener, once)) {
            slot = new Slot(listener, this, once);
            slots = slots.prepend(slot);
            return slot;
        }
        return slots.find(listener);
    }

    protected function registrationPossible(listener:Function, once:Boolean):Boolean {
        if (!slots.nonEmpty) {
            return true;
        }
        var existing:ISlot = slots.find(listener);
        if (!existing) {
            return true;
        }
        if (existing.once != once) {
            throw new IllegalOperationError("You cannot addOnce() then add() the same listener without removing the relationship first.");
        }
        return false;
    }

}
}
