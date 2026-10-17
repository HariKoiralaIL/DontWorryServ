package com.company.assembleegameclient.ui {
import com.company.ui.SimpleText;
import com.company.util.AssetLibrary;
import com.company.util.GraphicHelper;
import com.company.util.MoreColorUtil;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.GraphicsPath;
import flash.display.GraphicsSolidFill;
import flash.display.IGraphicsData;
import flash.display.Sprite;
import flash.filters.ColorMatrixFilter;
import flash.geom.Point;

/**
 * Base class for a single item slot: draws the rounded background and, for an
 * empty slot, either the silhouette of the accepted item type or the slot's
 * hotkey number.
 */
public class Slot extends Sprite {

    public static const any_:int = 0;
    public static const sword_:int = 1;
    public static const dagger_:int = 2;
    public static const bow_:int = 3;
    public static const tome_:int = 4;
    public static const shield_:int = 5;
    public static const leatherArmor_:int = 6;
    public static const heavyArmor_:int = 7;
    public static const wand_:int = 8;
    public static const accessory_:int = 9;
    public static const potion_:int = 10;
    public static const spell_:int = 11;
    public static const holySeal_:int = 12;
    public static const cloak_:int = 13;
    public static const robe_:int = 14;
    public static const quiver_:int = 15;
    public static const helm_:int = 16;
    public static const staff_:int = 17;
    public static const poison_:int = 18;
    public static const skull_:int = 19;
    public static const trap_:int = 20;
    public static const orb_:int = 21;
    public static const prism_:int = 22;
    public static const scepter_:int = 23;
    public static const katana_:int = 24;
    public static const shuriken_:int = 25;
    public static const scythe_:int = 26;
    public static const heart_:int = 27;
    public static const bone_:int = 28;

    public static const WIDTH:int = 40;
    public static const HEIGHT:int = 40;
    public static const BORDER:int = 4;

    private static const OUTPUT_SLOT_TYPE:int = -10;
    private static const FILL_COLOR:uint = 0x4C4C4C;
    private static const HOTKEY_TEXT_COLOR:uint = 0x404040;
    /** Accessory item whose icon is not shifted left like the other accessories. */
    private static const UNSHIFTED_ACCESSORY_TYPE:int = 2878;

    private static const EMPTY_ICON_FILTER:ColorMatrixFilter = new ColorMatrixFilter(MoreColorUtil.solidColorMatrix(HOTKEY_TEXT_COLOR));

    /** Display names, indexed by slot type constant (any_ .. bone_). */
    private static const TYPE_NAMES:Array = [
        "Any", "Sword", "Dagger", "Bow", "Tome", "Shield", "Leather Armor", "Armor",
        "Wand", "Accessory", "Potion", "Spell", "Holy Seal", "Cloak", "Robe", "Quiver",
        "Helm", "Staff", "Poison", "Skull", "Trap", "Orb", "Prism", "Scepter",
        "Katana", "Shuriken", "Scythe", "Heart", "Bone"
    ];

    /** Silhouette shown in an empty slot: slot type -> [sprite sheet, index]. Potions have none. */
    private static const SLOT_ICONS:Object = {
        1: ["lofiObj5", 48],     // sword
        2: ["lofiObj5", 96],     // dagger
        3: ["lofiObj5", 80],     // bow
        4: ["lofiObj6", 80],     // tome
        5: ["lofiObj6", 112],    // shield
        6: ["lofiObj5", 0],      // leather armor
        7: ["lofiObj5", 32],     // heavy armor
        8: ["lofiObj5", 64],     // wand
        9: ["lofiObj", 44],      // accessory
        11: ["lofiObj6", 64],    // spell
        12: ["lofiObj6", 160],   // holy seal
        13: ["lofiObj6", 32],    // cloak
        14: ["lofiObj5", 16],    // robe
        15: ["lofiObj6", 48],    // quiver
        16: ["lofiObj6", 96],    // helm
        17: ["lofiObj5", 112],   // staff
        18: ["lofiObj6", 128],   // poison
        19: ["lofiObj6", 0],     // skull
        20: ["lofiObj6", 16],    // trap
        21: ["lofiObj6", 144],   // orb
        22: ["lofiObj6", 176],   // prism
        23: ["lofiObj6", 192],   // scepter
        24: ["lofiObj3", 512],   // katana
        25: ["lofiObj3", 547],   // shuriken
        26: ["lofiObj5", 208],   // scythe
        27: ["lofiObj5", 224],   // heart
        28: ["lofiObj6", 208]    // bone
    };

    /** Formerly _mb */
    public static function getSlotTypeName(slotType:int):String {
        if (slotType == OUTPUT_SLOT_TYPE) {
            return "Output";
        }
        if (slotType >= 0 && slotType < TYPE_NAMES.length) {
            return TYPE_NAMES[slotType];
        }
        return "Invalid Type!";
    }

    public var type_:int;
    /** Number drawn in an empty slot (the slot's hotkey); formerly _ws. */
    public var hotkeyNumber_:int;
    /** Which of the four corners are rounded; formerly _07i. */
    public var corners_:Array;
    /** Silhouette / number bitmap of an empty slot; formerly _0H_K_. */
    public var emptyIcon_:Bitmap;
    public var equipment_:Boolean;

    /** Formerly _04c */
    protected var fill_:GraphicsSolidFill = new GraphicsSolidFill(FILL_COLOR, 1);
    protected var path_:GraphicsPath = new GraphicsPath(new Vector.<int>(), new Vector.<Number>());
    private var graphicsData_:Vector.<IGraphicsData> = new <IGraphicsData>[fill_, path_, GraphicHelper.END_FILL];

    public function Slot(type:int, hotkeyNumber:int, corners:Array, equipment:Boolean = false) {
        super();
        this.type_ = type;
        this.hotkeyNumber_ = hotkeyNumber;
        this.corners_ = corners;
        this.equipment_ = equipment;
        this.redraw();
    }

    /**
     * Pixel offset for an item (or empty-slot) icon; some slot types need a nudge.
     * Formerly _H_K_
     */
    protected function getIconOffset(itemType:int, slotType:int, emptyIcon:Boolean):Point {
        var offset:Point = new Point();
        switch (slotType) {
            case accessory_:
                offset.x = (itemType == UNSHIFTED_ACCESSORY_TYPE) ? 0 : -2;
                offset.y = emptyIcon ? -2 : 0;
                break;
            case spell_:
                offset.y = -2;
                break;
        }
        return offset;
    }

    /** Formerly _rC_ */
    protected function redraw():void {
        GraphicHelper.clearPath(this.path_);
        GraphicHelper.drawUI(0, 0, WIDTH, HEIGHT, 4, this.corners_, this.path_);
        graphics.clear();
        graphics.drawGraphicsData(this.graphicsData_);
        if (this.emptyIcon_ != null) {
            return;
        }
        var icon:BitmapData = null;
        var iconDef:Array = SLOT_ICONS[this.type_];
        if (iconDef != null) {
            icon = AssetLibrary.getImageFromSet(iconDef[0], iconDef[1]);
        }
        if (icon != null) {
            var offset:Point = this.getIconOffset(-1, this.type_, true);
            this.emptyIcon_ = new Bitmap(icon);
            this.emptyIcon_.x = BORDER + offset.x;
            this.emptyIcon_.y = BORDER + offset.y;
            this.emptyIcon_.scaleX = 4;
            this.emptyIcon_.scaleY = 4;
            this.emptyIcon_.filters = [EMPTY_ICON_FILTER];
            addChild(this.emptyIcon_);
        } else if (this.hotkeyNumber_ > 0) {
            var numberText:SimpleText = new SimpleText(26, HOTKEY_TEXT_COLOR, false, 0, 0, "Myriad Pro");
            numberText.text = String(this.hotkeyNumber_);
            numberText.setBold(true);
            numberText.updateMetrics();
            var numberImage:BitmapData = new BitmapData(26, 30, true, 0);
            numberImage.draw(numberText);
            this.emptyIcon_ = new Bitmap(numberImage);
            this.emptyIcon_.x = (WIDTH / 2) - (numberText.width / 2);
            this.emptyIcon_.y = (HEIGHT / 2) - 18;
            addChild(this.emptyIcon_);
        }
    }
}
}
