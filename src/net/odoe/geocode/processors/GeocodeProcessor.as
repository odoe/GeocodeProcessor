package net.odoe.geocode.processors
{
    import net.odoe.geocode.models.vo.Address;

    import com.esri.ags.Graphic;
    import com.esri.ags.tasks.Locator;

    import org.swizframework.core.Bean;
    import org.swizframework.processors.BaseMetadataProcessor;
    import org.swizframework.reflection.IMetadataTag;

    import mx.collections.ArrayCollection;
    import mx.collections.ICollectionView;
    import mx.rpc.AsyncResponder;

    import flash.events.Event;

    public class GeocodeProcessor extends BaseMetadataProcessor
    {
        // Event string to let me know that an address has been updated
        public static const ADDRESS_UPDATED:String = "addressUpdated";

        // URL to geocoding service
        protected var geocodeURL:String = "http://tasks.arcgisonline.com/ArcGIS/rest/services/Locators/TA_Address_NA/GeocodeServer";

        public function GeocodeProcessor()
        {
            super(["Geocode"]);
        }

        protected var _currBean:Bean;

        // Need to save these, as I'll want to reuse them every time an address is updated
        protected var _currTag:IMetadataTag;
        private var _address:Address;

        // My custom address object
        public function get address():Address
        {
            return _address;
        }

        public function set address(value:Address):void
        {
            _address = value;
            dispatchEvent(new Event(ADDRESS_UPDATED));
        }

        override public function setUpMetadataTag(metadataTag:IMetadataTag, bean:Bean):void
        {
            if (bean != null && metadataTag != null)
            {
                // Error checking just like Mr. Rhonde did in the Yahoo Finance Processor
                if (!bean.source[metadataTag.host.name] is ICollectionView)
                {
                    throw new Error("Geocode source must be of type ICollectionViiew");
                }
                else
                {
                    _currBean = bean;
                    _currTag = metadataTag;
                    this.addEventListener(ADDRESS_UPDATED, prepareLocator);
                }

            }
        }

        protected function onFault_handler(info:Object, token:Object = null):void
        {
            trace(info.toString());
        }

        protected function onLocationResults_handler(candidates:Array, token:Object = null):void
        {
            if (candidates.length > 0)
            {
                var myGraphic:Graphic = new Graphic();
                var collection:ArrayCollection = new ArrayCollection();
                myGraphic.geometry = candidates[0].location;
                myGraphic.toolTip = candidates[0].address.toString();
                myGraphic.id = "graphic";
                collection.addItem(myGraphic);
                // This is where the magic happens
                // Send my processed arraycollection to object decorated with metadata tag
                _currBean.source[_currTag.host.name] = collection;
            }
        }

        protected function prepareLocator(event:Event):void
        {
            // ESRI Geocode services just expect a plain object
            // So convert Address Object to regular object
            var addrObject:Object = new Object();
            addrObject.Address = address.Street;
            addrObject.City = address.City;
            addrObject.Country = address.Country;
            addrObject.State = address.State;
            addrObject.Zip = address.Zip;

            // This can vary depending on service
            var myOutFields:Array = ["Loc_name"];

            var locateTask:Locator = new Locator(geocodeURL);

            locateTask.addressToLocations(addrObject, myOutFields, new AsyncResponder(onLocationResults_handler, onFault_handler));

        }
    }
}

