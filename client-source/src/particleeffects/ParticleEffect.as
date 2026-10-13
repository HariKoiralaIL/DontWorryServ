package particleeffects {

    import com.company.assembleegameclient.map.GameCamera;
    import com.company.assembleegameclient.objects.GameObject;

    import flash.display.IGraphicsData;

    /**
     * Base class for all particle effects. An effect is an invisible map object
     * that spawns particles from its update() method.
     */
    public class ParticleEffect extends GameObject {

        public static function fromProps(props:EffectProperties, go:GameObject):ParticleEffect {
            var cloudEffect:CustomParticleEffect;
            switch (props.id) {
                case "Healing":
                    return new HealingEffect(go);
                case "Fountain":
                    return new FountainEffect(go);
                case "Gas":
                    return new GasEffect(go, props);
                case "Vent":
                    return new VentEffect(go);
                case "Bubbles":
                    return new BubbleEffect(go, props);
                case "XMLEffect":
                    return new XMLEffect(go, props);
                case "CustomParticles":
                    return CustomParticleEffect.create(props, go);
                case "CloudParticles":
                    cloudEffect = CustomParticleEffect.create(props, go);
                    cloudEffect.cloud_ = true;
                    return cloudEffect;
                case "Orbiting":
                    return OrbitEffect.create(props, go);
            }
            return null;
        }

        public function ParticleEffect() {
            super(null);
            objectId_ = getNextFakeObjectId();
            hasShadow_ = false;
        }

        override public function update(time:int, dt:int):Boolean {
            return false;
        }

        override public function draw(graphicsData:Vector.<IGraphicsData>, camera:GameCamera, time:int):void {
        }

    }
}
