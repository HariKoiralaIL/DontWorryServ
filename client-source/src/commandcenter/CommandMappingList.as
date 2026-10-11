package commandcenter {
import commands.ICommandMapping;

public class CommandMappingList {

    protected var _head:ICommandMapping;

    public function get head():ICommandMapping {
        return _head;
    }

    public function set head(value:ICommandMapping):void {
        if (value !== _head) {
            _head = value;
        }
    }

    public function get tail():ICommandMapping {
        if (!_head) {
            return null;
        }
        var node:ICommandMapping = _head;
        while (node.next) {
            node = node.next;
        }
        return node;
    }

    public function remove(mapping:ICommandMapping):void {
        var node:ICommandMapping = _head;
        if (node == mapping) {
            _head = mapping.next;
        }
        while (node) {
            if (node.next == mapping) {
                node.next = mapping.next;
            }
            node = node.next;
        }
    }

}
}
