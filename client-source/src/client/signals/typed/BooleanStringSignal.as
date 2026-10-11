package client.signals.typed {
import signals.Signal;

/** Signal carrying a Boolean and a String. */
public class BooleanStringSignal extends Signal {

    public function BooleanStringSignal() {
        super(Boolean, String);
    }

}
}
