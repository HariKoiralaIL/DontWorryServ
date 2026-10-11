package game.dialogs {
    import flash.display.Sprite;
    import flash.events.Event;

    import signals.Signal;

    public class DeleteCharacterConfirmation extends Sprite {

        private static const MESSAGE_TEMPLATE:String = "Are you really sure you want to delete ${NAME} the ${DISPLAYID}?";

        public var deleteCharacter:Signal = new Signal();
        public var cancel:Signal = new Signal();

        public function show(name:String, displayId:String):void {
            var message:String = MESSAGE_TEMPLATE.replace("${NAME}", name).replace("${DISPLAYID}", displayId);
            var dialog:Dialog = new Dialog(message, "Verify Deletion", "Cancel", "Delete", "/deleteDialog");
            dialog.addEventListener(Dialog.BUTTON1_EVENT, this.onCancel);
            dialog.addEventListener(Dialog.BUTTON2_EVENT, this.onDelete);
            addChild(dialog);
        }

        private function onCancel(e:Event):void {
            this.cancel.dispatch();
        }

        private function onDelete(e:Event):void {
            this.deleteCharacter.dispatch();
        }
    }
}
