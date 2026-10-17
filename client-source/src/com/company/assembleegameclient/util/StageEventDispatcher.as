package com.company.assembleegameclient.util {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.events.Event;
import flash.events.IEventDispatcher;

/** Forwards event dispatching and common stage operations to the stage of a given display object. */
public class StageEventDispatcher implements IEventDispatcher {

    protected var displayObject_:DisplayObject;

    public function StageEventDispatcher(displayObject:DisplayObject) {
        this.displayObject_ = displayObject;
    }

    public function getStage():DisplayObjectContainer {
        return this.displayObject_.stage;
    }

    public function getStageWidth():Number {
        return this.displayObject_.stage.stageWidth;
    }

    public function getStageHeight():Number {
        return this.displayObject_.stage.stageHeight;
    }

    public function getStageFocus():InteractiveObject {
        return this.displayObject_.stage.focus;
    }

    public function getStageQuality():String {
        return this.displayObject_.stage.quality;
    }

    public function setFocus(target:InteractiveObject):void {
        this.displayObject_.stage.focus = target;
    }

    public function setStageQuality(quality:String):void {
        this.displayObject_.stage.quality = quality;
    }

    public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
        this.displayObject_.stage.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }

    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
        this.displayObject_.stage.removeEventListener(type, listener, useCapture);
    }

    public function dispatchEvent(event:Event):Boolean {
        return this.displayObject_.stage.dispatchEvent(event);
    }

    public function hasEventListener(type:String):Boolean {
        return this.displayObject_.stage.hasEventListener(type);
    }

    public function willTrigger(type:String):Boolean {
        return this.displayObject_.stage.willTrigger(type);
    }

}
}
