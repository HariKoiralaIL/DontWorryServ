package providers {
public class SoftProvider extends ForwardingProvider {

    public function SoftProvider(provider:DependencyProvider) {
        super(provider);
    }

}
}
