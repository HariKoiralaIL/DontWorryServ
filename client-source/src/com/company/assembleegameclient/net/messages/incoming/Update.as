package com.company.assembleegameclient.net.messages.incoming {
import com.company.assembleegameclient.net.messages.data.ObjectData;
import com.company.assembleegameclient.net.messages.data.GroundTileData;
import com.company.assembleegameclient.util.ObjectPool;
import flash.utils.IDataInput;

/**
 * World update: new tiles, new objects and dropped object ids.
 */
public class Update extends ServerMessage {

    public var tiles_:Vector.<GroundTileData>;
    public var newObjs_:Vector.<ObjectData>;
    public var drops_:Vector.<int>;

    public function Update(id:uint) {
        this.tiles_ = new Vector.<GroundTileData>();
        this.newObjs_ = new Vector.<ObjectData>();
        this.drops_ = new Vector.<int>();
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        var count:int;
        var i:int;
        count = data.readShort();
        for (i = count; i < this.tiles_.length; i++) {
            ObjectPool.releaseInstance(this.tiles_[i]);
        }
        this.tiles_.length = Math.min(count, this.tiles_.length);
        while (this.tiles_.length < count) {
            this.tiles_.push((ObjectPool.getOrCreate(GroundTileData) as GroundTileData));
        }
        for (i = 0; i < count; i++) {
            this.tiles_[i].parseFromInput(data);
        }
        this.newObjs_.length = 0;
        count = data.readShort();
        for (i = count; i < this.newObjs_.length; i++) {
            ObjectPool.releaseInstance(this.newObjs_[i]);
        }
        this.newObjs_.length = Math.min(count, this.newObjs_.length);
        while (this.newObjs_.length < count) {
            this.newObjs_.push((ObjectPool.getOrCreate(ObjectData) as ObjectData));
        }
        for (i = 0; i < count; i++) {
            this.newObjs_[i].parseFromInput(data);
        }
        this.drops_.length = 0;
        count = data.readShort();
        for (i = 0; i < count; i++) {
            this.drops_.push(data.readInt());
        }
    }

    override public function toString():String {
        return (formatToString("UPDATE", "tiles_", "newObjs_", "drops_"));
    }

}
}
