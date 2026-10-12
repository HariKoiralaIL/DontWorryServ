package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Named text file pushed by the server.
 */
public class File extends ServerMessage {

    public var filename_:String;
    public var file_:String;

    public function File(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.filename_ = data.readUTF();
        var length:int = data.readInt();
        this.file_ = data.readUTFBytes(length);
    }

    override public function toString():String {
        return (formatToString("FILE", "filename_", "file_"));
    }

}
}
