package game.signals {
    import signals.Signal;
    import services.AnalyticsEvent;

    public class AnalyticsEventSignal extends Signal {

        public function AnalyticsEventSignal() {
            super(AnalyticsEvent);
        }
    }
}
