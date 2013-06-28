package
{
	import flash.events.Event;
	import fl.data.DataProvider;
	import flash.display.StageScaleMode;
	import adobe.utils.MMExecute;
	import fl.controls.ComboBox;
	import fl.controls.TextInput;
	import flash.display.Sprite;

	public class CasparSystemTimePanel extends Sprite 
	{
		private const TIMEZONEOFFSET:String = "fl.getDocumentDOM().selection[0].parameters.TimezoneOffset.value";
		private const FORMAT:String = "fl.getDocumentDOM().selection[0].parameters.Format.value";
		
		private var availableFormats:Array = new Array(
			{data:"24hh:mm:ss", label:"24hh:mm:ss"}, 
			{data:"hh:mm:ss", label:"hh:mm:ss"}, 
			{data:"custom", label:"custom"}
		);
		
		public function CasparSystemTimePanel() 
		{
			//this.stage.scaleMode = StageScaleMode.NO_SCALE;
			addEventListener(Event.EXIT_FRAME, onReady);
		}

		private function onReady(e:Event):void
		{
			removeEventListener(Event.EXIT_FRAME, onReady);
			init();
		}
			
		private function init():void 
		{
trace("executing init...");
			// setup params change event handlers
			nsTimezoneOffset.addEventListener(Event.CHANGE, onOffsetChanged);
			cbFormat.addEventListener(Event.CHANGE, onFormatChanged);
			
			// set initial param values for selected component
			var offset:Number = Number(MMExecute(TIMEZONEOFFSET));
trace("OFFSET: " + offset);
			nsTimezoneOffset.value = offset;
			
			var format:String = String(MMExecute(FORMAT));
			cbFormat.dataProvider = new DataProvider(availableFormats);
trace("FORMAT: " + format);

			for (var i:Number = 0; i < cbFormat.dataProvider.length; i++) 
			{
				if(cbFormat.dataProvider.getItemAt(i).data == format) {
					cbFormat.selectedIndex = i;
					break;
				}
			}
		}
		
		/* parameters change event handlers */
		
		private function onOffsetChanged(e:Event):void
		{
			var offset = e.target.value;
			
			MMExecute(TIMEZONEOFFSET + ' = "' + offset + '"');
trace(TIMEZONEOFFSET + ' = "' + offset + '"');

			updateComponentPreview();
		}

		private function onFormatChanged(e:Event):void
		{
			var format:String = e.target.selectedItem.data;
			
			MMExecute(FORMAT + ' = "' + format + '"');
trace(FORMAT + ' = "' + format + '"');

			updateComponentPreview();
		}
		
		private function updateComponentPreview():void 
		{
			var jsfl:String = "";
			jsfl += "var selectedArray = fl.getDocumentDOM().selection;";
			jsfl += "fl.getDocumentDOM().selectNone();";
			jsfl += "fl.getDocumentDOM().selection = selectedArray;";
			MMExecute(jsfl);
		}
	}
}