package matching {
public interface ITypeFilter {

    function get allOfTypes():Vector.<Class>;

    function get anyOfTypes():Vector.<Class>;

    function get descriptor():String;

    function get noneOfTypes():Vector.<Class>;

    function matches(item:*):Boolean;

}
}
