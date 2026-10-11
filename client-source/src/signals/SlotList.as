package signals {
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
            nonEmpty = false;
        } else {
            if (!head) {
                throw new ArgumentError("Parameter head cannot be null.");
            }
            this.head = head;
            this.tail = tail || NIL;
            nonEmpty = true;
        }
    }

    public function get length():uint {
        if (!nonEmpty) {
            return 0;
        }
        if (tail == NIL) {
            return 1;
        }
        var count:uint = 0;
        var node:SlotList = this;
        while (node.nonEmpty) {
            count++;
            node = node.tail;
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
        if (!nonEmpty) {
            return new SlotList(slot);
        }
        if (tail == NIL) {
            return new SlotList(slot).prepend(head);
        }
        var wholeClone:SlotList = new SlotList(head);
        var subClone:SlotList = wholeClone;
        var current:SlotList = tail;
        while (current.nonEmpty) {
            subClone = subClone.tail = new SlotList(current.head);
            current = current.tail;
        }
        subClone.tail = new SlotList(slot);
        return wholeClone;
    }

    public function insertWithPriority(slot:ISlot):SlotList {
        if (!nonEmpty) {
            return new SlotList(slot);
        }
        var priority:int = slot.priority;
        if (priority > head.priority) {
            return prepend(slot);
        }
        var wholeClone:SlotList = new SlotList(head);
        var subClone:SlotList = wholeClone;
        var current:SlotList = tail;
        while (current.nonEmpty) {
            if (priority > current.head.priority) {
                subClone.tail = current.prepend(slot);
                return wholeClone;
            }
            subClone = subClone.tail = new SlotList(current.head);
            current = current.tail;
        }
        subClone.tail = new SlotList(slot);
        return wholeClone;
    }

    public function filterNot(listener:Function):SlotList {
        if (!nonEmpty || listener == null) {
            return this;
        }
        if (listener == head.listener) {
            return tail;
        }
        var wholeClone:SlotList = new SlotList(head);
        var subClone:SlotList = wholeClone;
        var current:SlotList = tail;
        while (current.nonEmpty) {
            if (current.head.listener == listener) {
                subClone.tail = current.tail;
                return wholeClone;
            }
            subClone = subClone.tail = new SlotList(current.head);
            current = current.tail;
        }
        return this;
    }

    public function contains(listener:Function):Boolean {
        if (!nonEmpty) {
            return false;
        }
        var node:SlotList = this;
        while (node.nonEmpty) {
            if (node.head.listener == listener) {
                return true;
            }
            node = node.tail;
        }
        return false;
    }

    public function find(listener:Function):ISlot {
        if (!nonEmpty) {
            return null;
        }
        var node:SlotList = this;
        while (node.nonEmpty) {
            if (node.head.listener == listener) {
                return node.head;
            }
            node = node.tail;
        }
        return null;
    }

    public function toString():String {
        var s:String = "";
        var node:SlotList = this;
        while (node.nonEmpty) {
            s = s + (node.head + " -> ");
            node = node.tail;
        }
        s = s + "NIL";
        return "[List " + s + "]";
    }

}
}
