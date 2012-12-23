package coffe.events
{
	import flash.events.Event;
	
	public class FrameEvent extends Event
	{
		public static const CLOSE:String = "close";
		public static const CANCEL:String = "cancel";
		public static const OK:String = "ok";
		
		public function FrameEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}