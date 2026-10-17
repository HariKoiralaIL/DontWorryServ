package ui.mediators {
import com.company.assembleegameclient.ui.PlayerPanel;

import robotlegs.bender.bundles.mvcs.Mediator;

/**
 * Mediator for the inventory tabs. Currently has no behaviour; kept so the
 * InvTabs -> mediator mapping stays valid.
 */
public class InvTabsMediator extends Mediator {

    [Inject]
    public var view:PlayerPanel;

}
}
