package coffe.events
{
	import flash.events.Event;
	
	/**
	 * 弹出框事件.当最弹出框做确定,取消,关闭等操作时.会发出此事件.
	 * 
	 */
	public class FrameEvent extends Event
	{
		public static const FRAMEEVENT:String = "frameEvent";
		public static const CLOSE:String = "close";
		public static const CANCEL:String = "cancel";
		public static const OK:String = "ok";
		
		public var code:String;
		/**
		 * 创建一个弹出框事件.
		 * <table>
		 * <tr><td>操作类型代号</td><td>操作类型</td></tr>
		 * <tr><td>FrameEvent.CLOSE</td><td>关闭事件</td></tr>
		 * <tr><td>FrameEvent.CANCEL</td><td>取消事件</td></tr>
		 * <tr><td>FrameEvent.OK</td><td>确定事件</td></tr>
		 * </table>
		 * @param type 事件类型.
		 * @param code 事件的操作类型.
		 * 
		 */
		public function FrameEvent(type:String, code:String)
		{
			this.code = code
			super(type, false, false);
		}
	}
}