package coffe.controls
{
	
	import flash.events.Event;
	
	import coffe.core.InvalidationType;
	import coffe.interfaces.ISelectable;

	public class RadioButton extends CheckBox implements ISelectable
	{
		public static var DEFAULT_STYLE:Object={
			selectedBgStyle:"RadioButtonSelectedUpSkin",
			unSelectedBgStyle:"RadioButtonUnSelectedUpSkin"
		}
		protected var _group:SelectGroup;
		protected var _value:Object;
		public function RadioButton()
		{
			super();
			groupName = "RadioButtonGroup";
		}
		
		override protected function initDefaultStyle():void
		{
			_label = "RadioButton";
			setStyle(DEFAULT_STYLE);
		}
		
		[Inspectable(type="String",name="选中样式",defaultValue="RadioButtonSelectedUpSkin")]
		override public function set selectedBgStyle(value:String):void
		{
			_selectedBgStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		
		[Inspectable(type="String",name="未选中样式",defaultValue="RadioButtonUnSelectedUpSkin")]
		override public function set unSelectedBgStyle(value:String):void
		{
			_unSelectedBgStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		
		[Inspectable(type="String",name="标签",defaultValue="RadioButton")]
		override public function set label(value:String):void
		{
			super.label = value;
		}
		
		override public function set selected(value:Boolean):void {
			// can only set to true in RadioButton:
			if (value == false || selected) { return; }
			if (_group != null) { _group.selection = this; }
			else { super.selected = value; }
		}
		
		public function get groupName():String {
			return (_group == null) ? null : _group.name;
		}
		
		[Inspectable(type="String",name="所属组",defaultValue="RadioButtonGroup")]
		public function set groupName(group:String):void {
			if (_group != null) {
				_group.removeRadioButton(this);
				_group.removeEventListener(Event.CHANGE,handleChange);
			}
			_group = (group == null) ? null : SelectGroup.getGroup(group);
			if (_group != null) {
				_group.addRadioButton(this);
				_group.addEventListener(Event.CHANGE,handleChange,false,0,true);
			}
		}
		
		protected function handleChange(event:Event):void {
			super.selected = (_group.selection == this);
			dispatchEvent(new Event(Event.CHANGE, true));
		}

		public function get value():Object
		{
			return _value;
		}

		public function set value(value:Object):void
		{
			_value = value;
		}
		
		override public function dispose():void
		{
			if (_group != null)_group.removeRadioButton(this);
			_value = null;
			super.dispose();
		}

	}
}