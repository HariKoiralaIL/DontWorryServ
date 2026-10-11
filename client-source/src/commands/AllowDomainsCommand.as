package commands {

import env.ClientEnv;
import env.Domain;

/**
 * Allows cross-domain access, but only when running in a browser.
 */
public class AllowDomainsCommand {

    [Inject]
    public var clientEnv:ClientEnv;
    [Inject]
    public var domain:Domain;

    public function execute():void {
        if (this.clientEnv.isBrowser()) {
            this.domain.allowDomains();
        }
    }

}
}
