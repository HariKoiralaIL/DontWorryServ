package client.signals {
import signals.Signal;

/**
 * Globally accessible signal that carries no arguments.
 * The most recently constructed instance is exposed through {@link #instance}.
 */
public class EmptySignal extends Signal {

    public static var instance:EmptySignal;

    public function EmptySignal() {
        instance = this;
    }

}
}
