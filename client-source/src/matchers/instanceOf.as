package matchers {
import _qj._pn;

public function instanceOf(type:Class):_pn {
    return new IsInstanceOf(type);
}
}
