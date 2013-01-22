package coffe.events
{
	import flash.events.Event;
	
	public class FrameEvent extends Event
	{
		public static const FRAMEEVENT:String = "frameEvent";
		public static const CLOSE:String = "close";
		public static const CANCEL:String = "cancel";
		public static const OK:String = "ok";
		
		public var code:String;
		public function FrameEvent(type:String, code:String)
		{
			this.code = code
			super(type, false, false);
		}
	}
}