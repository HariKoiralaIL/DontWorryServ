package jsonserializer {

/** Gives out one shared IJsonSerializer, created on first use. */
public class JsonSerializerProvider {

    private static var serializer:IJsonSerializer;

    public static function getSerializer():IJsonSerializer {
        if (serializer == null) {
            serializer = new JsonSerializer();
        }
        return serializer;
    }

}
}//package jsonserializer
