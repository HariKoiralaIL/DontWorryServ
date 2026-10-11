package env {
import flash.display.DisplayObjectContainer;
import flash.system.Capabilities;

public class ClientEnv {

    private const DESKTOP:String = "Desktop";
    private static var platform:PlatformType;

    [Inject]
    public var root:DisplayObjectContainer;

    public function isBrowser():Boolean {
        return Capabilities.playerType != DESKTOP;
    }

    public function isDesktop():Boolean {
        return Capabilities.playerType == DESKTOP;
    }

    public function getPlatform():PlatformType {
        return platform = platform || detectPlatform();
    }

    private function detectPlatform():PlatformType {
        return PlatformType.WEB;
    }

}
}
