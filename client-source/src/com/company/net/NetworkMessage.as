package com.company.net {
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class NetworkMessage {

    public var id_:uint;

    public function NetworkMessage(id:uint) {
        this.id_ = id;
    }

    public function parseFromInput(input:IDataInput):void {
    }

    public function writeToOutput(output:IDataOutput):void {
    }

    public function toString():String {
        return this.formatToString("MESSAGE", "id_");
    }

    protected function formatToString(name:String, ...fields):String {
        var result:String = "[" + name;
        for each (var field:String in fields) {
            result += " " + field + '="' + this[field] + '"';
        }
        return result + "]";
    }

}
}
