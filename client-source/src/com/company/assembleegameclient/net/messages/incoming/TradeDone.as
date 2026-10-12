package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Final outcome of a trade.
 */
public class TradeDone extends ServerMessage {

    public static const CODE_0:int = 0;
    public static const CODE_1:int = 1;

    public var code_:int;
    public var description_:String;

    public function TradeDone(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.code_ = data.readInt();
        this.description_ = data.readUTF();
    }

    override public function toString():String {
        return (formatToString("TRADEDONE", "code_", "description_"));
    }

}
}
