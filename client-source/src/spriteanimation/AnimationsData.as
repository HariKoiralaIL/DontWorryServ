package spriteanimation {

/** The full set of animations defined in one XML node (its <Animation> children). */
public class AnimationsData {

    public var animations:Vector.<AnimationData> = new Vector.<AnimationData>();

    public function AnimationsData(xml:XML) {
        for each (var animationXml:XML in xml.Animation) {
            this.animations.push(new AnimationData(animationXml));
        }
    }

}
}//package spriteanimation
