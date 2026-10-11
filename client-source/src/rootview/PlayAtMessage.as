package rootview {
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

/** Centered "Play at <site>" notice with a link. */
public class PlayAtMessage extends Sprite {

    private static const MESSAGE_HTML:String = ((('<p align="center"><font color="#FFFFFF">Play at: ' + '<br/></font><font color="#7777EE">') + '<a href="http://realm.kithio.com/">') + "realm.kithio.com</font></a></p>");

    public function PlayAtMessage() {
        var textField:TextField = new TextField();
        textField.selectable = false;
        var format:TextFormat = new TextFormat();
        format.size = 20;
        textField.defaultTextFormat = format;
        textField.htmlText = MESSAGE_HTML;
        textField.width = 800;
        textField.y = ((600 / 2) - (textField.height / 2));
        addChild(textField);
    }

}
}//package rootview
