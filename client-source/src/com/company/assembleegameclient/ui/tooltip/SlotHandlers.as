// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.SlotHandlers

package com.company.assembleegameclient.ui.tooltip {
import com.company.assembleegameclient.ui.tooltip.handlers.WeaponStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.ArmorStatHandler;

import com.company.assembleegameclient.ui.Slot;

import com.company.assembleegameclient.ui.tooltip.handlers.TomeStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.ShieldStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.SpellStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.SealStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.CloakStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.QuiverStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.HelmStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.PoisonStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.SkullStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.TrapStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.OrbStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.PrismStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.ScepterStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.SlotStatHandler;

public class SlotHandlers {

    public function SlotHandlers() {
        var weapons_:WeaponStatHandler = new WeaponStatHandler();
        var armors_:ArmorStatHandler = new ArmorStatHandler();
        this.hash = {};

        /* Weapons */
        this.hash[Slot.staff_] = weapons_;
        this.hash[Slot.wand_] = weapons_;

        this.hash[Slot.bow_] = weapons_;

        this.hash[Slot.sword_] = weapons_;
        this.hash[Slot.dagger_] = weapons_;
        this.hash[Slot.katana_] = weapons_;
        this.hash[Slot.scythe_] = weapons_;

        /* Armours */
        this.hash[Slot.robe_] = armors_;
        this.hash[Slot.leatherArmor_] = armors_;
        this.hash[Slot.heavyArmor_] = armors_;

        /* Abilities */
        this.hash[Slot.tome_] = new TomeStatHandler();
        this.hash[Slot.shield_] = new ShieldStatHandler();
        this.hash[Slot.spell_] = new SpellStatHandler();
        this.hash[Slot.holySeal_] = new SealStatHandler();
        this.hash[Slot.cloak_] = new CloakStatHandler();
        this.hash[Slot.quiver_] = new QuiverStatHandler();
        this.hash[Slot.helm_] = new HelmStatHandler();
        this.hash[Slot.poison_] = new PoisonStatHandler();
        this.hash[Slot.skull_] = new SkullStatHandler();
        this.hash[Slot.trap_] = new TrapStatHandler();
        this.hash[Slot.orb_] = new OrbStatHandler();
        this.hash[Slot.prism_] = new PrismStatHandler();
        this.hash[Slot.scepter_] = new ScepterStatHandler();
        this.hash[Slot.heart_] = new HelmStatHandler();
    }
    private var hash:Object;

    public function buildData(xml2:XML, xml:XML, _arg3:Object, _arg4:Object):SlotTooltipData {
        var _local3:int = int(xml2.SlotType);
        var _U_y2:SlotStatHandler = this.hash[_local3];
        var slotTooltipData:SlotTooltipData = new SlotTooltipData();
        if (_U_y2 != null) {
            _U_y2._N_Q_(xml2, xml);
            _U_y2.compareWithData(xml2, xml, _arg3, _arg4);
            slotTooltipData.text = _U_y2.tooltipText;
            slotTooltipData.handledXml = _U_y2.handledXml;
            slotTooltipData.onEquipText = _U_y2.onEquipText;
        }
        return (slotTooltipData);
    }

}
}//package com.company.assembleegameclient.ui.tooltip

