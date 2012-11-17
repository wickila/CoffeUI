package coffe.controls
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class RadioButton extends CheckBox
	{
		public var RadioButtonAvatar:DisplayObject;
		
		protected var _group:RadioButtonGroup;
		protected var _value:Object;
		public function RadioButton()
		{
			super();
			groupName = "RadioButtonGroup";
		}
		
		override protected function initDefaultStyle():void
		{
			_selectedBgStyle = "RadioButtonSelectedUpSkin";
			_unSelectedBgStyle = "RadioButtonUnSelectedUpSkin";
			_label = "RadioButton";
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
			_group = (group == null) ? null : RadioButtonGroup.getGroup(group);
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

	}
}