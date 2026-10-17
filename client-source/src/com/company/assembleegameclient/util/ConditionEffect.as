package com.company.assembleegameclient.util {
import com.company.util.AssetLibrary;
import com.company.util.PointUtil;

import flash.display.BitmapData;
import flash.filters.BitmapFilterQuality;
import flash.filters.GlowFilter;
import flash.geom.Matrix;

public class ConditionEffect {

    // Condition indices (bit position + 1)
    public static const NOTHING:uint = 0;
    public static const DEAD:uint = 1;
    public static const QUIET:uint = 2;
    public static const WEAK:uint = 3;
    public static const SLOWED:uint = 4;
    public static const SICK:uint = 5;
    public static const DAZED:uint = 6;
    public static const STUNNED:uint = 7;
    public static const BLIND:uint = 8;
    public static const HALLUCINATING:uint = 9;
    public static const DRUNK:uint = 10;
    public static const CONFUSED:uint = 11;
    public static const STUN_IMMUNE:uint = 12;
    public static const INVISIBLE:uint = 13;
    public static const PARALYZED:uint = 14;
    public static const SPEEDY:uint = 15;
    public static const BLEEDING:uint = 16;
    public static const NOT_USED:uint = 17;
    public static const HEALING:uint = 18;
    public static const DAMAGING:uint = 19;
    public static const BERSERK:uint = 20;
    public static const PAUSED:uint = 21;
    public static const STASIS:uint = 22;
    public static const STASIS_IMMUNE:uint = 23;
    public static const INVINCIBLE:uint = 24;
    public static const INVULNERABLE:uint = 25;
    public static const ARMORED:uint = 26;
    public static const ARMOR_BROKEN:uint = 27;
    public static const HEXED:uint = 28;
    public static const BLUR:uint = 29;

    // Condition bit flags
    public static const DEAD_BIT:uint = (1 << (DEAD - 1));
    public static const QUIET_BIT:uint = (1 << (QUIET - 1));
    public static const WEAK_BIT:uint = (1 << (WEAK - 1));
    public static const SLOWED_BIT:uint = (1 << (SLOWED - 1));
    public static const SICK_BIT:uint = (1 << (SICK - 1));
    public static const DAZED_BIT:uint = (1 << (DAZED - 1));
    public static const STUNNED_BIT:uint = (1 << (STUNNED - 1));
    public static const BLIND_BIT:uint = (1 << (BLIND - 1));
    public static const HALLUCINATING_BIT:uint = (1 << (HALLUCINATING - 1));
    public static const HEXED_BIT:uint = (1 << (HEXED - 1));
    public static const DRUNK_BIT:uint = (1 << (DRUNK - 1));
    public static const BLUR_BIT:uint = (1 << (BLUR - 1));
    public static const CONFUSED_BIT:uint = (1 << (CONFUSED - 1));
    public static const STUN_IMMUNE_BIT:uint = (1 << (STUN_IMMUNE - 1));
    public static const INVISIBLE_BIT:uint = (1 << (INVISIBLE - 1));
    public static const PARALYZED_BIT:uint = (1 << (PARALYZED - 1));
    public static const SPEEDY_BIT:uint = (1 << (SPEEDY - 1));
    public static const BLEEDING_BIT:uint = (1 << (BLEEDING - 1));
    public static const NOT_USED_BIT:uint = (1 << (NOT_USED - 1));
    public static const HEALING_BIT:uint = (1 << (HEALING - 1));
    public static const DAMAGING_BIT:uint = (1 << (DAMAGING - 1));
    public static const BERSERK_BIT:uint = (1 << (BERSERK - 1));
    public static const PAUSED_BIT:uint = (1 << (PAUSED - 1));
    public static const STASIS_BIT:uint = (1 << (STASIS - 1));
    public static const STASIS_IMMUNE_BIT:uint = (1 << (STASIS_IMMUNE - 1));
    public static const INVINCIBLE_BIT:uint = (1 << (INVINCIBLE - 1));
    public static const INVULNERABLE_BIT:uint = (1 << (INVULNERABLE - 1));
    public static const ARMORED_BIT:uint = (1 << (ARMORED - 1));
    public static const ARMOR_BROKEN_BIT:uint = (1 << (ARMOR_BROKEN - 1));

    /**
     * Conditions that are shown as status icons (inferred from usage: every condition with an icon
     * except Hexed, which shares Hallucinating's icon).
     */
    public static const ICON_BITMASK:uint = (QUIET_BIT | WEAK_BIT | SLOWED_BIT | SICK_BIT | DAZED_BIT | STUNNED_BIT | BLIND_BIT | HALLUCINATING_BIT | DRUNK_BIT | BLUR_BIT | CONFUSED_BIT | PARALYZED_BIT | SPEEDY_BIT | BLEEDING_BIT | HEALING_BIT | DAMAGING_BIT | BERSERK_BIT | INVULNERABLE_BIT | ARMORED_BIT | ARMOR_BROKEN_BIT);

    /** Conditions that distort or dim the rendered map (drunk, blur, blind, paused). */
    public static const MAP_FILTER_BITMASK:uint = ((DRUNK_BIT | BLUR_BIT | BLIND_BIT) | PAUSED_BIT);

    private static const GLOW_FILTER:GlowFilter = new GlowFilter(0, 0.3, 6, 6, 2, BitmapFilterQuality.LOW, false, false);

    public static var effects_:Vector.<ConditionEffect> = new <ConditionEffect>[
        new ConditionEffect("Nothing", 0, null),
        new ConditionEffect("Dead", DEAD_BIT, null),
        new ConditionEffect("Quiet", QUIET_BIT, [32]),
        new ConditionEffect("Weak", WEAK_BIT, [34, 35, 36, 37]),
        new ConditionEffect("Slowed", SLOWED_BIT, [1]),
        new ConditionEffect("Sick", SICK_BIT, [39]),
        new ConditionEffect("Dazed", DAZED_BIT, [44]),
        new ConditionEffect("Stunned", STUNNED_BIT, [45]),
        new ConditionEffect("Blind", BLIND_BIT, [41]),
        new ConditionEffect("Hallucinating", HALLUCINATING_BIT, [42]),
        new ConditionEffect("Drunk", DRUNK_BIT, [43]),
        new ConditionEffect("Confused", CONFUSED_BIT, [2]),
        new ConditionEffect("Stun Immume", STUN_IMMUNE_BIT, null),
        new ConditionEffect("Invisible", INVISIBLE_BIT, null),
        new ConditionEffect("Paralyzed", PARALYZED_BIT, [53, 54]),
        new ConditionEffect("Speedy", SPEEDY_BIT, [0]),
        new ConditionEffect("Bleeding", BLEEDING_BIT, [46]),
        new ConditionEffect("Not Used", NOT_USED_BIT, null),
        new ConditionEffect("Healing", HEALING_BIT, [47]),
        new ConditionEffect("Damaging", DAMAGING_BIT, [49]),
        new ConditionEffect("Berserk", BERSERK_BIT, [50]),
        new ConditionEffect("Paused", PAUSED_BIT, null),
        new ConditionEffect("Stasis", STASIS_BIT, null),
        new ConditionEffect("Stasis Immune", STASIS_IMMUNE_BIT, null),
        new ConditionEffect("Invincible", INVINCIBLE_BIT, null),
        new ConditionEffect("Invulnerable", INVULNERABLE_BIT, [17]),
        new ConditionEffect("Armored", ARMORED_BIT, [16]),
        new ConditionEffect("Armor Broken", ARMOR_BROKEN_BIT, [55]),
        new ConditionEffect("blureffect", BLUR_BIT, [56]),
        new ConditionEffect("Hexed", HEXED_BIT, [42])
    ];

    private static var indexByName_:Object = null;
    private static var iconsByBit_:Object = null;

    /** Returns the index of the effect with the given name in effects_. */
    public static function getIndexByName(name:String):uint {
        var i:uint;
        if (indexByName_ == null) {
            indexByName_ = {};
            i = 0;
            while (i < effects_.length) {
                indexByName_[effects_[i].name_] = i;
                i++;
            }
        }
        return indexByName_[name];
    }

    /**
     * Adds one icon for every condition bit set in `conditions` to `icons`.
     * @param frame used to pick between animated icon variants of a condition
     */
    public static function addConditionIcons(conditions:uint, icons:Vector.<BitmapData>, frame:int):void {
        var remaining:uint;
        var lowestBit:uint;
        var bitIcons:Vector.<BitmapData>;
        while (conditions != 0) {
            remaining = (conditions & (conditions - 1));
            lowestBit = (conditions ^ remaining);
            bitIcons = getIconsForBit(lowestBit);
            if (bitIcons != null) {
                icons.push(bitIcons[(frame % bitIcons.length)]);
            }
            conditions = remaining;
        }
    }

    private static function getIconsForBit(bit:uint):Vector.<BitmapData> {
        var translation:Matrix;
        var i:uint;
        var icons:Vector.<BitmapData>;
        var j:int;
        var icon:BitmapData;
        if (iconsByBit_ == null) {
            iconsByBit_ = {};
            translation = new Matrix();
            translation.translate(4, 4);
            i = 0;
            while (i < effects_.length) {
                icons = null;
                if (effects_[i].iconOffsets_ != null) {
                    icons = new Vector.<BitmapData>();
                    j = 0;
                    while (j < effects_[i].iconOffsets_.length) {
                        icon = new BitmapData(16, 16, true, 0);
                        icon.draw(AssetLibrary.getImageFromSet("lofiInterface2", effects_[i].iconOffsets_[j]), translation);
                        icon = TextureRedrawer.outlineGlow(icon, 0, 0xFFFFFFFF);
                        icon.applyFilter(icon, icon.rect, PointUtil.ORIGIN, GLOW_FILTER);
                        icons.push(icon);
                        j++;
                    }
                }
                iconsByBit_[effects_[i].bit_] = icons;
                i++;
            }
        }
        return iconsByBit_[bit];
    }

    public var name_:String;
    public var bit_:uint;
    public var iconOffsets_:Array;

    public function ConditionEffect(name:String, bit:uint, iconOffsets:Array) {
        this.name_ = name;
        this.bit_ = bit;
        this.iconOffsets_ = iconOffsets;
    }

}
}
