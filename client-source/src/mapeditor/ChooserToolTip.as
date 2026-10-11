package mapeditor {
import com.company.assembleegameclient.ui.tooltip.ToolTip;
import com.company.ui.SimpleText;

import flash.filters.DropShadowFilter;

/** Shared layout for the Ground/Object/Region tooltips: a bold title with an optional description below. */
public class ChooserToolTip extends ToolTip {

    protected static const TOOLTIP_WIDTH:int = 180;

    public function ChooserToolTip(backgroundColor:uint, title:String) {
        super(backgroundColor, 1, 0x9B9B9B, 1, true);
        this.titleText_ = new SimpleText(16, 0xFFFFFF, false, (TOOLTIP_WIDTH - 4), 0, "Myriad Pro");
        this.titleText_.setBold(true);
        this.titleText_.wordWrap = true;
        this.titleText_.text = title;
        this.titleText_._08S_();
        this.titleText_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        this.titleText_.x = 0;
        this.titleText_.y = 0;
        addChild(this.titleText_);
    }
    private var titleText_:SimpleText;
    private var descriptionText_:SimpleText;

    protected function setDescription(description:String):void {
        this.descriptionText_ = new SimpleText(14, 0xB3B3B3, false, TOOLTIP_WIDTH, 0, "Myriad Pro");
        this.descriptionText_.wordWrap = true;
        this.descriptionText_.text = description;
        this.descriptionText_._08S_();
        this.descriptionText_.filters = [new DropShadowFilter(0, 0, 0, 0.5, 12, 12)];
        this.descriptionText_.x = 0;
        this.descriptionText_.y = (this.titleText_.height + 2);
        addChild(this.descriptionText_);
    }

}
}
