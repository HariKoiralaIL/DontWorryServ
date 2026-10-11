package mapeditor {

public class GroundToolTip extends ChooserToolTip {

    public function GroundToolTip(groundXml:XML) {
        super(0x2A2A2A, String(groundXml.@id));
        setDescription(buildDescription(groundXml));
    }

    private static function buildDescription(groundXml:XML):String {
        var description:String = "";
        if (groundXml.hasOwnProperty("Speed")) {
            description += (("Speed: " + Number(groundXml.Speed).toFixed(2)) + "\n");
        } else {
            description += "Speed: 1.00\n";
        }
        if (groundXml.hasOwnProperty("NoWalk")) {
            description += "Unwalkable\n";
        }
        if (groundXml.hasOwnProperty("Push")) {
            description += "Push\n";
        }
        if (groundXml.hasOwnProperty("Sink")) {
            description += "Sink\n";
        }
        if (groundXml.hasOwnProperty("Sinking")) {
            description += "Sinking\n";
        }
        if (groundXml.hasOwnProperty("Animate")) {
            description += "Animated\n";
        }
        if (groundXml.hasOwnProperty("RandomOffset")) {
            description += "Randomized\n";
        }
        return (description);
    }
}
}
