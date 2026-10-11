package mapeditor {

public class ObjectToolTip extends ChooserToolTip {

    public function ObjectToolTip(objectXml:XML) {
        super(0x2A2A2A, String(objectXml.@id));
        setDescription(buildDescription(objectXml));
    }

    private static function buildDescription(objectXml:XML):String {
        var projectileXml:XML;
        var description:String = "";
        if (objectXml.hasOwnProperty("Group")) {
            description += (("Group: " + objectXml.Group) + "\n");
        }
        if (objectXml.hasOwnProperty("Static")) {
            description += "Static\n";
        }
        if (objectXml.hasOwnProperty("Enemy")) {
            description += "Enemy\n";
            if (objectXml.hasOwnProperty("MaxHitPoints")) {
                description += (("MaxHitPoints: " + objectXml.MaxHitPoints) + "\n");
            }
            if (objectXml.hasOwnProperty("Defense")) {
                description += (("Defense: " + objectXml.Defense) + "\n");
            }
        }
        if (objectXml.hasOwnProperty("God")) {
            description += "God\n";
        }
        if (objectXml.hasOwnProperty("Quest")) {
            description += "Quest\n";
        }
        if (objectXml.hasOwnProperty("Hero")) {
            description += "Hero\n";
        }
        if (objectXml.hasOwnProperty("Encounter")) {
            description += "Encounter\n";
        }
        if (objectXml.hasOwnProperty("Level")) {
            description += (("Level: " + objectXml.Level) + "\n");
        }
        if (objectXml.hasOwnProperty("Terrain")) {
            description += (("Terrain: " + objectXml.Terrain) + "\n");
        }
        for each (projectileXml in objectXml.Projectile) {
            description += describeProjectile(projectileXml);
        }
        return (description);
    }

    private static function describeProjectile(projectileXml:XML):String {
        var description:String = ("Projectile " + projectileXml.@id + ": " + projectileXml.ObjectId + "\n");
        description += ("\tDamage: " + projectileXml.Damage + "\n");
        description += ("\tSpeed: " + projectileXml.Speed + "\n");
        if (projectileXml.hasOwnProperty("PassesCover")) {
            description += "\tPassesCover\n";
        }
        if (projectileXml.hasOwnProperty("MultiHit")) {
            description += "\tMultiHit\n";
        }
        if (projectileXml.hasOwnProperty("ConditionEffect")) {
            description += (((("\t" + projectileXml.ConditionEffect) + " for ") + projectileXml.ConditionEffect.@duration) + " secs\n");
        }
        if (projectileXml.hasOwnProperty("Parametric")) {
            description += "\tParametric\n";
        }
        return (description);
    }
}
}
