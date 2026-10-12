package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Server-reported error / disconnect reason.
 */
public class Failure extends ServerMessage {

    public static const ERROR_0:int = 0;
    public static const ERROR_1:int = 1;
    public static const ERROR_2:int = 2;
    public static const ERROR_3:int = 3;
    public static const INCORRECT_VERSION:int = 4;
    public static const BAD_KEY:int = 5;
    public static const INVALID_TELEPORT_TARGET:int = 6;
    public static const EMAIL_VERIFICATION_NEEDED:int = 7;
    public static const TELEPORT_REALM_BLOCK:int = 8;

    public var errorId_:int;
    public var errorDescription_:String;

    public function Failure(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.errorId_ = data.readInt();
        this.errorDescription_ = data.readUTF();
    }

    override public function toString():String {
        return (formatToString("FAILURE", "errorId_", "errorDescription_"));
    }

}
}
