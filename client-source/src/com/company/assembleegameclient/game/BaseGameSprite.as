package com.company.assembleegameclient.game {

import com.company.assembleegameclient.map._0D_v;
import com.company.assembleegameclient.net.PacketManager;
import com.company.assembleegameclient.net.messages.incoming.MapInfo;
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.tutorial.Tutorial;

import flash.display.Sprite;

/**
 * Base class for game screens (GameSprite and the map editor). Holds the state
 * shared by both and no-op hooks that subclasses override.
 */
public class BaseGameSprite extends Sprite {

    public var isEditor:Boolean;
    public var tutorial_:Tutorial;
    public var mui_:GameInputHandler;
    public var lastUpdate_:int = 0;
    public var moveRecords_:MoveRecords;
    public var camera_:_0D_v;
    public var gsc_:PacketManager;

    public function BaseGameSprite() {
        super();
        this.moveRecords_ = new MoveRecords();
        this.camera_ = new _0D_v();
    }

    public function initialize():void {
    }

    public function setFocus(target:GameObject):void {
    }

    public function applyMapInfo(mapInfo:MapInfo):void {
    }

    public function evalIsNotInCombatMapArea():Boolean {
        return false;
    }

}
}
