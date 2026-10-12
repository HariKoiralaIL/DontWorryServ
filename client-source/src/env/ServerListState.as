package env {
import com.company.assembleegameclient.appengine.CharListEvent;

public class ServerListState {

    public var servers:CharListEvent;
    public var enabled:Boolean;
    public var count:int;

    public function ServerListState() {
        enabled = true;
    }

}
}
