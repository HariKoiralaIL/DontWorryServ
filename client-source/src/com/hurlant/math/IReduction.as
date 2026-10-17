package com.hurlant.math {

/** Modular reduction strategy used by BigInteger.exp / modPow. */
internal interface IReduction {

    /** Converts x into the reduction's internal representation. */
    function convert(x:BigInteger):BigInteger;

    /** Converts x back from the internal representation. */
    function revert(x:BigInteger):BigInteger;

    /** x = x mod m (in place). */
    function reduce(x:BigInteger):void;

    /** r = x * y mod m. */
    function mulTo(x:BigInteger, y:BigInteger, r:BigInteger):void;

    /** r = x^2 mod m. */
    function sqrTo(x:BigInteger, r:BigInteger):void;

}
}//package com.hurlant.math
