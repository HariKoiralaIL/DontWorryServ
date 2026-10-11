package commandmap
{
    import commands.ICommandMapper;
    import commands.ICommandUnmapper;

    public interface ISignalCommandMap
    {
        function map(signalClass:Class, once:Boolean = false):ICommandMapper;

        function unmap(signalClass:Class):ICommandUnmapper;
    }
}
