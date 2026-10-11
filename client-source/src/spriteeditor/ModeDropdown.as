package spriteeditor {
import _zm.DropdownBox;

/** Chooses what kind of sprite is being edited. */
public class ModeDropdown extends DropdownBox {

    public static const OBJECTS:String = "Objects";
    public static const CHARACTERS:String = "Characters";
    public static const TEXTILES:String = "Textiles";

    public function ModeDropdown() {
        super(new <String>[OBJECTS, CHARACTERS, TEXTILES], 120, 26, "Mode");
    }
}
}//package spriteeditor
