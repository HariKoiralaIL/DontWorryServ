package particleeffects {

    import com.company.assembleegameclient.objects._Z_H_;

    import spriteanimation.AnimationsData;

    /** Definition of one <Particle> entry parsed from XML (used by XMLEffect / XMLParticle). */
    public class ParticleProperties {

        public var id_:String;
        public var textureData_:_Z_H_;
        public var size_:int = 100;
        public var z_:Number = 0;
        public var duration_:Number = 0;
        public var animationData_:AnimationsData = null;

        public function ParticleProperties(xml:XML) {
            this.id_ = xml.@id;
            this.textureData_ = new _Z_H_(xml);
            if (xml.hasOwnProperty("Size")) {
                this.size_ = Number(xml.Size);
            }
            if (xml.hasOwnProperty("Z")) {
                this.z_ = Number(xml.Z);
            }
            if (xml.hasOwnProperty("Duration")) {
                this.duration_ = Number(xml.Duration);
            }
            if (xml.hasOwnProperty("Animation")) {
                this.animationData_ = new AnimationsData(xml);
            }
        }
    }
}
