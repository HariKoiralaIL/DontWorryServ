package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Chat / speech-bubble text.
 */
public class Text extends ServerMessage {

    public var name_:String;
    public var objectId_:int;
    public var numStars_:int;
    public var bubbleTime_:uint;
    public var recipient_:String;
    public var text_:String;
    public var cleanText_:String;

    public function Text(id:uint) {
        this.name_ = "";
        this.text_ = "";
        this.cleanText_ = "";
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.name_ = data.readUTF();
        this.objectId_ = data.readInt();
        this.numStars_ = data.readInt();
        this.bubbleTime_ = data.readUnsignedByte();
        this.recipient_ = data.readUTF();
        this.text_ = data.readUTF();
        this.cleanText_ = data.readUTF();
    }

    override public function toString():String {
        return (formatToString("TEXT", "name_", "objectId_", "numStars_", "bubbleTime_", "recipient_", "text_", "cleanText_"));
    }

}
}
