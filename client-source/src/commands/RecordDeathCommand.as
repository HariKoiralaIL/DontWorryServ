package commands {

import com.company.assembleegameclient.parameters.Parameters;

import env.DeathRecord;
import env.ServerListState;

import _011.Death;

/**
 * Stores the latest death info on the shared DeathRecord and clears
 * the "random realm" flag in the saved parameters.
 */
public class RecordDeathCommand {

    [Inject]
    public var death:Death;
    [Inject]
    public var serverListState:ServerListState;
    [Inject]
    public var deathRecord:DeathRecord;

    public function execute():void {
        this.deathRecord._sr = true;
        this.deathRecord.info = this.death;
        this.deathRecord._Z__ = this.serverListState.servers.accountId_;
        this.deathRecord._J_u = this.death.charId_;
        Parameters.data_.needsRandomRealm = false;
        Parameters.save();
    }

}
}
