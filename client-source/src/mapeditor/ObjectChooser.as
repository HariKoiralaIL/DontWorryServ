package mapeditor {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.util._L_2;

internal class ObjectChooser extends Chooser {

    public function ObjectChooser() {
        var id:String;
        var type:int;
        var objectXml:XML;
        super(MapLayer.OBJECT);
        var sortedIds:Vector.<String> = new Vector.<String>();
        for (id in ObjectLibrary._pb) {
            sortedIds.push(id);
        }
        sortedIds.sort(_L_2._L_O_);
        for each (id in sortedIds) {
            type = ObjectLibrary._pb[id];
            objectXml = ObjectLibrary._Q_F_[type];
            if (isPlaceable(objectXml)) {
                addElement(new ObjectElement(objectXml));
            }
        }
    }

    /** Items, players and projectiles can't be placed on a map. */
    private static function isPlaceable(objectXml:XML):Boolean {
        return (!(objectXml.hasOwnProperty("Item") || objectXml.hasOwnProperty("Player") || (objectXml.Class == "Projectile")));
    }
}
}
