package com.company.signals {
public interface ISignal extends IOnceSignal {

    function add(listener:Function):ISlot;

}
}
