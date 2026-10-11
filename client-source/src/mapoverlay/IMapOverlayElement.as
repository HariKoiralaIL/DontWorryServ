package mapoverlay {
import com.company.assembleegameclient.map._0D_v;

/**
 * Something drawn on the map overlay (a speech balloon, floating text...).
 */
public interface IMapOverlayElement {

    /**
     * Updates the element for the current frame.
     * @return false when the element has expired and should be removed.
     */
    function draw(camera:_0D_v, time:int):Boolean;
}
}
