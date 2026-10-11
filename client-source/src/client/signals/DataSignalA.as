package client.signals {
import client.enums.PositionSlot;

import signals.Signal;

/**
 * Globally accessible signal carrying a single _1l value.
 * The most recently constructed instance is exposed through {@link #instance}.
 */
public class DataSignalA extends Signal {

    public static var instance:DataSignalA;

    public function DataSignalA() {
        super(PositionSlot);
        instance = this;
    }

}
}
