package beginnersoffer {
import rootview.Layers;

/**
 * Robotlegs command that shows the beginner's offer dialog on the overlay layer.
 * Formerly _R_S_.AddViewToLayerCommand (originally _I_y).
 */
public class ShowBeginnersOfferCommand {

    [Inject]
    public var layers:Layers;

    public function execute():void {
        this.layers.overlay.addChild(new BeginnersOfferDialogView());
    }
}
}
