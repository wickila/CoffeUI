package coffe.interfaces
{
	

	/**
	 * 单选组件.实现此接口的组件需要被添加进一个组(SelectGroup)内.
	 * 同一个组内只有一个组件能处于选择状态.
	 * @see coffe.controls.SelectGroup
	 */
	public interface ISelectable
	{
		/**
		 * 所在组名称
		 * @param value 所在组名称.实现此方法时,需要在设置组名称后,将此组件添加进对应的组.
		 */
		function set groupName(value:String):void;
		function get groupName():String;
		/**
		 * 组件的选中状态
		 * @param value 组件的选中状态.实现此方法时,需要设置所在组的当前选中目标
		 * @see coffe.controls.RadioButton
		 * @see coffe.controls.RadioButton.selected
		 */
		function set selected(value:Boolean):void;
		function get selected():Boolean;
		/**
		 *	此组件的数据对象 
		 * @param obj 此组件的数据对象
		 * @see coffe.controls.SelectGroup.selectedData
		 */
		function set value(obj:Object):void;
		function get value():Object;
	}
}