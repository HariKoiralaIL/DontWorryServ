package org.hamcrest.core {
import matchers.Matcher;

/**
 * Creates a matcher that matches only if all the given matchers match.
 * Accepts the matchers either as separate arguments or as one Array.
 */
public function allOf(...args):Matcher {
        var matcherList:Array = args;
        if (args.length == 1 && args[0] is Array) {
                matcherList = args[0];
    }
    return new AllOfMatcher(matcherList);
}
}
