package net.odoe.geocode.events
{
	import flash.events.Event;

	import net.odoe.geocode.models.vo.Address;

	public class GeoEvent extends Event
	{
		public static const GEOCODE_ADDRESS:String = "geocodeAddress";

		private var _address:Address;

		public function get address():Address
		{
			return _address;
		}

		public function GeoEvent(type:String, address:Address)
		{
			super(type, true, true);
			_address = address;
		}

		override public function clone():Event
		{
			return new GeoEvent(type, address);
		}

	}
}

