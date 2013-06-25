package  
{
	import fl.core.UIComponent;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.system.Capabilities;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import se.svt.caspar.template.components.ICasparComponent;
	
	public class CasparSystemTime extends UIComponent implements ICasparComponent
	{
		private var _displayField:TimerDisplay;
		
		private var _offset:Number;
		private var _format:String;
		private var _formatProvider:ITimerDisplayFormat
		
		private var _regulator:Timer	// system timekeeper
		
		public function CasparSystemTime() 
		{
trace("CasparSystemTime");			
			_offset = 0;
			_format = "24hh:mm:ss";
			_formatProvider = new TimerDisplayFormat_24hhmmss();
			
			_regulator = new Timer( 500 );	// updates regulator 2 times per second
			_regulator.addEventListener(TimerEvent.TIMER, onTimerEvent);
			_regulator.start();
		}

		override protected function configUI():void 
		{
trace("configUI");			
			super.configUI();
			
			//Create a definition for the display text field
			var displayDef:Object = this.loaderInfo.applicationDomain.getDefinition("TimerDisplay");
			
			 //Create the display text field object, cast it as TextField and add it in our object
            _displayField = addChild(new displayDef) as TimerDisplay;
		}		
		
		override protected function draw():void 
		{
trace("draw: " + width + " " + height);			
			//it is always important to set the display field object with the same width of the component
            //It doesnt resize automatically
			/*
			_displayField.x = 0;
			_displayField.y = 0;
			_displayField.width = width;
			_displayField.height = height;
			
			_displayField.SetBounds(0, 0, width, height);
			*/
			// always call super.draw() at the end 
			super.draw();			
		}
		
		protected function onTimerEvent(e:TimerEvent) : void
		{
			updateTimeDisplay();
		}
		
		private function updateTimeDisplay()
		{
			var systemDate = new Date();
			var hours = systemDate.getHours();
			var minutes = systemDate.getMinutes();
			var seconds = systemDate.getSeconds();
			var milliseconds = hours * 60 * 60 * 1000 + minutes * 60 * 1000 + seconds * 1000;
			
			// add offset minutes value
			milliseconds = milliseconds + (_offset * 60 * 1000);

			// update time display
			_displayField.UpdateTimerDisplay(_formatProvider.formatTime(milliseconds));
		}
		
		/******    COMPONENT CUSTOM PROPERTIES    ******/

		[Inspectable(name="TimezoneOffset", defaultValue="0", type="Number", description="Time offset in minutes from system time")]
		public function set TimezoneOffset(offset:Number):void 
		{
			_offset = offset;
			updateTimeDisplay();
		}
		
		public function get TimezoneOffset():Number
		{
			return _offset;
		}
		
		[Inspectable(name="Format", defaultValue="24hh:mm:ss", type="String")]
		public function set Format(f:String):void 
		{
			if (f != _format)
			{
				switch (f)
				{
					case "24hh:mm:ss":
						_format = f;
						_formatProvider = new TimerDisplayFormat_24hhmmss();
						break;

					case "hh:mm:ss":
						_format = f;
						_formatProvider = new TimerDisplayFormat_hhmmss();
						break;
				}
			}
		}
		
		public function get Format():String
		{
			return _format;
		}
		
		public function set FormatProvider(fp:ITimerDisplayFormat):void 
		{
			if (fp != null)
			{
				_formatProvider = fp;
				updateTimeDisplay();
			}
		}
		
		public function get FormatProvider():ITimerDisplayFormat
		{
			return _formatProvider;
		}
		
		/* INTERFACE se.svt.caspar.template.components.ICasparComponent */
		
		[Inspectable(name='description', defaultValue='<component name="CasparSystemTime"></component>')]
		public var description;
		
		public function SetData(xmlData:XML):void 
		{ 
			// no data necessary for this component
		}
		
		public function dispose():void
		{
			try
			{
				if (_regulator != null)
				{
					_regulator.stop();
					_regulator.removeEventListener(TimerEvent.TIMER, onTimerEvent);
				}
				_regulator = null;
			}
			catch (e:Error)
			{
				throw new Error("CasparSystemTime error in dispose: " + e.message);
			}
		}
	}
}
