package client.signals.typed {
import signals.Signal;

/** Signal carrying a single Boolean. */
public class BooleanSignal extends Signal {

    public function BooleanSignal() {
        super(Boolean);
    }

}
}
