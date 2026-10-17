package com.company.util {
import flash.xml.XMLDocument;
import flash.xml.XMLNode;
import flash.xml.XMLNodeType;

public class XmlUtil {

    public static function unescapeXml(value:String):String {
        return new XMLDocument(value).firstChild.nodeValue;
    }

    public static function escapeXml(value:String):String {
        return XML(new XMLNode(XMLNodeType.TEXT_NODE, value)).toXMLString();
    }

}
}//package com.company.util
