package spriteanimation {

import com.company.assembleegameclient.objects.TextureData;

/** One frame of an animation, parsed from a <Frame> XML node. */
public class FrameData {

    /** How long the frame is shown, in milliseconds (the XML uses seconds). */
    public var duration:int;

    /** Source of the texture(s) shown during this frame. */
    public var textureData:TextureData;

    public function FrameData(xml:XML) {
        this.duration = int(Number(xml.@time) * 1000);
        this.textureData = new TextureData(xml);
    }

}
}//package spriteanimation
