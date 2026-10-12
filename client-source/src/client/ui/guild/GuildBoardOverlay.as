// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//client.ui.guild.GuildBoardOverlay

package client.ui.guild {
    import flash.display.Sprite;
    import flash.display.Shape;

    import com.company.assembleegameclient.appengine.AppEngineClient;

    import game.dialogs.Dialog;

    import flash.display.Graphics;

    import com.company.assembleegameclient.parameters.Parameters;

    import events.GenericDataEvent;
    import events.TextErrorEvent;

    import account.Account;

    import flash.events.Event;

    import com.company.util._H_U_;

    public class GuildBoardOverlay extends Sprite {

        public function GuildBoardOverlay(_arg1:Boolean) {
            this.canEdit = _arg1;
            this.background = new Shape();
            var _local2:Graphics = this.background.graphics;
            _local2.clear();
            _local2.beginFill(0, 0.8);
            _local2.drawRect(0, 0, 800, 600);
            _local2.endFill();
            addChild(this.background);
            this.load();
        }
        private var canEdit:Boolean;
        private var background:Shape;
        private var request:AppEngineClient;
        private var statusDialog:Dialog;
        private var text_:String;
        private var viewer:GuildBoardViewer;
        private var editor:GuildBoardEditor;

        private function load():void {
            this.request = new AppEngineClient(Parameters._fK_(), "/guild", true);
            this.request.addEventListener(GenericDataEvent.GENERIC_DATA, this.onBoardLoaded);
            this.request.addEventListener(TextErrorEvent.TEXT_ERROR, this.onLoadError);
            this.request.sendRequest("getBoard", Account.getInstance().credentials());
            this.statusDialog = new Dialog("Loading...", null, null, null, null);
            addChild(this.statusDialog);
            this.background.visible = false;
        }

        private function show():void {
            this.viewer = new GuildBoardViewer(this.text_, this.canEdit);
            this.viewer.x = ((800 / 2) - (this.viewer.w_ / 2));
            this.viewer.y = ((600 / 2) - (this.viewer.h_ / 2));
            this.viewer.addEventListener(Event.COMPLETE, this.onViewerClose);
            this.viewer.addEventListener(Event.CHANGE, this.onViewerEdit);
            addChild(this.viewer);
        }

        private function onBoardLoaded(_arg1:GenericDataEvent):void {
            this.background.visible = true;
            removeChild(this.statusDialog);
            this.statusDialog = null;
            this.text_ = String(_arg1.data);
            this.show();
        }

        private function onLoadError(_arg1:TextErrorEvent):void {
        }

        private function onViewerClose(_arg1:Event):void {
            parent.removeChild(this);
        }

        private function onViewerEdit(_arg1:Event):void {
            removeChild(this.viewer);
            this.viewer = null;
            this.editor = new GuildBoardEditor(this.text_);
            this.editor.x = ((800 / 2) - (this.editor.w_ / 2));
            this.editor.y = ((600 / 2) - (this.editor.h_ / 2));
            this.editor.addEventListener(Event.CANCEL, this.onEditorCancel);
            this.editor.addEventListener(Event.COMPLETE, this.onEditorSave);
            addChild(this.editor);
        }

        private function onEditorCancel(_arg1:Event):void {
            removeChild(this.editor);
            this.editor = null;
            this.show();
        }

        private function onEditorSave(_arg1:Event):void {
            this.request = new AppEngineClient(Parameters._fK_(), "/guild", true);
            this.request.addEventListener(GenericDataEvent.GENERIC_DATA, this.onBoardSaved);
            this.request.addEventListener(TextErrorEvent.TEXT_ERROR, this.onSaveError);
            var _local2:Object = {"board": this.editor.getText()};
            _H_U_._t2(_local2, Account.getInstance().credentials());
            this.request.sendRequest("setBoard", _local2);
            removeChild(this.editor);
            this.editor = null;
            this.statusDialog = new Dialog("Saving...", null, null, null, null);
            addChild(this.statusDialog);
            this.background.visible = false;
        }

        private function onBoardSaved(_arg1:GenericDataEvent):void {
            this.background.visible = true;
            removeChild(this.statusDialog);
            this.statusDialog = null;
            this.text_ = String(_arg1.data);
            this.show();
        }

        private function onSaveError(_arg1:TextErrorEvent):void {
        }

    }
}//package client.ui.guild
