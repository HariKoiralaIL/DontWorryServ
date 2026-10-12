package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Result of a purchase request.
 */
public class BuyResult extends ServerMessage {

    public static const RESULT_NEG_1:int = -1;
    public static const RESULT_0:int = 0;
    public static const RESULT_1:int = 1;
    public static const RESULT_2:int = 2;
    public static const RESULT_3:int = 3;
    public static const RESULT_4:int = 4;
    public static const RESULT_5:int = 5;
    public static const RESULT_6:int = 6;
    public static const RESULT_9:int = 9;

    public var result_:int;
    public var resultString_:String;

    public function BuyResult(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.result_ = data.readInt();
        this.resultString_ = data.readUTF();
    }

    override public function toString():String {
        return (formatToString("BUYRESULT", "result_", "resultString_"));
    }

}
}
