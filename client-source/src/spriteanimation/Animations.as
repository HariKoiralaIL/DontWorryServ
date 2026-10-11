package spriteanimation {

import flash.display.BitmapData;

/**
 * Plays randomly timed "idle" animations on top of a static sprite.
 *
 * Each animation in the shared AnimationsData has its own schedule. Every
 * call to getTexture() returns the frame of the animation that is currently
 * playing, or null when nothing is playing (the caller then falls back to
 * the sprite's normal texture). All times are in milliseconds.
 */
public class Animations {

    /** Shared, immutable animation definitions. */
    public var animationsData:AnimationsData;

    /** Per-animation time at which that animation may next start (lazily initialised). */
    public var nextStartTimes:Vector.<int> = null;

    /** The animation currently playing, or null. */
    public var running:RunningAnimation = null;

    public function Animations(animationsData:AnimationsData) {
        this.animationsData = animationsData;
    }

    public function getTexture(time:int):BitmapData {
        var data:AnimationData;
        var texture:BitmapData;
        var startTime:int;

        if (this.nextStartTimes == null) {
            this.nextStartTimes = new Vector.<int>();
            for each (data in this.animationsData.animations) {
                this.nextStartTimes.push(data.initialStartTime(time));
            }
        }

        // Keep playing the current animation until it runs out of frames.
        if (this.running != null) {
            texture = this.running.getTexture(time);
            if (texture != null) {
                return texture;
            }
            this.running = null;
        }

        // Otherwise, start the first animation that is due (subject to its probability).
        for (var i:int = 0; i < this.nextStartTimes.length; i++) {
            if (time > this.nextStartTimes[i]) {
                startTime = this.nextStartTimes[i];
                data = this.animationsData.animations[i];
                this.nextStartTimes[i] = data.nextStartTime(time);
                if (shouldPlay(data.probability)) {
                    this.running = new RunningAnimation(data, startTime);
                    return this.running.getTexture(time);
                }
            }
        }
        return null;
    }

    private static function shouldPlay(probability:Number):Boolean {
        return probability == 1 || Math.random() <= probability;
    }

}
}//package spriteanimation

import spriteanimation.AnimationData;
import spriteanimation.FrameData;

import flash.display.BitmapData;

/** Playback state of a single animation instance. */
class RunningAnimation {

    public var animationData:AnimationData;
    public var startTime:int;
    public var frameIndex:int;
    public var frameStartTime:int;
    public var texture:BitmapData;

    public function RunningAnimation(animationData:AnimationData, startTime:int) {
        this.animationData = animationData;
        this.startTime = startTime;
        this.frameIndex = 0;
        this.frameStartTime = startTime;
        this.texture = null;
    }

    /** Returns the texture for the given time, or null once the last frame has finished. */
    public function getTexture(time:int):BitmapData {
        var frames:Vector.<FrameData> = this.animationData.frames;
        var frame:FrameData = frames[this.frameIndex];

        while (time - this.frameStartTime > frame.duration) {
            if (this.frameIndex >= frames.length - 1) {
                return null;
            }
            this.frameStartTime += frame.duration;
            this.frameIndex++;
            frame = frames[this.frameIndex];
            this.texture = null;
        }

        // The texture is picked once per frame and cached until the frame changes.
        if (this.texture == null) {
            this.texture = frame.textureData.getTexture(int(Math.random() * 100));
        }
        return this.texture;
    }

}
