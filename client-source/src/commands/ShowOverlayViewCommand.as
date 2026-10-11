package commands {

import rootview.Layers;

import _0L_C_._s7;

/**
 * Adds the _s7 view to the overlay layer.
 */
public class ShowOverlayViewCommand {

    [Inject]
    public var layers:Layers;

    public function execute():void {
        this.layers.overlay.addChild(new _s7());
    }

}
}
