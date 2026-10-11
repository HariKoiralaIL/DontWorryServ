package mediators
{
    import matching.ITypeFilter;

    public interface IMediatorMapping
    {
        function get matcher():ITypeFilter;

        function get mediatorClass():Class;

        function get guards():Array;

        function get hooks():Array;

        function validate():void;
    }
}
