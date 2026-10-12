package com.company.assembleegameclient.map {

/** Texture scroll animation of a ground tile (none, wave or flow). */
public class AnimateProperties {

    public static const NONE:int = 0;
    public static const WAVE:int = 1;
    public static const FLOW:int = 2;

    public var type_:int = NONE;
    public var dx_:Number = 0;
    public var dy_:Number = 0;

    public function parse(xml:XML):void {
        switch (String(xml)) {
            case "Wave":
                this.type_ = WAVE;
                break;
            case "Flow":
                this.type_ = FLOW;
                break;
        }
        this.dx_ = Number(xml.@dx);
        this.dy_ = Number(xml.@dy);
    }

}
}
