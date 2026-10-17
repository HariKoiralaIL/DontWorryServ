package com.company.util {
import flash.system.Capabilities;

public class SystemInfo {

    private static const CAPABILITY_KEYS:Array = [
        "avHardwareDisable", "hasAccessibility", "hasAudio", "hasAudioEncoder", "hasEmbeddedVideo",
        "hasIME", "hasMP3", "hasPrinting", "hasScreenBroadcast", "hasScreenPlayback",
        "hasStreamingAudio", "hasStreamingVideo", "hasTLS", "hasVideoEncoder", "isDebugger",
        "language", "localFileReadDisable", "manufacturer", "os", "pixelAspectRatio",
        "playerType", "screenColor", "screenDPI", "screenResolutionX", "screenResolutionY", "version"];

    /** One "key: value" line per Flash Player capability. */
    public static function getCapabilitiesReport():String {
        var report:String = "";
        for each (var key:String in CAPABILITY_KEYS) {
            report = report + formatCapability(key);
        }
        return report;
    }

    private static function formatCapability(key:String):String {
        return key + ": " + Capabilities[key] + "\n";
    }

}
}//package com.company.util
