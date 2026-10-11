package commands {

import env.ServerListState;

/**
 * Flags the server list as enabled.
 */
public class EnableServerListCommand {

    [Inject]
    public var serverListState:ServerListState;

    public function execute():void {
        this.serverListState.enabled = true;
    }

}
}
