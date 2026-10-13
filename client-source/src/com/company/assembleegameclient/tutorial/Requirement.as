package com.company.assembleegameclient.tutorial {
import com.company.assembleegameclient.objects.ObjectLibrary;

public class Requirement {

    public var type_:String;
    public var slot_:int = -1;
    public var objectType_:int = -1;
    public var objectName_:String = "";
    public var radius_:Number = 1;

    public function Requirement(xml:XML) {
        this.type_ = String(xml);
        var objectId:String = String(xml.@objectId);
        if (objectId != null && objectId != "") {
            this.objectType_ = ObjectLibrary.idToType_[objectId];
        }
        this.objectName_ = String(xml.@objectName);
        if (this.objectName_ == null) {
            this.objectName_ = "";
        }
        this.slot_ = int(xml.@slot);
        this.radius_ = Number(xml.@radius);
    }

}
}
