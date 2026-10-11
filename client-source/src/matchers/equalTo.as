package matchers {
import matchers.Matcher;

public function equalTo(value:Object):Matcher {
    return new IsEqual(value);
}
}
