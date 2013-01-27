package coffe.interfaces
{
	public interface ISelectable
	{
		function set groupName(value:String):void;
		function get groupName():String;
		function set selected(value:Boolean):void;
		function get selected():Boolean;
		function set value(obj:Object):void;
		function get value():Object;
	}
}