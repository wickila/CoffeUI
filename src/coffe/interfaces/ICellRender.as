package coffe.interfaces
{
	import flash.events.IEventDispatcher;

	public interface ICellRender extends IDisposable,IEventDispatcher
	{
		function set data(value:Object):void
		function get data():Object
		function set selected(value:Boolean):void
		function get selected():Boolean
	}
}