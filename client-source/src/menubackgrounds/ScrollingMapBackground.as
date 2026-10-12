package menubackgrounds {

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.utils.ByteArray;
import flash.utils.getTimer;

import com.company.assembleegameclient.map.GameCamera;
import com.company.assembleegameclient.map.GameMap;
import com.company.util.IntPoint;

import MapBackgrounds.Background;
import maploading.MapLoader;

import audio.MusicManager;

/**
 * Menu background: renders the embedded background map and slowly scrolls
 * the camera across it. The map is loaded twice, side by side, so the scroll
 * wraps around seamlessly.
 *
 * The map and the camera position are static, so they are created once and
 * shared by every instance.
 */
public class ScrollingMapBackground extends Sprite {

    private static const BORDER:int = 10;
    private static const VIEW_RECT:Rectangle = new Rectangle(-400, -300, 800, 600);
    private static const CAMERA_ANGLE:Number = (7 * Math.PI) / 4;
    /** Map units scrolled per millisecond. */
    private static const SCROLL_SPEED:Number = 1 / 1000;
    private static const MAP_DATA:Class = MenuBackgroundMapData;

    private static var map:GameMap;
    private static var mapSize:IntPoint;
    private static var cameraX:Number;
    private static var cameraY:Number;
    private static var camera:GameCamera;

    private var lastTime:int;

    public function ScrollingMapBackground() {
        addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
    }

    private function createMap():GameMap {
        var data:ByteArray = new MAP_DATA();
        var json:String = data.readUTFBytes(data.length);
        mapSize = MapLoader.getMapSize(json);
        cameraX = BORDER;
        cameraY = BORDER + int((mapSize.y_ - 2 * BORDER) * Math.random());
        camera = new GameCamera();
        var newMap:GameMap = new GameMap(null);
        newMap.setProps(mapSize.x_ + 2 * BORDER, mapSize.y_, "Background Map", Background._0H_W_, false, false, "Menu", 0);
        newMap.initialize();
        MapLoader.loadInto(json, newMap, 0, 0);
        MapLoader.loadInto(json, newMap, mapSize.x_, 0);
        return newMap;
    }

    private function onAddedToStage(event:Event):void {
        map = map || this.createMap();
        addChildAt(map, 0);
        addEventListener(Event.ENTER_FRAME, this.onEnterFrame);
        this.lastTime = getTimer();
    }

    private function onRemovedFromStage(event:Event):void {
        removeEventListener(Event.ENTER_FRAME, this.onEnterFrame);
    }

    private function onEnterFrame(event:Event):void {
        var now:Number = getTimer();
        cameraX += (now - this.lastTime) * SCROLL_SPEED;
        if (cameraX > mapSize.x_ + BORDER) {
            cameraX -= mapSize.x_;
        }
        // NOTE: this condition is always true (music_ can't equal both strings),
        // so "Menu" is reloaded every frame. Kept as is; it was probably meant to be &&.
        if (MusicManager.music_ != "Death" || MusicManager.music_ != "Menu") {
            MusicManager.reload("Menu");
        }
        MusicManager.updateFade();
        camera._K_(cameraX, cameraY, 12, CAMERA_ANGLE, VIEW_RECT, false);
        map.draw(camera, now);
        this.lastTime = now;
    }

}
}
