package com.company.assembleegameclient.game {

import com.company.assembleegameclient.parameters.Parameters;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

/**
 * Idle watchdog. Resets on any mouse move / key press; warns the player at
 * 10 and 15 idle minutes and asks the caller to disconnect at 20.
 */
public class IdleWatcher {

    private static const MS_PER_MINUTE:int = 60 * 1000;
    private static const FIRST_WARNING_MINUTES:int = 10;
    private static const SECOND_WARNING_MINUTES:int = 15;
    private static const DISCONNECT_MINUTES:int = 20;

    public var gs_:GameSprite = null;
    /** Milliseconds idle so far. (Public, so the original name is kept.) */
    public var _78:int = 0;

    public function start(gameSprite:GameSprite):void {
        this.gs_ = gameSprite;
        this._78 = 0;
        this.gs_.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
        this.gs_.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
    }

    /** @return true when the player has been idle long enough to be disconnected. */
    public function update(elapsedMs:int):Boolean {
        var previous:int = this._78;
        this._78 += elapsedMs;
        if (this._78 < FIRST_WARNING_MINUTES * MS_PER_MINUTE) {
            return false;
        }
        if (this.justCrossed(previous, FIRST_WARNING_MINUTES)) {
            this.warn(FIRST_WARNING_MINUTES);
            return false;
        }
        if (this.justCrossed(previous, SECOND_WARNING_MINUTES)) {
            this.warn(SECOND_WARNING_MINUTES);
            return false;
        }
        if (this.justCrossed(previous, DISCONNECT_MINUTES)) {
            this.gs_.textBox_.addText(Parameters.SendError,
                "You have been idle for " + DISCONNECT_MINUTES + " minutes, disconnecting.");
            return true;
        }
        return false;
    }

    public function stop():void {
        this.gs_.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMove);
        this.gs_.stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDown);
        this.gs_ = null;
    }

    /** True only on the update where idle time passes the given threshold. */
    private function justCrossed(previousMs:int, minutes:int):Boolean {
        var thresholdMs:int = minutes * MS_PER_MINUTE;
        return this._78 >= thresholdMs && previousMs < thresholdMs;
    }

    private function warn(idleMinutes:int):void {
        this.gs_.textBox_.addText(Parameters.SendError,
            "You have been idle for " + idleMinutes + " minutes, you will disconnected if you are idle for "
            + "more than " + DISCONNECT_MINUTES + " minutes.");
    }

    private function onMouseMove(event:MouseEvent):void {
        this._78 = 0;
    }

    private function onKeyDown(event:KeyboardEvent):void {
        this._78 = 0;
    }

}
}
