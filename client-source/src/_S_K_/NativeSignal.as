package _S_K_ {
    import signals.Slot;
    import signals.SlotList;
    import signals.Signal;
    import signals.ISlot;
    import signals.IPrioritySignal;

    import flash.events.Event;
    import flash.events.IEventDispatcher;

// Formerly _u1. A signal that wraps one native Flash event on an IEventDispatcher:
// adding a listener to the signal adds a native listener to the target (once the first
// listener is added), and removing the last one removes it again.
    public class NativeSignal extends Signal implements INativeDispatcher, IPrioritySignal {

        protected var target_:IEventDispatcher;     // formerly _R_d
        protected var eventType_:String;            // formerly _bC_
        protected var eventClass_:Class;            // formerly _1j

        public function NativeSignal(target:IEventDispatcher, eventType:String, eventClass:Class = null) {
            super(eventClass || Event);
            this.eventType = eventType;
            this.eventClass = eventClass;
            this.target = target;
        }

        override public function set valueClasses(classes:Array):void {
            this.eventClass = (classes && classes.length > 0) ? classes[0] : null;
        }

        public function get target():IEventDispatcher {
            return this.target_;
        }

        public function set target(value:IEventDispatcher):void {
            if (value == this.target_) {
                return;
            }
            if (this.target_) {
                this.removeAll();
            }
            this.target_ = value;
        }

        // formerly _S_b
        public function get eventType():String {
            return this.eventType_;
        }

        public function set eventType(value:String):void {
            this.eventType_ = value;
        }

        public function get eventClass():Class {
            return this.eventClass_;
        }

        public function set eventClass(value:Class):void {
            this.eventClass_ = value || Event;
            _valueClasses = [this.eventClass_];
        }

        override public function add(listener:Function):ISlot {
            return this.addWithPriority(listener);
        }

        override public function addOnce(listener:Function):ISlot {
            return this.addOnceWithPriority(listener);
        }

        override public function remove(listener:Function):ISlot {
            var wasNonEmpty:Boolean = slots.nonEmpty;
            var slot:ISlot = super.remove(listener);
            if (wasNonEmpty != slots.nonEmpty) {
                this.target.removeEventListener(this.eventType, this.onNativeEvent);
            }
            return slot;
        }

        override public function removeAll():void {
            if (this.target) {
                this.target.removeEventListener(this.eventType, this.onNativeEvent);
            }
            super.removeAll();
        }

        override public function dispatch(...args):void {
            if (null == args) {
                throw new ArgumentError("Event object expected.");
            }
            if (args.length != 1) {
                throw new ArgumentError("No more than one Event object expected.");
            }
            this.dispatchEvent(args[0] as Event);
        }

        // formerly _z
        public function addWithPriority(listener:Function, priority:int = 0):ISlot {
            return this.registerListenerWithPriority(listener, false, priority);
        }

        // formerly _J_E_
        public function addOnceWithPriority(listener:Function, priority:int = 0):ISlot {
            return this.registerListenerWithPriority(listener, true, priority);
        }

        // formerly _0C_w; renamed so it no longer collides with OnceSignal.registerListener
        protected function registerListenerWithPriority(listener:Function, once:Boolean = false, priority:int = 0):ISlot {
            if (!this.target) {
                throw new ArgumentError("Target object cannot be null.");
            }
            var wasNonEmpty:Boolean = slots.nonEmpty;
            var slot:ISlot;
            if (registrationPossible(listener, once)) {
                slot = new Slot(listener, this, once, priority);
                slots = slots.insertWithPriority(slot);
            } else {
                slot = slots.find(listener);
            }
            if (wasNonEmpty != slots.nonEmpty) {
                this.target.addEventListener(this.eventType, this.onNativeEvent, false, priority);
            }
            return slot;
        }

        public function dispatchEvent(event:Event):Boolean {
            if (!this.target) {
                throw new ArgumentError("Target object cannot be null.");
            }
            if (!event) {
                throw new ArgumentError("Event object cannot be null.");
            }
            if (!(event is this.eventClass)) {
                throw new ArgumentError("Event object " + event + " is not an instance of " + this.eventClass + ".");
            }
            if (event.type != this.eventType) {
                throw new ArgumentError("Event object has incorrect type. Expected <" + this.eventType + "> but was <" + event.type + ">.");
            }
            return this.target.dispatchEvent(event);
        }

        protected function onNativeEvent(event:Event):void {
            var node:SlotList = slots;
            while (node.nonEmpty) {
                node.head.execute1(event);
                node = node.tail;
            }
        }
    }
}
