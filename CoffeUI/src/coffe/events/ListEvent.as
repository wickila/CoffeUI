package coffe.events
{
	import flash.events.Event;
	
	/**
	 * 
	 * 当列表的当前选择目标发生改变时,发出此事件
	 */
	public class ListEvent extends Event
	{
		public static const SELECTED_DATA_CHANGE:String = "selectedDataChange";
		
		public function ListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}