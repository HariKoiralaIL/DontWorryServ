package dataprepare {

import flash.events.Event;

/** Reports progress and completion of a data preparation step. */
public class DataPrepareEvent extends Event {

    public static const PREPARE_PROGRESS:String = "dataPrepareProgress";
    public static const PREPARE_COMPLETE:String = "dataPrepareComplete";

    public var bytesLoaded:uint = 0;
    public var bytesTotal:uint = 0;

    public function DataPrepareEvent(type:String, bytesLoaded:uint = 0, bytesTotal:uint = 0) {
        super(type);
        this.bytesTotal = bytesTotal;
        this.bytesLoaded = bytesLoaded;
    }

}
}//package dataprepare
