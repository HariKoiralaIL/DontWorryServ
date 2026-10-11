package mediators
{
    import mediators.IMediatorMapper;
    import mediators.IMediatorUnmapper;

    import matching.ITypeMatcher;

    public interface IMediatorMap
    {
        function mapMatcher(matcher:ITypeMatcher):IMediatorMapper;

        function map(type:Class):IMediatorMapper;

        function unmapMatcher(matcher:ITypeMatcher):IMediatorUnmapper;

        function unmap(type:Class):IMediatorUnmapper;

        function mediate(item:Object):void;

        function unmediate(item:Object):void;
    }
}
