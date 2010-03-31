package net.odoe.geocode.models.vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;


	public class Address extends EventDispatcher
	{
		public var Street:String = "";
		public var City:String = "";
		public var State:String = "";
		public var Zip:String = "";
		public var Country:String = "";

		public function Address(street:String = "", city:String = "", state:String = "", zip:String = "", country:String = "")
		{
			Street = street;
			City = city;
			State = state;
			Zip = zip;
			Country = country;

			dispatchEvent(new Event("newAddress"));
		}

	}
}

