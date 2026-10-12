package com.company.assembleegameclient.map {
import MapBackgrounds.Background;

import arrows.ArrowOverlay;

import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.BasicObject;
import com.company.assembleegameclient.objects.Player;
import com.company.assembleegameclient.objects._ez;

import flash.display.Sprite;
import flash.geom.Point;
import flash.utils.Dictionary;

import mapoverlay.MapOverlay;

/** Abstract base of GameMap: shared state plus no-op overridable API. */
public class MapHandler extends Sprite {

    public var goDict_:Dictionary;
    public var gs_:GameSprite;
    public var name_:String;
    public var player_:Player = null;
    public var showDisplays_:Boolean;
    public var music_:String;
    public var width_:int;
    public var height_:int;
    public var backgroundId_:int;
    public var allowPlayerTeleport_:Boolean;
    public var background_:Background = null;
    public var map_:Sprite;
    public var weatherBackground_:Background = null;
    public var hurtOverlay_:HurtOverlay = null;
    public var gradientOverlay_:GradientOverlay = null;
    public var mapOverlay_:MapOverlay = null;
    public var partyOverlay_:ArrowOverlay = null;
    public var squareList_:Vector.<Square>;
    public var squares_:Vector.<Square>;
    public var boDict_:Dictionary;
    public var merchLookup_:Object;
    public var party_:_ez = null;
    public var quest_:Quest = null;
    public var weather_:int;

    public function MapHandler() {
        super();
        this.goDict_ = new Dictionary();
        this.map_ = new Sprite();
        this.squareList_ = new Vector.<Square>();
        this.squares_ = new Vector.<Square>();
        this.boDict_ = new Dictionary();
        this.merchLookup_ = {};
    }

    public function setProps(width:int, height:int, name:String, backgroundId:int, allowPlayerTeleport:Boolean, showDisplays:Boolean, music:String, weather:int):void {
    }

    public function addObj(obj:BasicObject, x:Number, y:Number):void {
    }

    public function setGroundTile(x:int, y:int, tileType:uint):void {
    }

    public function initialize():void {
    }

    public function dispose():void {
    }

    public function update(time:int, dt:int):void {
    }

    public function pSTopW(screenX:Number, screenY:Number):Point {
        return null;
    }

    public function removeObj(objectId:int):void {
    }

    public function draw(camera:GameCamera, time:int):void {
    }

}
}
