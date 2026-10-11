package env {
import com.company.assembleegameclient.appengine.Server_list;

public class ServerListState {

    public var servers:Server_list;
    public var enabled:Boolean;
    public var count:int;

    public function ServerListState() {
        enabled = true;
    }

}
}
