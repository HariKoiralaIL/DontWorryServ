package client.ui.panels {
import com.company.assembleegameclient.game.GameSprite;
import com.company.assembleegameclient.objects.Container;
import com.company.assembleegameclient.ui.Inventory;
import com.company.assembleegameclient.ui.Slot;

/** Shows the 8 slots of a loot container (bag, chest). */
public class ContainerPanel extends Panel {

    private static const SLOT_TYPES:Vector.<int> =
            new <int>[Slot.any_, Slot.any_, Slot.any_, Slot.any_, Slot.any_, Slot.any_, Slot.any_, Slot.any_];

    public var inventory:Inventory;

    public function ContainerPanel(gs:GameSprite, container:Container) {
        super(gs);
        this.inventory = new Inventory(gs_, container, container._include(), SLOT_TYPES, 8, false);
        this.inventory.x = 8;
        addChild(this.inventory);
    }

    override public function draw():void {
        // Inventory._iA_ is the container the inventory belongs to.
        this.inventory.draw(this.inventory._iA_.equipment_);
    }
}
}
