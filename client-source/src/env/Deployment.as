package env {
import flash.display.DisplayObjectContainer;
import flash.display.LoaderInfo;

public class Deployment {

    private const PRODUCTION:String = "Production";

    [Inject]
    public var root:DisplayObjectContainer;
    [Inject]
    public var clientEnv:ClientEnv;
    [Inject]
    public var domain:Domain;

    public function isDevelopment():Boolean {
        return !isProduction();
    }

    public function isProduction():Boolean {
        if (clientEnv.isDesktop()) {
            return isProdDeployment();
        }
        return domain.isProdDomain();
    }

    private function isProdDeployment():Boolean {
        var info:LoaderInfo = root.loaderInfo;
        return info.parameters.deployment == PRODUCTION;
    }

}
}
