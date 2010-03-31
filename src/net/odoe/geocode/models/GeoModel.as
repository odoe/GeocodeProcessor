package net.odoe.geocode.models
{
    import net.odoe.geocode.models.vo.Address;

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;

    public class GeoModel extends EventDispatcher
    {
        public function GeoModel(target:IEventDispatcher=null)
        {
            super(target);
        }

        private var _address:Address = new Address("380 New York St", "Redlands", "CA", "92373", "USA");

        [Bindable("addressChanged")]
        public function get address():Address
        {
            return _address;
        }

        public function set address(value:Address):void
        {
            if (value != null)
            {
                _address = value;
                dispatchEvent(new Event("addressChanged"));
            }
        }
    }
}

