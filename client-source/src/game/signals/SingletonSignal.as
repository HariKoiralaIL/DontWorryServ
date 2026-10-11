package game.signals {
    import signals.Signal;

    public class SingletonSignal extends Signal {

        public static var instance:SingletonSignal;

        public function SingletonSignal() {
            instance = this;
        }
    }
}
