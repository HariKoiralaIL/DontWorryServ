package com.company.assembleegameclient.map {
import com.company.assembleegameclient.objects.GameObject;

import flash.utils.getTimer;

public class Quest {

    public var map_:GameMap;
    public var objectId_:int = -1;
    private var showAfter:int = 0;
    private var newUntil:int = 0;

    public function Quest(map:GameMap) {
        this.map_ = map;
    }

    public function setObject(objectId:int):void {
        if (this.objectId_ == -1 && objectId != -1) {
            this.showAfter = getTimer() + 4000;
            this.newUntil = this.showAfter + 2000;
        }
        this.objectId_ = objectId;
    }

    public function completed():void {
        this.showAfter = getTimer() + 15000 - Math.random() * 10000;
        this.newUntil = this.showAfter + 2000;
    }

    public function getObject(time:int):GameObject {
        if (time < this.showAfter) {
            return null;
        }
        return this.map_.goDict_[this.objectId_];
    }

    public function isNew(time:int):Boolean {
        return time < this.newUntil;
    }

}
}
