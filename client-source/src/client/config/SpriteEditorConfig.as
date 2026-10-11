// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.config.SpriteEditorConfig

package client.config {
import robotlegs.bender.framework.api.IConfig;

import mediators.IMediatorMap;

import spriteeditor.SpriteEditorScreen;

import spriteeditor.SpriteEditorScreenMediator;

public class SpriteEditorConfig implements IConfig {

    [Inject]
    public var mediatorMap:IMediatorMap;

    public function configure():void {
        this.mediatorMap.map(SpriteEditorScreen).toMediator(SpriteEditorScreenMediator);
    }

}
}//package client.config

