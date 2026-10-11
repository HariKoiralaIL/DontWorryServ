package audio {
import com.company.assembleegameclient.parameters.Parameters;

// Formerly _Q_P_. Saves the sound-effects on/off setting and applies it to playing sounds.
public class SfxSettings {

    // The original built a SoundTransform here and discarded it, so this does nothing.
    // Kept so existing SfxSettings.load() calls still compile.
    public static function load():void {
    }

    // formerly _2c
    public static function setSfxEnabled(enabled:Boolean):void {
        Parameters.data_.playSFX = enabled;
        Parameters.save();
        SoundEffects.refreshVolumes();
    }
}
}
