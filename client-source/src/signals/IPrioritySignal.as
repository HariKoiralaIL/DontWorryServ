package signals {
public interface IPrioritySignal extends ISignal {

    function addWithPriority(listener:Function, priority:int = 0):ISlot;

    function addOnceWithPriority(listener:Function, priority:int = 0):ISlot;

}
}
