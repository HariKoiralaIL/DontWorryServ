// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_D_d.ObjectToolTip

package _D_d {
import com.company.assembleegameclient.ui.tooltip.ToolTip;

import com.company.ui.SimpleText;

import flash.filters.DropShadowFilter;

public class ObjectToolTip extends ToolTip {

    private static const TOOLTIP_WIDTH:int = 180;

    public function ObjectToolTip(objectXml:XML) {
        var projectileXml:XML;
        super(0x2A2A2A, 1, 0x9B9B9B, 1, true);
        this.nameText_ = new SimpleText(16, 0xFFFFFF, false, (TOOLTIP_WIDTH - 4), 0, "Myriad Pro");
        this.nameText_.setBold(true);
        this.nameText_.wordWrap = true;
        this.nameText_.text = String(objectXml.@id);
        this.nameText_._08S_();
        this.nameText_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        this.nameText_.x = 0;
        this.nameText_.y = 0;
        addChild(this.nameText_);
        var description = "";
        if (objectXml.hasOwnProperty("Group")) {
            description = (description + (("Group: " + objectXml.Group) + "\n"));
        }
        if (objectXml.hasOwnProperty("Static")) {
            description = (description + "Static\n");
        }
        if (objectXml.hasOwnProperty("Enemy")) {
            description = (description + "Enemy\n");
            if (objectXml.hasOwnProperty("MaxHitPoints")) {
                description = (description + (("MaxHitPoints: " + objectXml.MaxHitPoints) + "\n"));
            }
            if (objectXml.hasOwnProperty("Defense")) {
                description = (description + (("Defense: " + objectXml.Defense) + "\n"));
            }
        }
        if (objectXml.hasOwnProperty("God")) {
            description = (description + "God\n");
        }
        if (objectXml.hasOwnProperty("Quest")) {
            description = (description + "Quest\n");
        }
        if (objectXml.hasOwnProperty("Hero")) {
            description = (description + "Hero\n");
        }
        if (objectXml.hasOwnProperty("Encounter")) {
            description = (description + "Encounter\n");
        }
        if (objectXml.hasOwnProperty("Level")) {
            description = (description + (("Level: " + objectXml.Level) + "\n"));
        }
        if (objectXml.hasOwnProperty("Terrain")) {
            description = (description + (("Terrain: " + objectXml.Terrain) + "\n"));
        }
        for each (projectileXml in objectXml.Projectile) {
            description = (description + (((((((((("Projectile " + projectileXml.@id) + ": ") + projectileXml.ObjectId) + "\n") + "\tDamage: ") + projectileXml.Damage) + "\n") + "\tSpeed: ") + projectileXml.Speed) + "\n"));
            if (projectileXml.hasOwnProperty("PassesCover")) {
                description = (description + "\tPassesCover\n");
            }
            if (projectileXml.hasOwnProperty("MultiHit")) {
                description = (description + "\tMultiHit\n");
            }
            if (projectileXml.hasOwnProperty("ConditionEffect")) {
                description = (description + (((("\t" + projectileXml.ConditionEffect) + " for ") + projectileXml.ConditionEffect.@duration) + " secs\n"));
            }
            if (projectileXml.hasOwnProperty("Parametric")) {
                description = (description + "\tParametric\n");
            }
        }
        this.descriptionText_ = new SimpleText(14, 0xB3B3B3, false, TOOLTIP_WIDTH, 0, "Myriad Pro");
        this.descriptionText_.wordWrap = true;
        this.descriptionText_.text = String(description);
        this.descriptionText_._08S_();
        this.descriptionText_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        this.descriptionText_.x = 0;
        this.descriptionText_.y = (this.nameText_.height + 2);
        addChild(this.descriptionText_);
    }
    private var nameText_:SimpleText;
    private var descriptionText_:SimpleText;
}
}//package _D_d

