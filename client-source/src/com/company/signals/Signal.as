package com.company.signals {
public class Signal extends OnceSignal implements ISignal {

    public function Signal(...valueClasses) {
        valueClasses = (valueClasses.length == 1 && valueClasses[0] is Array) ? valueClasses[0] : valueClasses;
        super(valueClasses);
    }

    public function add(listener:Function):ISlot {
        return registerListener(listener);
    }

}
}
