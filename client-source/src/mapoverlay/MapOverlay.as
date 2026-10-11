package mapoverlay {
import com.company.assembleegameclient.map._0D_v;

import flash.display.Sprite;
import flash.utils.Dictionary;

/**
 * Layer above the map that holds speech balloons and floating text.
 * Updates each element every frame and removes the ones that expire.
 */
public class MapOverlay extends Sprite {

    /** Latest speech balloon per game object id (shared by all overlays). */
    private static var speechBalloons:Dictionary = new Dictionary();

    public var unusedDictionary:Dictionary;

    public function MapOverlay() {
        this.unusedDictionary = new Dictionary();
        mouseEnabled = false;
        mouseChildren = false;
    }

    public function addSpeechBalloon(balloon:SpeechBalloon):void {
        var previousBalloon:SpeechBalloon = speechBalloons[balloon.go_.objectId_];
        if (previousBalloon != null && contains(previousBalloon)) {
            removeChild(previousBalloon);
        }
        speechBalloons[balloon.go_.objectId_] = balloon;
        addChild(balloon);
    }

    public function draw(camera:_0D_v, time:int):void {
        var element:IMapOverlayElement;
        var index:int = 0;
        while (index < numChildren) {
            element = (getChildAt(index) as IMapOverlayElement);
            if (element == null || element.draw(camera, time)) {
                index++;
            } else {
                removeChildAt(index);
            }
        }
    }
}
}
