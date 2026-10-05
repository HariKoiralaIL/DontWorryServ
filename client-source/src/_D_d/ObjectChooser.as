// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_D_d.ObjectChooser

package _D_d {
import _D_d.MapLayer;

import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.util._L_2;

import _D_d.*;

internal class ObjectChooser extends Chooser {

    public function ObjectChooser() {
        var id:String;
        var type:int;
        var objectXml:XML;
        var objectElement:ObjectElement;
        super(MapLayer.OBJECT);
        var sortedIds:Vector.<String> = new Vector.<String>();
        for (id in ObjectLibrary._pb) {
            sortedIds.push(id);
        }
        sortedIds.sort(_L_2._L_O_);
        for each (id in sortedIds) {
            type = ObjectLibrary._pb[id];
            objectXml = ObjectLibrary._Q_F_[type];
            if (!((((objectXml.hasOwnProperty("Item")) || (objectXml.hasOwnProperty("Player")))) || ((objectXml.Class == "Projectile")))) {
                objectElement = new ObjectElement(objectXml);
                addElement(objectElement);
            }
        }
    }
}
}//package _D_d

