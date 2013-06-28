package  
{
	import fl.core.UIComponent;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.system.Capabilities;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import se.svt.caspar.template.components.ICasparComponent;
	import fl.motion.Color;
	
	public class CasparSystemTime extends UIComponent implements ICasparComponent
	{
		private const DAY_MILLISECONDS:Number = 24 * 60 * 60 * 1000;

		private var _displayField:TimerDisplay;
		private var _textFormat:TextFormat;
		
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

			_textFormat = new TextFormat();
			_textFormat.font = "Arial";
			_textFormat.color = 0x000000;
			_textFormat.size = 12;
			_textFormat.align = "left";
			_textFormat.bold = false;
			_textFormat.italic = false;
			
			_displayField.DisplayTextFormat = _textFormat;

trace(this.Italic);


			updateTimeDisplay();

			setupRegulator(500); // updates regulator 2 times per second
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
		
		protected function setupRegulator(interval:int):void
		{
			this.dispose();
			
			_regulator = new Timer( interval );
			_regulator.addEventListener(TimerEvent.TIMER, onTimerEvent);
			_regulator.start();
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
			
			// check for day change because of offset
			if (milliseconds > DAY_MILLISECONDS)
			{
				milliseconds = milliseconds - DAY_MILLISECONDS;
			}
			else if (milliseconds < 0)
			{
				milliseconds = milliseconds + DAY_MILLISECONDS;
			}

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

					case "24hh:mm":
						_format = f;
						_formatProvider = new TimerDisplayFormat_24hhmm();
						break;

					case "hh:mm":
						_format = f;
						_formatProvider = new TimerDisplayFormat_hhmm();
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
		
		// text format options
		[Inspectable(name = "Font", type="Font Name", defaultValue="Arial")]
		public function set Font(font:String):void
		{
			_textFormat.font = font;
			_displayField.DisplayTextFormat = _textFormat;
		}
		public function get Font():String
		{
			return _textFormat.font;
		}

		[Inspectable(name = "TextColor", type="Color", defaultValue="0x000000")]
		public function set TextColor(c:int):void
		{
			_textFormat.color = c;
			_displayField.DisplayTextFormat = _textFormat;
		}
		public function get TextColor():int
		{
			return int(_textFormat.color);
		}
		
		[Inspectable(name = "Size", type="Number", defaultValue=12)]
		public function set Size(s:Number):void
		{
			_textFormat.size = s;
			_displayField.DisplayTextFormat = _textFormat;
		}
		public function get Size():Number
		{
			return Number(_textFormat.size);
		}

		[Inspectable(name = "Align", type="String", enumeration="left, center, right", defaultValue="left")]
		public function set Align(a:String):void
		{
			_textFormat.align = a;
			_displayField.DisplayTextFormat = _textFormat;
		}
		public function get Align():String
		{
			return _textFormat.align;
		}

		[Inspectable(name = "Bold", type="Boolean", defaultValue=false)]
		public function set Bold(b:Boolean):void
		{
			_textFormat.bold = b;
			_displayField.DisplayTextFormat = _textFormat;
trace("BOLD: " + b);
		}
		public function get Bold():Boolean
		{
			return _textFormat.bold;
		}
		
		[Inspectable(name = "Italic", type="Boolean", defaultValue=false)]
		public function set Italic(i:Boolean):void
		{
			_textFormat.italic = i;
			_displayField.DisplayTextFormat = _textFormat;
			
trace("ITALIC: " + i);
		}
		public function get Italic():Boolean
		{
			return _textFormat.italic;
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
