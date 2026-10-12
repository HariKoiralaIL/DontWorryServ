package com.company.assembleegameclient.tutorial {
import com.company.assembleegameclient.game.GameSprite;

/** Notifies the active tutorial (if any) that the player performed an action. */
public function doneAction(gs:GameSprite, action:String):void {
    if (gs.tutorial_ == null) {
        return;
    }
    gs.tutorial_.doneAction(action);
}
}
