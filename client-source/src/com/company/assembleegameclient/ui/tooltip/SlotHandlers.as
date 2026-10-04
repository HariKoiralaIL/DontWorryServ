// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//com.company.assembleegameclient.ui.tooltip.SlotHandlers

package com.company.assembleegameclient.ui.tooltip {
import _05H_._09A_;
import _05H_._M_K_;

import com.company.assembleegameclient.ui.Slot;

import _05H_._A_Y_;
import _05H_._zr;
import _05H_._04E_;
import _05H_._implements;
import _05H_._L_m;
import _05H_._F_o;
import _05H_._oE_;
import _05H_._J_5;
import _05H_._M_;
import _05H_._X_7;
import _05H_._vD_;
import _05H_._5q;
import _05H_._W_C_;
import _05H_._U_y;

public class SlotHandlers {

    public function SlotHandlers() {
        var weapons_:_09A_ = new _09A_();
        var armors_:_M_K_ = new _M_K_();
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
        this.hash[Slot.tome_] = new _A_Y_();
        this.hash[Slot.shield_] = new _zr();
        this.hash[Slot.spell_] = new _04E_();
        this.hash[Slot.holySeal_] = new _implements();
        this.hash[Slot.cloak_] = new _L_m();
        this.hash[Slot.quiver_] = new _F_o();
        this.hash[Slot.helm_] = new _oE_();
        this.hash[Slot.poison_] = new _J_5();
        this.hash[Slot.skull_] = new _M_();
        this.hash[Slot.trap_] = new _X_7();
        this.hash[Slot.orb_] = new _vD_();
        this.hash[Slot.prism_] = new _5q();
        this.hash[Slot.scepter_] = new _W_C_();
        this.hash[Slot.heart_] = new _oE_();
    }
    private var hash:Object;

    public function buildData(_arg1:XML, xml:XML, _arg3:Object, _arg4:Object):SlotTooltipData {
        var _local3:int = int(_arg1.SlotType);
        var _U_y2:_U_y = this.hash[_local3];
        var slotTooltipData:SlotTooltipData = new SlotTooltipData();
        if (_U_y2 != null) {
            _U_y2._N_Q_(_arg1, xml);
            _U_y2._NQ_d_(_arg1, xml, _arg3, _arg4);
            slotTooltipData.text = _U_y2._t4;
            slotTooltipData._5n = _U_y2._5n;
            slotTooltipData._P_3 = _U_y2._P_3;
        }
        return (slotTooltipData);
    }

}
}//package com.company.assembleegameclient.ui.tooltip

