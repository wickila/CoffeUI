package coffe.controls
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import coffe.core.AlignType;
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;
	import coffe.data.DataProvider;
	import coffe.events.ListEvent;
	/**
	 * 下拉列表的当前选中数据发生改变时发出此事件
	 *
	 * @eventType flash.events.Event.CHANGE
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 *  @playerversion AIR 1.0
	 *  @productversion Flash CS3
	 */
	[Event(name="change", type="flash.events.Event")]
	/**
	 *	下拉列表组件.当列表的当前选中数据发生改变时,发出Event.Change事件
	 * 	<br>可设置样式属性:
	 * 	<table width="100%">
	 * 	<tr><td>样式名称</td><td>描述</td><td>默认值</td></tr>
	 * 	<tr><td>buttonBackgroundStyle</td><td>按钮背景样式</td><td>ComboBoxSkin</td></tr>
	 * 	<tr><td>listStyle</td><td>列表样式</td><td>List.DEFAULT_STYLE</td></tr>
	 * 	<tr><td>buttonStyle</td><td>按钮样式</td><td>{}</td></tr>
	 * 	<tr><td>labelFilter</td><td>按钮标签发光滤镜</td><td>{"color":"0xffffff","alpha":1,<br>"blurX":2,"blurY":2,"strength":5,"quality":1,<br>"inner":false,"knockout":false}</td></tr>
	 * 	<tr><td>labelFormat</td><td>按钮标签字体样式</td><td>{"color":"0x000000","font":"Arial","size":12}</td></tr>
	 * 	</table>
	 * 	@see coffe.data.DataProvider
	 * 	@see coffe.controls.List
	 */
	public class ComboBox extends UIComponent
	{
		/**
		 *	组件的全局默认样式.每个组件都拥有自己单独的 DEFAULT_STYLE,并且在组件初始化的时候,会将DEFAULT_STYLE的样式信息赋值给组件.
		 * 	<br>此默认样式信息是全局样式信息.所以可以在程序初始化的时候,设置组件的全局默认样式信息.
		 * 	<br>默认下拉列表样式:
		 * 	<table width="100%">
		 * 	<tr><td>样式名称</td><td>描述</td><td>默认值</td></tr>
		 * 	<tr><td>buttonBackgroundStyle</td><td>按钮背景样式</td><td>ComboBoxSkin</td></tr>
		 * 	<tr><td>listStyle</td><td>列表样式</td><td>List.DEFAULT_STYLE</td></tr>
		 * 	<tr><td>buttonStyle</td><td>按钮样式</td><td>{}</td></tr>
		 * 	<tr><td>labelFilter</td><td>按钮标签发光滤镜</td><td>{"color":"0xffffff","alpha":1,<br>"blurX":2,"blurY":2,"strength":5,"quality":1,<br>"inner":false,"knockout":false}</td></tr>
		 * 	<tr><td>labelFormat</td><td>按钮标签字体样式</td><td>{"color":"0x000000","font":"Arial","size":12}</td></tr>
		 * 	</table>
		 * 	@see coffe.core.UIComponent.initDefaultStyle()
		 * 	@see coffe.core.UIComponent.setStyle()
		 * 	@see coffe.core.UIComponent.combinStyle()
		 * 	@see coffe.controls.List.DEFAULT_STYLE
		 * 	@example
		 * 	ObjectUtils.combineObject(ComboBox.DEFAULT_STYLE,{"listStyle":{"cellRender":"com.dragonlance.view.ComboxCellRender","backgroundStyle":"dl.asset.core.ComboxListBgAsset"},"buttonStyle":{"labelFormat":'{"color":"0xffffff","font":"宋体","size":12}',"labelFilter":""}});
		 */
		public static const DEFAULT_STYLE:Object = {
			listStyle:List.DEFAULT_STYLE,
			buttonBackgroundStyle:"ComboBoxSkin"
		}
		private var _listStyle:Object={};
		private var _buttonStyle:Object = {};
		private var _listHeight:int=100;
		private var _button:Button;
		private var _list:List;
		private var _data:DataProvider;
		private var _selectedIndex:int=0;
		private var _labelField:String = "label";
		private var _selectedData:Object;
		private var _listContainer:Sprite;
		/**
		 *	创建一个下拉列表组件 
		 * 
		 */
		public function ComboBox()
		{
			super();
		}
		
		override protected function initDefaultStyle():void
		{
			setStyle(DEFAULT_STYLE);
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.STYLE))
			{
				if(_button == null)
				{
					_button = new Button();
					_button.displacement = false;
					_button.labelAlign = AlignType.LEFT;
					_button.addEventListener(MouseEvent.CLICK,onClick,false,int.MAX_VALUE);
				}
				_button.setStyle(_buttonStyle);
				_button.drawNow();
				addChild(_button);
				if(_list)
				{
					_list.setStyle(_listStyle);
					_list.drawNow();
				}
			}
			if(isInvalid(InvalidationType.LABEL))
			{
				if(_selectedData&&_selectedData.hasOwnProperty(_labelField))
				{
					_button.label = _selectedData[_labelField];
				}else
				{
					_button.label = String(_selectedData);
				}
				_button.drawNow();
			}
			if(isInvalid(InvalidationType.STYLE,InvalidationType.SIZE))
			{
				drawLayout();
			}
		}
		
		override public function drawLayout():void
		{
			_button.width = width;
			_button.drawNow();
			super.drawLayout();
		}
		
		private function onClick(event:MouseEvent):void
		{
			if(_listContainer && _listContainer.parent)
			{
				_listContainer.parent.removeChild(_listContainer);
			}else
			{
				if(_list == null)
				{
					createList();
				}
				_listContainer.graphics.clear();
				_listContainer.graphics.beginFill(0,0);
				_listContainer.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
				_listContainer.graphics.endFill();
				var p:Point = localToGlobal(new Point(0,height));
				_list.move(p.x,p.y);
				_list.data = _data;
				_list.drawNow();
				stage.addChild(_listContainer);
				_listContainer.addEventListener(MouseEvent.CLICK,onListContainerClick);
			}
		}
		
		protected function createList():void
		{
			_list = new List();
			_list.setStyle(_listStyle);
			_list.addEventListener(ListEvent.SELECTED_DATA_CHANGE,onSelctedDataChange);
			_list.width = width;
			_list.height = _listHeight;
			_listContainer = new Sprite();
			_listContainer.addChild(_list);
		}
		
		override protected function removeEvents():void
		{			
			if(_list)_list.removeEventListener(ListEvent.SELECTED_DATA_CHANGE,onSelctedDataChange);
			if(_listContainer)_listContainer.removeEventListener(MouseEvent.CLICK,onListContainerClick);
		}
		
		protected function onSelctedDataChange(event:ListEvent):void
		{
			selectedData = _list.selectedData;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onListContainerClick(event:MouseEvent):void
		{
			_listContainer.removeEventListener(MouseEvent.CLICK,onListContainerClick);
			_listContainer.parent.removeChild(_listContainer);
		}
		/**
		 * 下拉列表的数据对象.
		 * 默认值:null
		 * @param value 一个DataProvider数据对象
		 * @see coffe.data.DataProvider
		 */		
		[Collection(collectionClass="coffe.data.DataProvider", collectionItem="coffe.data.SimpleCollectionItem", identifier="item")]
		public function set data(value:DataProvider):void
		{
			if(_data == value)return;
			_data = value;
			if(_list)_list.data = value;
			selectedIndex = 0;
			invalidate(InvalidationType.DATA);
		}

		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		/**
		 *	列表当前选中目标下标.
		 * 默认值:0
		 * @param value 列表当前选中目标下边
		 * 
		 */
		public function set selectedIndex(value:int):void
		{
			_selectedIndex = value;
			selectedData = _data.getItemAt(_selectedIndex);
		}

		public function set listStyle(value:Object):void
		{
			combinStyle(_listStyle,value);
			invalidate(InvalidationType.STYLE);
		}

		public function get selectedData():Object
		{
			return _selectedData;
		}

		/**
		 *	列表当前选中数据 
		 * @param value 列表当前选中数据
		 * 
		 */
		public function set selectedData(value:Object):void
		{
			if(_selectedData == value)return;
			_selectedData = value;
			invalidate(InvalidationType.LABEL);
		}
		/**
		 *	按钮背景样式.
		 * 默认值:ComboBoxSkin
		 * @param value 按钮背景样式.
		 * @see coffe.controls.Button.backGroundStyle
		 */		
		[Inspectable(type="String",name="按钮背景样式",defaultValue="ComboBoxSkin")]
		public function set buttonBackgroundStyle(value:String):void
		{
			_buttonStyle.backGroundStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	标签发光滤镜.为一个json格式的字符串,里面可以包含GlowFilter的各种属性值
		 * 	默认值: {"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":5,"quality":1,"inner":false,"knockout":false}
		 * 	@param value 一段json格式的标签滤镜字符串
		 * 	@see coffe.controls.Button.labelFilter
		 * 	@see flash.filters.GlowFilter
		 */	
		[Inspectable(type="String",name="按钮标签滤镜",defaultValue='{"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":5,"quality":1,"inner":false,"knockout":false}')]
		public function set labelFilter(value:String):void
		{
			_buttonStyle.labelFilter = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	标签样式.为一个json格式的字符串,里面可以包含TextFormat的各种属性值
		 * 	默认值: {"color":"0x000000","font":"Arial","size":12}
		 * 	@param value 一段json格式的文本样式字符串
		 * 	@see coffe.controls.Button.labelFormat
		 * 	@see flash.text.TextFormat
		 */
		[Inspectable(type="String",name="按钮标签样式",defaultValue='{"color":"0x000000","font":"Arial","size":12}')]
		public function set labelFormat(value:String):void
		{
			_buttonStyle.labelFormat = value;
			invalidate(InvalidationType.STYLE);
		} 
		/**
		 *	按钮样式信息.一个包含样式的object 
		 * @param value 按钮的样式信息.
		 * @see coffe.controls.Button
		 * @see coffe.controls.Button.DEFAULT_STYLE
		 */		
		public function set buttonStyle(value:Object):void
		{
			combinStyle(_buttonStyle,value);
			invalidate(InvalidationType.STYLE);
		}

		public function get listHeight():int
		{
			return _listHeight;
		}
		/**
		 *	下拉列表List高度 
		 * 默认值100
		 * @param value 下拉列表List的高度
		 * 
		 */
		[Inspectable(type="Number",name="下拉列表高度",defaultValue='100')]
		public function set listHeight(value:int):void
		{
			_listHeight = value;
			if(_list!=null)
			{
				_list.height = _listHeight;
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_data)_data.removeAll();_data = null;
			if(_list)_list.dispose();_list = null;
			if(_listContainer&&contains(_listContainer))removeChild(_listContainer);_list = null;
			if(_button)_button.dispose();_button = null;
		}
	}
}