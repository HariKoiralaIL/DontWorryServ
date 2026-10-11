package injection.mapping {

/** A mapping that can still be sealed to prevent further changes. */
public interface UnsealedMapping {

    /**
     * Locks the mapping against any further changes.
     * @return the key that is required to unseal it again.
     */
    function seal():Object;

}
}//package injection.mapping
