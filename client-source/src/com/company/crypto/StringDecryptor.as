package com.company.crypto {

// Formerly _07Y_. Obfuscator-generated string table: every string is stored as an
// XTEA-encrypted block of 32-bit words, and decrypt() recovers it at runtime.
//
// Callers pass two obfuscated ids rather than plain indices:
//   stringId -> table index = (stringId - 5) ^ -797
//   keyId    -> key index   = (keyId + 3) ^ -505
public class StringDecryptor {

    private static const DELTA:int = 0x9E3779B9;        // XTEA constant (2654435769)
    private static const ROUNDS:int = 32;
    private static const START_SUM:int = 0xC6EF3720;    // DELTA * ROUNDS, truncated to 32 bits

    // Encrypted strings (each row is a sequence of 32-bit word pairs).
    internal static const encryptedStrings:Array = [
        [311666135, -1457012600, 1552169150, 1761191443, 1317508674, 776738430, -1588178005, 2029631727, 1338972486, -1620444119, -1672367595, 292871495, 1709420458, -1341532070, -326175999, 1170165485, 1041343832, -1739450444, 86835192, -125443488, 124298107, -1950121449, -1071334808, 1777136119],
        [1223547426, 762788121, 539506893, 558537430, -1337053415, -1980376921, -1842993949, -1535713587, -1843842466, 259163649, 84883348, 134678728, -1806385275, -462877814, 629882654, 1428761042, 1941445202, 1892194447, 1719792257, -1038147660, -387118588, -1208698572, -1748832475, -1307519590, 1404560975, -1027492309, -186894239, 138167820]
    ];

    // 128-bit XTEA keys (four 32-bit words each).
    internal static const keys:Array = [
        [-2092417980, -1030642233, 816173022, 924850519],
        [1308192631, 1658084656, 1258542666, -1098201067]
    ];

    public static function decrypt(stringId:int, keyId:int):String {
        var words:Array = encryptedStrings[(stringId - 5) ^ -797];
        var key:Array = keys[(keyId + 3) ^ -505];
        var result:String = "";

        for (var i:int = 0; i < words.length; i += 2) {
            var v0:int = int(words[i]);
            var v1:int = int(words[i + 1]);
            var sum:int = START_SUM;
            for (var round:int = 0; round < ROUNDS; round++) {
                v1 -= (((v0 << 4) ^ (v0 >>> 5)) + v0) ^ (sum + int(key[(sum >>> 11) & 3]));
                sum -= DELTA;
                v0 -= (((v1 << 4) ^ (v1 >>> 5)) + v1) ^ (sum + int(key[sum & 3]));
            }
            result += String.fromCharCode(v0) + String.fromCharCode(v1);
        }

        // Strings are padded to an even length with a trailing NUL; strip it.
        if (result.charCodeAt(result.length - 1) == 0) {
            result = result.substring(0, result.length - 1);
        }
        return result;
    }
}
}
