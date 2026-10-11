package game.signals {
    import signals.Signal;
    import _011.MapInfo;

    public class MapInfoSignal extends Signal {

        private static var instance:MapInfoSignal;

        public static function getInstance():MapInfoSignal {
            if (!instance) {
                instance = new MapInfoSignal();
            }
            return instance;
        }

        public function MapInfoSignal() {
            super(MapInfo);
            instance = this;
        }
    }
}
