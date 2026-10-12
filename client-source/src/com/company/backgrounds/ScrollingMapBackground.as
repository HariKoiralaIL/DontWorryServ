package com.company.backgrounds {
import MapBackgrounds.Background;

import com.company.map.MapJsonParser;

import com.company.audio.MusicPlayer;

import com.company.assembleegameclient.map.GameCamera;
import com.company.assembleegameclient.map.GameMap;
import com.company.util.IntPoint;

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.utils.ByteArray;
import flash.utils.getTimer;

// Formerly _02t._pM_. Menu background: a map that scrolls horizontally and loops.
// Still-obfuscated externals: _X_l (map class), GameCamera (camera) and its _K_().
public class ScrollingMapBackground extends Sprite {

    private static const BORDER:int = 10;
    private static const VIEW_RECT:Rectangle = new Rectangle(-400, -300, 800, 600);     // formerly _R_m
    private static const CAMERA_ANGLE:Number = (7 * Math.PI) / 4;                       // formerly _X_z
    private static const MS_TO_SEC:Number = 1 / 1000;                                   // formerly _06B_
    private static const MAP_DATA:Class = MenuMapData;                                  // formerly _01N_

    private static var map:GameMap;            // formerly _I_k; shared, built once
    private static var mapSize:IntPoint;    // formerly _sl
    private static var cameraX:Number;      // formerly _jJ_
    private static var cameraY:Number;      // formerly _U_b
    private static var camera:GameCamera;        // formerly _0F_q

    private var lastTime:int;               // formerly _7n
    private var time:Number;

    public function ScrollingMapBackground() {
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    // Formerly _P_i. Builds the map twice side by side so the scroll can wrap.
    private function createMap():GameMap {
        var bytes:ByteArray = new MAP_DATA();
        var json:String = bytes.readUTFBytes(bytes.length);
        mapSize = MapJsonParser.getMapSize(json);
        cameraX = BORDER;
        cameraY = BORDER + int((mapSize.y_ - 2 * BORDER) * Math.random());
        camera = new GameCamera();
        var newMap:GameMap = new GameMap(null);
        newMap.setProps(mapSize.x_ + 2 * BORDER, mapSize.y_, "Background Map", Background._0H_W_, false, false, "Menu", 0);
        newMap.initialize();
        MapJsonParser.mergeInto(json, newMap, 0, 0);
        MapJsonParser.mergeInto(json, newMap, mapSize.x_, 0);
        return newMap;
    }

    private function onAddedToStage(e:Event):void {
        addChildAt(map = map || this.createMap(), 0);
        addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        this.lastTime = getTimer();
    }

    private function onRemovedFromStage(e:Event):void {
        removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onEnterFrame(e:Event):void {
        this.time = getTimer();
        cameraX += (this.time - this.lastTime) * MS_TO_SEC;
        if (cameraX > mapSize.x_ + BORDER) {
            cameraX -= mapSize.x_;
        }
        // The old condition (music_ != "Death" || music_ != "Menu") was always true,
        // so this always forces the menu track. reload() is a no-op if already "Menu".
        MusicPlayer.reload("Menu");
        MusicPlayer.updateFade();
        camera.configure(cameraX, cameraY, 12, CAMERA_ANGLE, VIEW_RECT, false);
        map.draw(camera, this.time);
        this.lastTime = this.time;
    }

}
}
