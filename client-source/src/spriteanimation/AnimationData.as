package spriteanimation {

/**
 * Definition of one animation, parsed from an <Animation> XML node.
 * All durations are stored in milliseconds (the XML uses seconds).
 */
public class AnimationData {

    /** Chance (0..1) that the animation actually plays when it comes due. */
    public var probability:Number = 1;

    /** Average time between plays. */
    public var period:int;

    /** Random +/- variation applied to each period. */
    public var periodJitter:int;

    /** If true, start times snap to multiples of the period (so identical sprites animate together). */
    public var sync:Boolean = false;

    public var frames:Vector.<FrameData> = new Vector.<FrameData>();

    public function AnimationData(xml:XML) {
        if ("@prob" in xml) {
            this.probability = Number(xml.@prob);
        }
        this.period = int(Number(xml.@period) * 1000);
        this.periodJitter = int(Number(xml.@periodJitter) * 1000);
        this.sync = (String(xml.@sync) == "true");
        for each (var frameXml:XML in xml.Frame) {
            this.frames.push(new FrameData(frameXml));
        }
    }

    /** First time this animation may play, given the current time. */
    public function initialStartTime(time:int):int {
        if (this.sync) {
            return int(time / this.period) * this.period;
        }
        // Small random offset so sprites created together don't animate in lockstep.
        return time + nextPeriod() + 200 * Math.random();
    }

    /** Next time this animation may play after having come due at the given time. */
    public function nextStartTime(time:int):int {
        if (this.sync) {
            return (int(time / this.period) + 1) * this.period;
        }
        return time + nextPeriod();
    }

    private function nextPeriod():int {
        if (this.periodJitter == 0) {
            return this.period;
        }
        return this.period - this.periodJitter + 2 * Math.random() * this.periodJitter;
    }

}
}//package spriteanimation
