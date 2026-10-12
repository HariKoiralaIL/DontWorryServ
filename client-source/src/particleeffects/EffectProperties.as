package particleeffects {

    /** Settings of one <ParticleEffect> entry parsed from XML. */
    public class EffectProperties {

        public var id:String;
        public var particle:String;
        public var cooldown:Number;
        public var color:uint;
        public var rate:Number;
        public var speed:Number;
        public var speedVariance:Number;
        public var spread:Number;
        public var life:Number;
        public var lifeVariance:Number;
        public var size:int;
        public var rise:Number;
        public var growth:Number;
        public var riseVariance:Number;
        public var riseAcc:Number;
        public var rangeX:Number;
        public var rangeY:Number;
        public var rangeZ:Number;
        public var zOffset:Number;
        public var angleOffset:Number;
        public var radius:Number;
        public var fadeOut:Number;
        public var fadeIn:Number;
        public var attached:Boolean;
        public var bitmapFile:String;
        public var bitmapIndex:uint;
        public var bitmapIndexMax:Number;

        public function EffectProperties(xml:XML) {
            this.id = xml.toString();
            this.particle = xml.@particle;
            this.cooldown = xml.@cooldown;
            this.color = xml.@color;
            this.rate = ((xml.@rate) || (5));
            this.speed = ((xml.@speed) || (0));
            if (xml.hasOwnProperty("@speedVariance")) {
                this.speedVariance = xml.@speedVariance;
            } else {
                this.speedVariance = 0.5;
            }
            this.spread = ((xml.@spread) || (0));
            this.life = ((xml.@life) || (1));
            this.lifeVariance = ((xml.@lifeVariance) || (0));
            this.size = ((xml.@size) || (3));
            if (xml.hasOwnProperty("@rise")) {
                this.rise = xml.@rise;
            } else {
                this.rise = 3;
            }
            this.growth = ((xml.@growth) || (0));
            this.riseVariance = ((xml.@riseVariance) || (0));
            this.riseAcc = ((xml.@riseAcc) || (0));
            this.rangeX = ((xml.@rangeX) || (0));
            this.rangeY = ((xml.@rangeY) || (0));
            this.rangeZ = ((xml.@rangeZ) || (0));
            this.zOffset = ((xml.@zOffset) || (0));
            this.angleOffset = ((xml.@angleOffset) || (0));
            this.radius = ((xml.@radius) || (0));
            this.fadeOut = xml.hasOwnProperty("@fadeOut") ? xml.@fadeOut : -1;
            this.fadeIn = xml.hasOwnProperty("@fadeIn") ? xml.@fadeIn : -1;
            this.attached = xml.hasOwnProperty("@attached") ? xml.@attached : false;
            this.bitmapFile = xml.@bitmapFile;
            this.bitmapIndex = xml.@bitmapIndex;
            this.bitmapIndexMax = xml.hasOwnProperty("@bitmapIndexMax") ? xml.@bitmapIndexMax : -1;
        }
    }
}
