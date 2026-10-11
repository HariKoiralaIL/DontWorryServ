package client.ui.panels {
import com.company.assembleegameclient.parameters.Parameters;
import com.company.assembleegameclient.ui._0G_h;
import com.company.assembleegameclient.ui.ui_chat;
import com.company.ui.SimpleText;

import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.filters.DropShadowFilter;
import flash.text.TextFieldAutoSize;

/**
 * Helpers shared by the panels: label creation, the "Rank Required" widget
 * and the interact-key check. Every panel used to copy these by hand.
 */
public class PanelUtil {

    private static const FONT:String = "Myriad Pro";

    /**
     * Bold, white, drop-shadowed, horizontally centered label.
     *
     * @param text  text to show (wrapped in a centered paragraph)
     * @param size  font size
     * @param color text color
     * @param width field width (default: Panel.WIDTH)
     * @param wrap  enable word wrap / multiline
     */
    public static function createLabel(text:String, size:int = 18, color:uint = 0xFFFFFF,
                                       width:Number = -1, wrap:Boolean = true):SimpleText {
        if (width < 0) {
            width = Panel.WIDTH;
        }
        var label:SimpleText = new SimpleText(size, color, false, width, 0, FONT);
        label.setBold(true);
        label.htmlText = '<p align="center">' + text + "</p>";
        if (wrap) {
            label.wordWrap = true;
            label.multiline = true;
        }
        label.autoSize = TextFieldAutoSize.CENTER;
        label.filters = [new DropShadowFilter(0, 0, 0)];
        return label;
    }

    /** "Rank Required: [star icon]" widget. The caller positions it. */
    public static function createRankRequiredLabel(stars:int):Sprite {
        var holder:Sprite = new Sprite();
        var label:SimpleText = new SimpleText(16, 0xFFFFFF, false, 0, 0, FONT);
        label.setBold(true);
        label.text = "Rank Required:";
        label.updateMetrics();
        label.filters = [new DropShadowFilter(0, 0, 0)];
        holder.addChild(label);
        var rank:Sprite = new _0G_h(stars, false, false);
        rank.x = label.width + 4;
        rank.y = (label.height / 2) - (rank.height / 2);
        holder.addChild(rank);
        return holder;
    }

    /** True when the interact key was pressed and the player isn't typing in chat. */
    public static function isInteractKey(event:KeyboardEvent):Boolean {
        return event.keyCode == Parameters.data_.interact && !ui_chat._0G_B_;
    }
}
}
