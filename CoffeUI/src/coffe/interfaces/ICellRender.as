package coffe.interfaces
{
	import flash.events.IEventDispatcher;

	/**
	 * 列表用的单元格.拥有对应的数据与选中状态
	 * @see IDisposable
	 * @see flash.events.IEventDispatcher
	 */
	public interface ICellRender extends IDisposable,IEventDispatcher
	{
		/**
		 *	单元格数据 
		 * @param value 单元格数据
		 * 
		 */
		function set data(value:Object):void
		function get data():Object
		/**
		 *	选中状态 
		 * @param value 选中状态
		 * 
		 */
		function set selected(value:Boolean):void
		function get selected():Boolean
	}
}