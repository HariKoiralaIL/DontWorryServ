package robotlegs.bender.extensions.eventManagement.api {
import flash.events.IEventDispatcher;

/** Keeps track of event listeners so they can be removed together, or paused and resumed. */
public interface IEventMap {

    function mapListener(dispatcher:IEventDispatcher, eventType:String, listener:Function, eventClass:Class = null, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true):void;

    function unmapListener(dispatcher:IEventDispatcher, eventType:String, listener:Function, eventClass:Class = null, useCapture:Boolean = false):void;

    function unmapListeners():void;

    function suspend():void;

    function resume():void;

}
}//package robotlegs.bender.extensions.eventManagement.api
