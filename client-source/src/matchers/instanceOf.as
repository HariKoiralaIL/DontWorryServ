package matchers {
import matchers.Matcher;

public function instanceOf(type:Class):Matcher {
    return new IsInstanceOf(type);
}
}
