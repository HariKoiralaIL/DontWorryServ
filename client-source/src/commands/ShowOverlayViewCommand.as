package commands {

import rootview.Layers;

import game.dialogs.DeletingCharacterDialog;

/**
 * Adds the _s7 view to the overlay layer.
 */
public class ShowOverlayViewCommand {

    [Inject]
    public var layers:Layers;

    public function execute():void {
        this.layers.overlay.addChild(new DeletingCharacterDialog());
    }

}
}
