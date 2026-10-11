package spriteanimation {

import com.company.assembleegameclient.objects._Z_H_;

/** One frame of an animation, parsed from a <Frame> XML node. */
public class FrameData {

    /** How long the frame is shown, in milliseconds (the XML uses seconds). */
    public var duration:int;

    /** Source of the texture(s) shown during this frame. */
    public var textureData:_Z_H_;

    public function FrameData(xml:XML) {
        this.duration = int(Number(xml.@time) * 1000);
        this.textureData = new _Z_H_(xml);
    }

}
}//package spriteanimation
