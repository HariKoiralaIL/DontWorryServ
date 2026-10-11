package picturebrowser {
import game.dialogs.Dialog;

/**
 * "Are you sure?" dialog shown before a picture is deleted on the server.
 */
public class DeletePictureConfirmDialog extends Dialog {

    private static const TITLE:String = "Delete Picture";
    private static const CANCEL_LABEL:String = "Cancel";
    private static const DELETE_LABEL:String = "Delete";
    private static const TRACKING_PATH:String = "/deletePicture";

    public var pictureId:int;

    public function DeletePictureConfirmDialog(pictureName:String, pictureId:int) {
        super('Are you sure you want to delete "' + pictureName + '"?  ' + "This can not be undone.",
                TITLE, CANCEL_LABEL, DELETE_LABEL, TRACKING_PATH);
        this.pictureId = pictureId;
    }
}
}
