package coffe.events {

	import flash.events.Event;
	
	public class ComponentEvent extends Event {
		public static const BUTTON_DOWN:String = "buttonDown";
		public static const LABEL_CHANGE:String = "labelChange";
		public static const HIDE:String = "hide";
		public static const SHOW:String = "show";
		public static const RESIZE:String = "resize";
		public static const MOVE:String = "move";
		public static const ENTER:String = "enter";
		public static const CREATION_COMPLETE:String="creationComplete";
		public function ComponentEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		override public function toString():String {
			return formatToString("ComponentEvent", "type", "bubbles", "cancelable");
		}
		
		override public function clone():Event {
			return new ComponentEvent(type, bubbles, cancelable);
		}
	}
}