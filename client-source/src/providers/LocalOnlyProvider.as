package providers {
public class LocalOnlyProvider extends ForwardingProvider {

    public function LocalOnlyProvider(provider:DependencyProvider) {
        super(provider);
    }

}
}
