package spriteeditor {

/** The kinds of texture a sprite can be saved as. */
public class TextureCategory {

    public static const INVALID:int = 0;
    public static const CHARACTER:int = 1;
    public static const ITEM:int = 2;
    public static const ENVIRONMENT:int = 3;
    public static const PROJECTILE:int = 4;
    public static const TEXTILE:int = 5;
    public static const INTERFACE:int = 6;
    public static const MISCELLANEOUS:int = 7;

    /** Indexed by the constants above. */
    public static const CATEGORIES:Vector.<TextureCategory> = new <TextureCategory>[new TextureCategory("Any Type", ""), new TextureCategory("Character", "(e.g. humans, orcs, slimes, etc.)"), new TextureCategory("Item", "(e.g. swords, armor, rings, etc.)"), new TextureCategory("Environment", "(e.g. trees, rocks, portals, etc.)"), new TextureCategory("Projectile", "(e.g. arrows, magic bolts, etc.)"), new TextureCategory("Textile", "(clothing for players)"), new TextureCategory("Interface", "(e.g. icons, etc.)"), new TextureCategory("Miscellaneous", "(anything else)")];

    public var name_:String;
    public var examples_:String;

    /** Returns the category index for a display name, or INVALID if none matches. */
    public static function indexOfName(name:String):int {
        var i:int;
        while (i < CATEGORIES.length) {
            if (CATEGORIES[i].name_ == name) {
                return (i);
            }
            i++;
        }
        return (INVALID);
    }

    public function TextureCategory(name:String, examples:String) {
        this.name_ = name;
        this.examples_ = examples;
    }

}
}//package spriteeditor
