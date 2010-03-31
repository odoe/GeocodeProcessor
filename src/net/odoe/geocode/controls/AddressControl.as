package net.odoe.geocode.controls
{
    import net.odoe.geocode.models.GeoModel;
    import net.odoe.geocode.models.vo.Address;

    import org.swizframework.core.IDispatcherAware;

    import flash.events.IEventDispatcher;

    public class AddressControl implements IDispatcherAware
    {
        [Inject]
        public var model:GeoModel;

        public function set dispatcher(dispatcher:IEventDispatcher):void
        {
        }

        [Mediate(event="geocodeAddress", properties="address")]
        public function locateAddress(address:Address):void
        {
            // Set the model Address object, in turn, updates the GeocodeProcessor
            model.address = address;
        }

    }
}

