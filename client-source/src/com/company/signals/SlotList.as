package com.company.signals {
public final class SlotList {

    public static const NIL:SlotList = new SlotList(null, null);

    public var head:ISlot;
    public var tail:SlotList;
    public var nonEmpty:Boolean = false;

    public function SlotList(head:ISlot, tail:SlotList = null) {
        if (!head && !tail) {
            if (NIL) {
                throw new ArgumentError("Parameters head and tail are null. Use the NIL element instead.");
            }
            this.nonEmpty = false;
        } else {
            if (!head) {
                throw new ArgumentError("Parameter head cannot be null.");
            }
            this.head = head;
            this.tail = tail || NIL;
            this.nonEmpty = true;
        }
    }

    public function get length():uint {
        if (!this.nonEmpty) {
            return 0;
        }
        if (this.tail == NIL) {
            return 1;
        }
        var count:uint = 0;
        var p:SlotList = this;
        while (p.nonEmpty) {
            count++;
            p = p.tail;
        }
        return count;
    }

    public function prepend(slot:ISlot):SlotList {
        return new SlotList(slot, this);
    }

    public function append(slot:ISlot):SlotList {
        if (!slot) {
            return this;
        }
        if (!this.nonEmpty) {
            return new SlotList(slot);
        }
        if (this.tail == NIL) {
            return new SlotList(slot).prepend(this.head);
        }
        var wholeClone:SlotList = new SlotList(this.head);
        var subClone:SlotList = wholeClone;
        var current:SlotList = this.tail;
        while (current.nonEmpty) {
            subClone = (subClone.tail = new SlotList(current.head));
            current = current.tail;
        }
        subClone.tail = new SlotList(slot);
        return wholeClone;
    }

    public function insertWithPriority(slot:ISlot):SlotList {
        if (!this.nonEmpty) {
            return new SlotList(slot);
        }
        var priority:int = slot.priority;
        if (priority > this.head.priority) {
            return this.prepend(slot);
        }
        var wholeClone:SlotList = new SlotList(this.head);
        var subClone:SlotList = wholeClone;
        var current:SlotList = this.tail;
        while (current.nonEmpty) {
            if (priority > current.head.priority) {
                subClone.tail = current.prepend(slot);
                return wholeClone;
            }
            subClone = (subClone.tail = new SlotList(current.head));
            current = current.tail;
        }
        subClone.tail = new SlotList(slot);
        return wholeClone;
    }

    public function filterNot(listener:Function):SlotList {
        if (!this.nonEmpty || listener == null) {
            return this;
        }
        if (listener == this.head.listener) {
            return this.tail;
        }
        var wholeClone:SlotList = new SlotList(this.head);
        var subClone:SlotList = wholeClone;
        var current:SlotList = this.tail;
        while (current.nonEmpty) {
            if (current.head.listener == listener) {
                subClone.tail = current.tail;
                return wholeClone;
            }
            subClone = (subClone.tail = new SlotList(current.head));
            current = current.tail;
        }
        return this;
    }

    public function contains(listener:Function):Boolean {
        if (!this.nonEmpty) {
            return false;
        }
        var p:SlotList = this;
        while (p.nonEmpty) {
            if (p.head.listener == listener) {
                return true;
            }
            p = p.tail;
        }
        return false;
    }

    public function find(listener:Function):ISlot {
        if (!this.nonEmpty) {
            return null;
        }
        var p:SlotList = this;
        while (p.nonEmpty) {
            if (p.head.listener == listener) {
                return p.head;
            }
            p = p.tail;
        }
        return null;
    }

    public function toString():String {
        var s:String = "";
        var p:SlotList = this;
        while (p.nonEmpty) {
            s += p.head + " -> ";
            p = p.tail;
        }
        s += "NIL";
        return "[List " + s + "]";
    }

}
}
