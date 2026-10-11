package beginnersoffer {
import robotlegs.bender.bundles.mvcs.Mediator;

public class DarkOverlayMediator extends Mediator {

    private static const STAGE_WIDTH:int = 800;
    private static const STAGE_HEIGHT:int = 600;

    [Inject]
    public var view:DarkOverlay;

    override public function initialize():void {
        this.view.initialize(STAGE_WIDTH, STAGE_HEIGHT);
    }
}
}
