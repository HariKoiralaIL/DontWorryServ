package com.company.assembleegameclient.ui.tooltip {
import com.company.assembleegameclient.ui.Slot;
import com.company.assembleegameclient.ui.tooltip.handlers.ArmorStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.CloakStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.HelmStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.OrbStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.PoisonStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.PrismStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.QuiverStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.ScepterStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.SealStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.ShieldStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.SkullStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.SlotStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.SpellStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.TomeStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.TrapStatHandler;
import com.company.assembleegameclient.ui.tooltip.handlers.WeaponStatHandler;

/** Maps an item's SlotType to the handler that builds its comparison tooltip text. */
public class SlotHandlerRegistry {

    private var handlers_:Object = {};

    public function SlotHandlerRegistry() {
        register(new WeaponStatHandler(), Slot.staff_, Slot.wand_, Slot.bow_, Slot.sword_,
                Slot.dagger_, Slot.katana_, Slot.scythe_);
        register(new ArmorStatHandler(), Slot.robe_, Slot.leatherArmor_, Slot.heavyArmor_);

        register(new TomeStatHandler(), Slot.tome_);
        register(new ShieldStatHandler(), Slot.shield_);
        register(new SpellStatHandler(), Slot.spell_);
        register(new SealStatHandler(), Slot.holySeal_);
        register(new CloakStatHandler(), Slot.cloak_);
        register(new QuiverStatHandler(), Slot.quiver_);
        register(new PoisonStatHandler(), Slot.poison_);
        register(new SkullStatHandler(), Slot.skull_);
        register(new TrapStatHandler(), Slot.trap_);
        register(new OrbStatHandler(), Slot.orb_);
        register(new PrismStatHandler(), Slot.prism_);
        register(new ScepterStatHandler(), Slot.scepter_);
        register(new HelmStatHandler(), Slot.helm_, Slot.heart_);
    }

    public function buildData(itemXML:XML, curItemXML:XML, itemData:Object, curItemData:Object):SlotTooltipData {
        var slotType:int = int(itemXML.SlotType);
        var handler:SlotStatHandler = handlers_[slotType];
        var data:SlotTooltipData = new SlotTooltipData();
        if (handler != null) {
            handler.compare(itemXML, curItemXML);
            handler.compareWithData(itemXML, curItemXML, itemData, curItemData);
            data.text = handler.tooltipText;
            data.handledXml = handler.handledXml;
            data.onEquipText = handler.onEquipText;
        }
        return data;
    }

    private function register(handler:SlotStatHandler, ...slotTypes):void {
        for each (var slotType:int in slotTypes) {
            handlers_[slotType] = handler;
        }
    }

}
}
