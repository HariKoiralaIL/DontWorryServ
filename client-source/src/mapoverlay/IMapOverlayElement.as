package mapoverlay {
import com.company.assembleegameclient.map.GameCamera;

/**
 * Something drawn on the map overlay (a speech balloon, floating text...).
 */
public interface IMapOverlayElement {

    /**
     * Updates the element for the current frame.
     * @return false when the element has expired and should be removed.
     */
    function draw(camera:GameCamera, time:int):Boolean;
}
}
