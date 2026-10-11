package beginnersoffer {
import flash.display.Sprite;

/**
 * Factory for the translucent black rounded rectangle used behind buttons.
 */
public class RoundedBackground {

    private static const DEFAULT_WIDTH:Number = 89;
    private static const DEFAULT_HEIGHT:Number = 25;
    private static const CORNER_RADIUS:Number = 12;
    private static const FILL_COLOR:uint = 0;
    private static const FILL_ALPHA:Number = 0.4;

    public static function create(width:Number = DEFAULT_WIDTH, height:Number = DEFAULT_HEIGHT):Sprite {
        var background:Sprite = new Sprite();
        background.graphics.beginFill(FILL_COLOR, FILL_ALPHA);
        background.graphics.drawRoundRect(0, 0, width, height, CORNER_RADIUS, CORNER_RADIUS);
        background.graphics.endFill();
        return background;
    }
}
}
