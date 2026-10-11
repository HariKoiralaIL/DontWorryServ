package game.signals {
    import signals.Signal;
    import com.company.assembleegameclient.ui.tooltip.ToolTip;

    public class ToolTipSignal extends Signal {

        public function ToolTipSignal() {
            super(ToolTip);
        }
    }
}
