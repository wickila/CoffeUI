package coffe.controls
{
	
	import flash.events.Event;
	
	import coffe.core.InvalidationType;
	import coffe.interfaces.ISelectable;

	/**
	 * 单选按钮.具有选中与未选中两种状态.两种状态下的背景,标签都可以定义.但是两种状态下的标签样式跟标签滤镜是统一的.
	 * 注意:标签对齐方式在此组件中无效.水平默认靠左对齐,垂直默认居中对齐.
	 * <br>可设置样式属性:
	 * 	<table width="100%">
	 * 	<tr><td>样式名称</td><td>描述</td><td>默认值</td></tr>
	 * 	<tr><td>label</td><td>文本标签值</td><td>label</td></tr>
	 * 	<tr><td>textColor</td><td>标签颜色</td><td>0</td></tr>
	 * 	<tr><td>labelGap</td><td>标签水平偏移距离</td><td>2</td></tr>
	 * 	<tr><td>labelTopGap</td><td>标签垂直偏移距离</td><td>-2</td></tr>
	 * 	<tr><td>selectedBgStyle</td><td>选中状态背景样式</td><td>RadioButtonSelectedUpSkin</td></tr>
	 * 	<tr><td>unSelectedBgStyle</td><td>未选中状态背景样式</td><td>RadioButtonUnSelectedUpSkin</td></tr>
	 * 	<tr><td>labelFormat</td><td>标签字体样式</td><td>{"color":"0x000000","font":"Arial","size":12}</td></tr>
	 * 	<tr><td>labelFilter</td><td>标签发光滤镜</td><td>{"color":"0xffffff","alpha":1,<br>"blurX":2,"blurY":2,"strength":5,<br>"quality":1,"inner":false,"knockout":false}</td></tr>
	 * 	</table>
	 * @see coffe.controls.BaseButton
	 * @see coffe.controls.CheckBox
	 */
	public class RadioButton extends CheckBox implements ISelectable
	{
		/**
		 *	组件的全局默认样式,每个组件都拥有自己单独的 DEFAULT_STYLE,并且在组件初始化的时候,会将DEFAULT_STYLE的样式信息赋值给组件.
		 * 	<br>此默认样式信息是全局样式信息.所以可以在程序初始化的时候,设置组件的全局默认样式信息.
		 * 	<br>单选按钮默认样式属性:
		 * 	<table width="100%">
		 * 	<tr><td>样式名称</td><td>描述</td><td>默认值</td></tr>
		 * 	<tr><td>selectedBgStyle</td><td>选择状态的背景样式</td><td>RadioButtonSelectedUpSkin</td></tr>
		 * 	<tr><td>unSelectedBgStyle</td><td>未选中状态背景样式</td><td>RadioButtonUnSelectedUpSkin</td></tr>
		 * 	</table>
		 * 	@see coffe.controls.CheckBox.DEFAULT_STYLE
		 * 	@see coffe.core.UIComponent.initDefaultStyle()
		 * 	@see coffe.core.UIComponent.setStyle()
		 * 	@see coffe.core.UIComponent.combinStyle()
		 * 	@example
		 * 	ObjectUtils.combineObject(ComboBox.DEFAULT_STYLE,{"listStyle":{"cellRender":"com.dragonlance.view.ComboxCellRender","backgroundStyle":"dl.asset.core.ComboxListBgAsset"},"buttonStyle":{"labelFormat":'{"color":"0xffffff","font":"宋体","size":12}',"labelFilter":""}});
		 */
		public static var DEFAULT_STYLE:Object={
			selectedBgStyle:"RadioButtonSelectedUpSkin",
			unSelectedBgStyle:"RadioButtonUnSelectedUpSkin"
		}
		protected var _group:SelectGroup;
		protected var _value:Object;
		/**
		 *	创建一个单选按钮.单选按钮被创建后.默认被添加进RadioButtonGroup的组里面
		 * 	@see coffe.controls.SelectGroup
		 */
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
		/**
		 *	选中状态的背景样式.
		 * @param value 选中状态的背景样式.默认值:RadioButtonSelectedUpSkin
		 * 
		 */		
		[Inspectable(type="String",name="选中样式",defaultValue="RadioButtonSelectedUpSkin")]
		override public function set selectedBgStyle(value:String):void
		{
			_selectedBgStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	未选中状态的背景样式. 
		 * @param value 未选中状态的背景样式.默认值:RadioButtonUnSelectedUpSkin
		 * 
		 */		
		[Inspectable(type="String",name="未选中样式",defaultValue="RadioButtonUnSelectedUpSkin")]
		override public function set unSelectedBgStyle(value:String):void
		{
			_unSelectedBgStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	按钮标签. 
		 * @param value 按钮标签.默认值:RadioButton
		 * 
		 */		
		[Inspectable(type="String",name="标签",defaultValue="RadioButton")]
		override public function set label(value:String):void
		{
			super.label = value;
		}
		/**
		 * @param value 按钮的选中状态.默认值:false.只能被设置为true,因为会同时设置所在组内的当前选中目标,组内的当前目标发生改变后,会设置其他的单选组件的选中状态为false.
		 * 
		 */
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
			if (_group != null){
				_group.removeRadioButton(this);
				_group.removeEventListener(Event.CHANGE,handleChange);
			}
			_value = null;
			super.dispose();
		}

	}
}