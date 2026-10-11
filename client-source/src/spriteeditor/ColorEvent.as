package spriteeditor {
import flash.events.Event;

import client.util.color.HSV;

/** Dispatched by the palette when the user picks or drags over a color. */
public class ColorEvent extends Event {

    public static const COLOR_EVENT:String = "COLOR_EVENT";

    public var color_:HSV;

    public function ColorEvent(color:HSV) {
        super(COLOR_EVENT);
        this.color_ = color;
    }
}
}//package spriteeditor
