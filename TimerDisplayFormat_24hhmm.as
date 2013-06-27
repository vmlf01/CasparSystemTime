/*
* 
* Formats a milliseconds time value into an 24-hour 'hh:mm' string representation
*
*/
package  
{
	public class TimerDisplayFormat_24hhmm implements ITimerDisplayFormat
	{
		public function formatTime(millisec:Number):String
		{
			var h:Number=Math.floor(millisec/3600000);
			var m:Number=Math.floor((millisec%3600000)/60000);

			return	(h<10 ? "0" + h.toString() : h.toString()) + ":" +
					(m<10 ? "0" + m.toString() : m.toString());
		}
	}
}