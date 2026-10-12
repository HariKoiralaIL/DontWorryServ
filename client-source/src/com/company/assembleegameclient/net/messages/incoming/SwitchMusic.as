package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Switch the background music track.
 */
public class SwitchMusic extends ServerMessage {

    public var music_:String;

    public function SwitchMusic(id:uint) {
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        this.music_ = data.readUTF();
    }

    override public function toString():String {
        return (formatToString("SWITCHMUSIC", "music_"));
    }

}
}
