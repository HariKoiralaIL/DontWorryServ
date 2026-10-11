package client.signals.typed {
import client.game.GameInitData;

import signals.Signal;

/** Signal carrying the GameInitData needed to connect to a game. */
public class GameInitSignal extends Signal {

    public function GameInitSignal() {
        super(GameInitData);
    }

}
}
