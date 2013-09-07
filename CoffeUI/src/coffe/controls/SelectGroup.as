// Copyright 2007. Adobe Systems Incorporated. All Rights Reserved.
package coffe.controls {
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import coffe.interfaces.ISelectable;
	
	
    //--------------------------------------
    //  Events
    //--------------------------------------	
	/**
	 * 当组内的选中目标发生改变时发出此事件
     *
     * @eventType flash.events.Event.CHANGE
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 *  @playerversion AIR 1.0	 *  @productversion Flash CS3
	 */
	[Event(name="change", type="flash.events.Event")]
	

	/**
	 * 单选组件的组.被添加进组内的单选组件同时只会有一个组件处于选择状态
	 * 
     * @see coffe.interfaces.ISelectable
     * @see RadioButton
     *
     * @includeExample examples/RadioButtonGroupExample.as -noswf
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0
	 *  
	 *  @playerversion AIR 1.0
	 *  @productversion Flash CS3
	 */
	public class SelectGroup extends EventDispatcher {
		
		private static var groups:Object;
		private static var groupCount:uint = 0;

		/**
		 * 通过组名称获取一个组.如果已经存在一个此名字的组,则直接返回该组.如果不存在,则返回一个新建的组.
		 * 一般不通过此类构造方法创建此类实例,而是通过此方法创建.
		 *
		 */
		public static function getGroup(name:String):SelectGroup {
			if (groups == null) { groups = {}; }
			var group:SelectGroup = groups[name] as SelectGroup;
			if (group == null) {
				group = new SelectGroup(name);
				// every so often, we should clean up old groups:
				if ((++groupCount)%20 == 0) {
					cleanUpGroups();
				}
			}
			return group;
		}

		private static function registerGroup(group:SelectGroup):void {
			if(groups == null){groups = {}}
			groups[group.name] = group;
		}

		private static function cleanUpGroups():void {
			for (var n:String in groups) {
				var group:SelectGroup = groups[n] as SelectGroup;
				if (group.radioButtons.length == 0) {
					delete(groups[n]);
				}
			}
		}
		
		protected var _name:String;

		protected var radioButtons:Array;

		protected var _selection:ISelectable;

		/**
		 * 创建一个名字为name的组.
		 * 一般不直接调用此构造函数创建组的实例.而是调用getGroup来创建组实例
		 * @see SelectGroup.getGroup()
		 */
		public function SelectGroup(name:String) {
			_name = name;
			radioButtons = [];
			registerGroup(this);
		}

		/**
		 * @return 组名称
		 */
		public function get name():String {
			return _name;
		}

		/**
		 * 添加一个单选组件进组.如果此单选组件已经在另外一个组内了.则先从另外一个组内移除,再添加进此组
		 * @param radioButton
		 * 需要添加的单选组件
		 */
		public function addRadioButton(radioButton:ISelectable):void {
			if (radioButton.groupName != name) {
				radioButton.groupName = name;
				return;
			}
			radioButtons.push(radioButton);
			if (radioButton.selected) { selection = radioButton; }
		}

		/**
		 * 把单选组件从组内移除.如果此组的当前选中对象为此组件,则此组的当前选中对象会被设置为null
		 * @param radioButton
		 * 需要移除的组件
		 */
		public function removeRadioButton(radioButton:ISelectable):void {
			var i:int = getRadioButtonIndex(radioButton);
			if (i != -1) {
				radioButtons.splice(i, 1);
			}
			if (_selection == radioButton) { _selection = null; }
		}
		
		/**
		 * 获取当前的所选中的组件
		 */
		public function get selection():ISelectable {
			return _selection;
		}

		/**
		 * 设置此组的当前选中对象.如果设置成功,发出Event.Change事件
		 * @param value
		 * 将会被设置成选中状态的组件
		 */
		public function set selection(value:ISelectable):void {
			if (_selection == value || value == null || getRadioButtonIndex(value) == -1) { return; }
			_selection = value;
			dispatchEvent(new Event(Event.CHANGE, true));
		}
		
		/**
         * 获取当前所选中的单选组件的数据
		 */
		public function get selectedData():Object {
			var s:ISelectable = _selection;
			return (s==null) ? null : s.value;
		}

		/**
         * 设置此组的当前选中数据
		 */
		public function set selectedData(value:Object):void {
			for (var i:int = 0; i < radioButtons.length; i++) {
				var rb:ISelectable = radioButtons[i] as ISelectable;
				if (rb.value == value) {
					selection = rb;
					return;
				}
			}
		}

		/**
		 * 获取单选组件在组内的下标
		 * @param radioButton 要获取下标的单选组件
		 * @return 单选组件在组内的下标
		 * 
		 */
		public function getRadioButtonIndex(selectalbe:ISelectable):int {
			for (var i:int = 0; i < radioButtons.length; i++) {
				var s:ISelectable = radioButtons[i] as ISelectable;
				if(s == selectalbe) {
					return i;
				}
			}
			return -1;
		}

		/**
		 *	通过下标获取组内的单选组件 
		 * @param index 需要查询的下标
		 * @return 下标对应的单选组件
		 * 
		 */
		public function getRadioButtonAt(index:int):ISelectable {
			return ISelectable(radioButtons[index]);
		}

		/**
		 *	获取组内单选组件的数量 
		 * @return 组内单选组件的数量
		 * 
		 */
		public function get numRadioButtons():int {
			return radioButtons.length;
		}
	}
}
