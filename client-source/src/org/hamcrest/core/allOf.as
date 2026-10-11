package org.hamcrest.core {
import _qj._pn;

/**
 * Creates a matcher that matches only if all the given matchers match.
 * Accepts the matchers either as separate arguments or as one Array.
 */
public function allOf(...matchers):_pn {
    var matcherList:Array = matchers;
    if (matchers.length == 1 && matchers[0] is Array) {
        matcherList = matchers[0];
    }
    return new AllOfMatcher(matcherList);
}
}
