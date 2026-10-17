package com.company.assembleegameclient.ui.tooltip {
import com.company.assembleegameclient.objects.GameObject;
import com.company.assembleegameclient.ui.GameObjectListItem;
import com.company.ui.SimpleText;

import flash.filters.DropShadowFilter;

public class QuestToolTip extends ToolTip {

    private static const BACKGROUND_COLOR:uint = 0x5C1D1D;
    private static const QUEST_COLOR:uint = 0xFC8642;

    public var playerEntry_:GameObjectListItem;
    private var text_:SimpleText;

    public function QuestToolTip(gameObject:GameObject) {
        super(BACKGROUND_COLOR, 1, QUEST_COLOR, 1, false);
        text_ = new SimpleText(22, QUEST_COLOR, false, 0, 0, "Myriad Pro");
        text_.setBold(true);
        text_.text = "Quest!";
        text_.updateMetrics();
        text_.filters = [new DropShadowFilter(0, 0, 0)];
        text_.x = 0;
        text_.y = 0;
        addChild(text_);
        playerEntry_ = new GameObjectListItem(0xB3B3B3, true, gameObject);
        playerEntry_.x = 0;
        playerEntry_.y = 32;
        addChild(playerEntry_);
        filters = [];
    }

}
}
