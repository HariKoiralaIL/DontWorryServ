package robotlegs.bender.framework.api {
/** An Error that carries two extra detail objects alongside its message. */
public class FrameworkError extends Error {

    private var firstDetail_:Object;
    private var secondDetail_:Object;

    public function FrameworkError(message:String, firstDetail:*, secondDetail:*) {
        super(message);
        this.firstDetail_ = firstDetail;
        this.secondDetail_ = secondDetail;
    }

    public function get firstDetail():Object {
        return (this.firstDetail_);
    }

    public function get secondDetail():Object {
        return (this.secondDetail_);
    }

}
}//package robotlegs.bender.framework.api
