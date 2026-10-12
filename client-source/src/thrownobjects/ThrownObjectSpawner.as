package thrownobjects {
import particleeffects.ParticleEffect;

import flash.geom.Point;

// Formerly _pz. A one-shot effect: on its first update it spawns a ThrownObject
// travelling from start to end, then removes itself (update returns false).
// (Not to be confused with _0K_m.ThrowEffect, which is a different class.)
public class ThrownObjectSpawner extends ParticleEffect {

    private static const FLIGHT_TIME_MS:int = 1500;

    public var start_:Point;
    public var end_:Point;

    public function ThrownObjectSpawner(start:Point, end:Point) {
        this.start_ = start;
        this.end_ = end;
    }

    override public function update(time:int, dt:int):Boolean {
        x_ = this.start_.x;
        y_ = this.start_.y;
        map_.addObj(new ThrownObject(FLIGHT_TIME_MS, this.start_, this.end_), x_, y_);
        return false;
    }
}
}
