package com.company.assembleegameclient.net.messages.incoming {
import com.company.assembleegameclient.net.messages.data._0H_9;
import com.company.assembleegameclient.net.messages.data._iZ_;
import com.company.assembleegameclient.util._wW_;
import flash.utils.IDataInput;

/**
 * World update: new tiles, new objects and dropped object ids.
 */
public class Update extends ServerMessage {

    public var tiles_:Vector.<_iZ_>;
    public var newObjs_:Vector.<_0H_9>;
    public var drops_:Vector.<int>;

    public function Update(id:uint) {
        this.tiles_ = new Vector.<_iZ_>();
        this.newObjs_ = new Vector.<_0H_9>();
        this.drops_ = new Vector.<int>();
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        var count:int;
        var i:int;
        count = data.readShort();
        for (i = count; i < this.tiles_.length; i++) {
            _wW_._ay(this.tiles_[i]);
        }
        this.tiles_.length = Math.min(count, this.tiles_.length);
        while (this.tiles_.length < count) {
            this.tiles_.push((_wW_._B_1(_iZ_) as _iZ_));
        }
        for (i = 0; i < count; i++) {
            this.tiles_[i].parseFromInput(data);
        }
        this.newObjs_.length = 0;
        count = data.readShort();
        for (i = count; i < this.newObjs_.length; i++) {
            _wW_._ay(this.newObjs_[i]);
        }
        this.newObjs_.length = Math.min(count, this.newObjs_.length);
        while (this.newObjs_.length < count) {
            this.newObjs_.push((_wW_._B_1(_0H_9) as _0H_9));
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
