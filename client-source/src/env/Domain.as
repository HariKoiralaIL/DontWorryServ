package env {
import flash.net.LocalConnection;
import flash.system.Security;

public class Domain {

    private const LOCALHOST:String = "localhost";
    private const PROD_DOMAINS:Array = ["bledixon.com"];
    private const HOSTED_DOMAINS:Array = ["bledixon.github.io"];
    private const ALLOWED_DOMAINS:Array = PROD_DOMAINS.concat(HOSTED_DOMAINS);

    [Inject]
    public var clientEnv:ClientEnv;
    private var cachedDomain:String;

    public function allowDomains():void {
        var domain:String;
        for each (domain in ALLOWED_DOMAINS) {
            Security.allowDomain(domain);
        }
    }

    public function isAllowed():Boolean {
        return clientEnv.isDesktop() || isTrustedHost();
    }

    public function isProdDomain():Boolean {
        return PROD_DOMAINS.indexOf(getDomain()) != -1;
    }

    private function isTrustedHost():Boolean {
        var host:String = getDomain();
        return host == LOCALHOST || ALLOWED_DOMAINS.indexOf(host) != -1;
    }

    private function getDomain():String {
        return cachedDomain = cachedDomain || new LocalConnection().domain;
    }

}
}
