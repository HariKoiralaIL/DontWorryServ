package particleeffects {

    import com.company.assembleegameclient.objects.GameObject;

    import flash.geom.Point;

    /** AoeEffect centred on a game object's current position. */
    public class NovaEffect extends AoeEffect {

        public function NovaEffect(go:GameObject, radius:Number, color:int) {
            super(new Point(go.x_, go.y_), radius, color);
        }

    }
}
