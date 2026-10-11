// Decompiled by AS3 Sorcerer 1.99
// http://www.as3sorcerer.com/

//_0D_n._iC_

package _0D_n {
import com.company.json.JSONCodec;

public class _iC_ implements _throw {

    public function _I_7(_arg1:Object):String {
        return (JSONCodec.encode(_arg1));
    }

    public function parse(_arg1:String):Object {
        return (JSONCodec.decode(_arg1));
    }

}
}//package _0D_n

