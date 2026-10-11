package mapeditor {
import flash.events.Event;

/** Dispatched by the editor when the user presses "Test"; carries the serialized map. */
public class MapTestEvent extends Event {

    public static const MAP_TEST_EVENT:String = "MAP_TEST_EVENT";

    public function MapTestEvent(mapJson:String) {
        super(MAP_TEST_EVENT);
        this.mapJson_ = mapJson;
    }
    public var mapJson_:String;
}
}
