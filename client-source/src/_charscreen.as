/**
 * Created by Mike on 17.05.2016.
 */
package {

  import menubackgrounds.SeasonalOverlay;
  import menubackgrounds.CharacterScreenBackground;
  import menubackgrounds.ScrollingMapBackground;

  import com.company.assembleegameclient.ui._zX_;

  import flash.display.Sprite;
    
    public class _charscreen extends Sprite
    {

      public function _charscreen()
      {
        addChild(new CharacterScreenBackground());
      }
    }
}
