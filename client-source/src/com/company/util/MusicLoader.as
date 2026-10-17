package com.company.util {
import audio.ILoadable;
import audio.MusicManager;

/** Created by Thelzar on 6/18/2014. */
public class MusicLoader implements ILoadable {

    public function load():void {
        MusicManager.load();
    }

}
}
