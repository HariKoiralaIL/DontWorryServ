package mapeditor {
import com.company.assembleegameclient.objects.ObjectLibrary;
import com.company.util.StringUtil;

internal class ObjectChooser extends Chooser {

    public function ObjectChooser() {
        var id:String;
        var type:int;
        var objectXml:XML;
        super(MapLayer.OBJECT);
        var sortedIds:Vector.<String> = new Vector.<String>();
        for (id in ObjectLibrary.idToType_) {
            sortedIds.push(id);
        }
        sortedIds.sort(StringUtil.compare);
        for each (id in sortedIds) {
            type = ObjectLibrary.idToType_[id];
            objectXml = ObjectLibrary.typeToXML_[type];
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
