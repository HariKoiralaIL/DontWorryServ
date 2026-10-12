package particleeffects {

    import com.company.assembleegameclient.parameters.Parameters;

    /** Registry of XML-defined particles, keyed by particle id. */
    public class ParticleLibrary {

        public static const particles:Object = {};

        public static function parse(xml:XML):void {
            var particleXML:XML;
            for each (particleXML in xml.Particle) {
                if (!Parameters.data_["disableParticles"]) {
                    particles[particleXML.@id] = new ParticleProperties(particleXML);
                }
            }
        }

    }
}
