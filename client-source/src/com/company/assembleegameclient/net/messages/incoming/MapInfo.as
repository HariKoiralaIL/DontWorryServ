package com.company.assembleegameclient.net.messages.incoming {
import flash.utils.IDataInput;

/**
 * Map properties sent when entering a map.
 */
public class MapInfo extends ServerMessage {

    public var width_:int;
    public var height_:int;
    public var name_:String;
    public var conMessage_:String;
    public var difficulty_:int;
    public var fp_:uint;
    public var background_:int;
    public var allowPlayerTeleport_:Boolean;
    public var showDisplays_:Boolean;
    public var weather_:int;
    public var music_:String;
    public var clientXML_:Vector.<String>;
    public var extraXML_:Vector.<String>;

    public function MapInfo(id:uint) {
        this.clientXML_ = new Vector.<String>();
        this.extraXML_ = new Vector.<String>();
        super(id);
    }

    override public function parseFromInput(data:IDataInput):void {
        var count:int;
        var i:int;
        var length:int;
        this.width_ = data.readInt();
        this.height_ = data.readInt();
        this.name_ = data.readUTF();
        this.conMessage_ = data.readUTF();
        this.fp_ = data.readUnsignedInt();
        this.background_ = data.readInt();
        this.difficulty_ = data.readInt();
        this.allowPlayerTeleport_ = data.readBoolean();
        this.showDisplays_ = data.readBoolean();
        this.weather_ = data.readUnsignedByte();
        this.music_ = data.readUTF();
        count = data.readShort();
        this.clientXML_.length = 0;
        for (i = 0; i < count; i++) {
            length = data.readInt();
            this.clientXML_.push(data.readUTFBytes(length));
        }
        count = data.readShort();
        this.extraXML_.length = 0;
        for (i = 0; i < count; i++) {
            length = data.readInt();
            this.extraXML_.push(data.readUTFBytes(length));
        }
    }

    override public function toString():String {
        return (formatToString("MAPINFO", "width_", "height_", "name_", "conMessage_", "fp_", "background_", "allowPlayerTeleport_", "showDisplays_", "weather_", "music_", "clientXML_", "extraXML_"));
    }

}
}
