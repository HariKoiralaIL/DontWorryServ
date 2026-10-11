package com.company.signals {
import flash.utils.getQualifiedClassName;
import flash.errors.IllegalOperationError;

public class OnceSignal implements IOnceSignal {

    protected var _valueClasses:Array;
    protected var slots:SlotList;

    public function OnceSignal(...valueClasses) {
        this.slots = SlotList.NIL;
        super();
        this.valueClasses = (valueClasses.length == 1 && valueClasses[0] is Array) ? valueClasses[0] : valueClasses;
    }

    public function get valueClasses():Array {
        return this._valueClasses;
    }

    public function set valueClasses(value:Array):void {
        this._valueClasses = value ? value.slice() : [];
        var i:int = this._valueClasses.length;
        while (i--) {
            if (!(this._valueClasses[i] is Class)) {
                throw new ArgumentError("Invalid valueClasses argument: item at index " + i
                    + " should be a Class but was:<" + this._valueClasses[i] + ">."
                    + getQualifiedClassName(this._valueClasses[i]));
            }
        }
    }

    public function get numListeners():uint {
        return this.slots.length;
    }

    public function addOnce(listener:Function):ISlot {
        return this.registerListener(listener, true);
    }

    public function remove(listener:Function):ISlot {
        var slot:ISlot = this.slots.find(listener);
        if (!slot) {
            return null;
        }
        this.slots = this.slots.filterNot(listener);
        return slot;
    }

    public function removeAll():void {
        this.slots = SlotList.NIL;
    }

    public function dispatch(...valueObjects):void {
        var numValueClasses:int = this._valueClasses.length;
        var numValueObjects:int = valueObjects.length;
        if (numValueObjects < numValueClasses) {
            throw new ArgumentError("Incorrect number of arguments. Expected at least "
                + numValueClasses + " but received " + numValueObjects + ".");
        }
        var i:int = 0;
        while (i < numValueClasses) {
            if (!(valueObjects[i] is this._valueClasses[i] || valueObjects[i] === null)) {
                throw new ArgumentError("Value object <" + valueObjects[i]
                    + "> is not an instance of <" + this._valueClasses[i] + ">.");
            }
            i++;
        }
        var slotsToProcess:SlotList = this.slots;
        if (slotsToProcess.nonEmpty) {
            while (slotsToProcess.nonEmpty) {
                slotsToProcess.head.execute(valueObjects);
                slotsToProcess = slotsToProcess.tail;
            }
        }
    }

    protected function registerListener(listener:Function, once:Boolean = false):ISlot {
        var slot:ISlot;
        if (this.registrationPossible(listener, once)) {
            slot = new Slot(listener, this, once);
            this.slots = this.slots.prepend(slot);
            return slot;
        }
        return this.slots.find(listener);
    }

    protected function registrationPossible(listener:Function, once:Boolean):Boolean {
        if (!this.slots.nonEmpty) {
            return true;
        }
        var existing:ISlot = this.slots.find(listener);
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
