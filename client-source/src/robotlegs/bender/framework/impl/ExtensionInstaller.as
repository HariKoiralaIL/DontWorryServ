package robotlegs.bender.framework.impl {
import flash.utils.Dictionary;

import injection.reflection.DescribeTypeReflector;
import injection.reflection.Reflector;

import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.ILogger;

/**
 * Installs context extensions, making sure each extension class is installed only once.
 */
public class ExtensionInstaller {

    private const _uid:String = UID.create(ExtensionInstaller);
    private const _classes:Dictionary = new Dictionary(true);
    private const _reflector:Reflector = new DescribeTypeReflector();

    private var _context:IContext;
    private var _logger:ILogger;

    public function ExtensionInstaller(context:IContext) {
        _context = context;
        _logger = _context.getLogger(this);
    }

    public function install(extension:Object):void {
        var extensionClass:Class;
        if (extension is Class) {
            if (!_classes[extension]) {
                install(new (extension as Class)());
            }
        } else {
            extensionClass = _reflector.getClass(extension);
            if (_classes[extensionClass]) {
                return;
            }
            _logger.debug("Installing extension {0}", [extension]);
            _classes[extensionClass] = true;
            extension.extend(_context);
        }
    }

    public function toString():String {
        return _uid;
    }

}
}
