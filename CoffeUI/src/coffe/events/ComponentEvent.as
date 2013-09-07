package coffe.events {

	import flash.events.Event;
	
	/**
	 *	 组件内的基础事件.一般在组件样式发生改变后发出.
	 * 
	 */
	public class ComponentEvent extends Event {
		public static const BUTTON_DOWN:String = "buttonDown";
		public static const LABEL_CHANGE:String = "labelChange";
		public static const HIDE:String = "hide";
		public static const SHOW:String = "show";
		/**
		 *	组件尺寸信息被改变后发出的事件 
		 */
		public static const RESIZE:String = "resize";
		/**
		 *	组件的位置坐标信息改变后发出的事件 
		 */
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