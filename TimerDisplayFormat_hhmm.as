/*
* 
* Formats a milliseconds time value into an 'hh:mm' string representation
*
*/
package  
{
	public class TimerDisplayFormat_hhmm implements ITimerDisplayFormat
	{
		public function formatTime(millisec:Number):String
		{
			var h:Number=Math.floor(millisec/3600000);
			var m:Number=Math.floor((millisec%3600000)/60000);
			
			if (h > 12)
			{
				h = h - 12;
			}

			return	h.toString() + ":" +
					(m<10 ? "0" + m.toString() : m.toString());
		}
	}
}