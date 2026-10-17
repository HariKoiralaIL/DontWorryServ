package com.company.assembleegameclient.ui {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.ui.SimpleText;
import com.gskinner.motion.GTween;

import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import flash.utils.Timer;

/**
 * Shows the next gameplay tip (cycling through the list across sessions),
 * fades it out after 5 seconds and removes it after 10.
 */
public class Protip extends Sprite {

    private static const FADE_DELAY_MS:int = 5000;
    private static const REMOVE_DELAY_MS:int = 10000;
    private static const FADE_SECONDS:Number = 5;

    private static const TIPS:XML = <Protips>
        <Protip>Stay near the beach at first.  Harder monsters live inland.</Protip>
        <Protip>Other players can not hurt you</Protip>
        <Protip>Hit [O] to see all the keys and options</Protip>
        <Protip>Escape to the Nexus by clicking the temple button</Protip>
        <Protip>You earn fame when you die.  Spend it in the Nexus!</Protip>
        <Protip>Activate your special ability with either shift-click or a hotkey</Protip>
        <Protip>Shift-Click a potion to drink it</Protip>
        <Protip>Use the /tell command to talk to other players anywhere in the game.</Protip>
        <Protip>Drag an item onto the world to drop it</Protip>
        <Protip>Zoom the minimap with the mouse wheel</Protip>
        <Protip>Click a yellow or green minimap dot to teleport to another player</Protip>
        <Protip>Each inventory slot has a hotkey -- mouseover to see it</Protip>
        <Protip>You can drink potions even if they are still on the ground</Protip>
        <Protip>Rerun the tutorial by typing "/tutorial" in chat</Protip>
    </Protips>;

    private var text_:SimpleText;
    private var fadeTimer_:Timer = new Timer(FADE_DELAY_MS);
    private var removeTimer_:Timer = new Timer(REMOVE_DELAY_MS);

    public function Protip() {
        super();
        filters = [new GlowFilter(0, 1, 3, 3, 2, 1)];
        var tipIndex:int = int(Parameters.data_.protipIndex);
        if (tipIndex >= TIPS.Protip.length()) {
            tipIndex = 0;
        }
        var tip:String = TIPS.Protip[tipIndex];
        Parameters.data_.protipIndex = tipIndex + 1;
        Parameters.save();
        this.text_ = new SimpleText(18, 0xFFFFFF, false, 0, 0, "Myriad Pro");
        this.text_.filters = [new DropShadowFilter(0, 0, 0, 1, 4, 4, 2)];
        this.text_.text = "Tip: " + tip;
        addChild(this.text_);
        mouseEnabled = false;
        mouseChildren = false;
        this.text_.updateMetrics();
        this.text_.x = 300 - (this.text_._c9 / 2);
        this.text_.y = 125;
        this.fadeTimer_.addEventListener(TimerEvent.TIMER, this.onFadeTimer);
        this.fadeTimer_.start();
        this.removeTimer_.addEventListener(TimerEvent.TIMER, this.onRemoveTimer);
        this.removeTimer_.start();
    }

    private function onFadeTimer(event:TimerEvent):void {
        new GTween(this, FADE_SECONDS, {"alpha": 0});
    }

    private function onRemoveTimer(event:TimerEvent):void {
        if (parent != null) {
            parent.removeChild(this);
        }
    }
}
}
