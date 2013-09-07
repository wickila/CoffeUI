package coffe.controls
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;
	import coffe.data.DataChangeEvent;
	import coffe.data.DataProvider;
	import coffe.data.SimpleCollectionItem;
	import coffe.events.ListEvent;
	import coffe.events.ScrollEvent;
	import coffe.interfaces.ICellRender;
	
	/**
	 * 列表的当前选中数据发生改变时发出此事件
	 *
	 * @eventType flash.events.Event.CHANGE
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 *  @playerversion AIR 1.0
	 *  @productversion Flash CS3
	 */
	[Event(name="selectedDataChange", type="coffe.events.ListEvent")]
	
	/**
	 *	列表.一个可滚动的单选列表框.列表的显示需要一个DataProvider数据.
	 * 	此组件支持自定义单元格渲染器样式.只需创建一个实现ICellRender的渲染器类,并且指定为此组件的渲染器就可以了.
	 * 	<br>可设置样式
	 * 	<table width="100%">
	 *	<tr><td>样式名称</td><td>描述</td><td>默认值</td></tr>
	 * 	<tr><td>cellRender</td><td>渲染器样式</td><td>coffe.controls.CellRender</td></tr>
	 * 	<tr><td>labelField</td><td>单元格呈现的数据属性名称</td><td>"label"</td></tr>
	 * 	</table>
	 * 	@see coffe.data.DataProvider
	 * 	@see coffe.interfaces.ICellRender
	 */	
	public class List extends ScrollPane
	{
		/**
		 *	组件的全局默认样式.每个组件都拥有自己单独的 DEFAULT_STYLE,并且在组件初始化的时候,会将DEFAULT_STYLE的样式信息赋值给组件.
		 * 	<br>此默认样式信息是全局样式信息.所以可以在程序初始化的时候,设置组件的全局默认样式信息.
		 * 	<br>默认列表样式:
		 * 	<table width="100%">
		 * 	<tr><td>样式名称</td><td>描述</td><td>默认值</td></tr>
		 * 	<tr><td>cellRender</td><td>渲染器样式</td><td>coffe.controls.CellRender</td></tr>
	 	 * 	<tr><td>labelField</td><td>单元格呈现的数据属性名称</td><td>"label"</td></tr>
		 * 	</table>
		 * 	@see coffe.controls.ScrollPane.DEFAULT_STYLE
		 * 	@see coffe.core.UIComponent.initDefaultStyle()
		 * 	@see coffe.core.UIComponent.setStyle()
		 * 	@see coffe.core.UIComponent.combinStyle()
		 * 	@example
		 * 	ObjectUtils.combineObject(ComboBox.DEFAULT_STYLE,{"listStyle":{"cellRender":"com.dragonlance.view.ComboxCellRender","backgroundStyle":"dl.asset.core.ComboxListBgAsset"},"buttonStyle":{"labelFormat":'{"color":"0xffffff","font":"宋体","size":12}',"labelFilter":""}});
		 */
		public static var DEFAULT_STYLE:Object = {
			cellRender:"coffe.controls.CellRender",
			labelField:"label"
		};
		
		private var _cellRender:String;
		private var _cells:Vector.<ICellRender>;
		private var _data:DataProvider;
		private var _gap:Number=2;
		private var _cellHeight:Number;
		private var _selectedData:Object;
		private var _labelField:String;
		private var _simpleCollectionImport:SimpleCollectionItem;
		private var _cellRenderImport:CellRender;
		private var _cellAutoSize:Boolean=true;
		
		public function List()
		{
			_cells = new Vector.<ICellRender>();
			_data = new DataProvider();
			super();
		}
		
		override protected function initDefaultStyle():void
		{
			setStyle(DEFAULT_STYLE);
			super.initDefaultStyle();
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			if(_data)_data.removeEventListener(DataChangeEvent.DATA_CHANGE,onDataChange);
			for each(var cell:ICellRender in _cells)
			{
				cell.removeEventListener(MouseEvent.CLICK,onCellClick);
			}
		}
		
		override protected function draw():void
		{
			super.drawComponents();
			if(isInvalid(InvalidationType.STYLE,InvalidationType.SIZE))
			{
				drawLayout();
				updateScrollRect();
			}
			if(isInvalid(InvalidationType.DATA,InvalidationType.CELL_RENDER))
			{
				if(isInvalid(InvalidationType.CELL_RENDER))
				{
					while(_cells.length>0){var cell:ICellRender=_cells.pop();cell.removeEventListener(MouseEvent.CLICK,onCellClick);cell.dispose();}
				}
				createCells();
				updateScrollBar();
				updateScrollRect();
			}
			if(isInvalid(InvalidationType.DATA,InvalidationType.CELL_RENDER,InvalidationType.SIZE,InvalidationType.STYLE))
			{
				renderCells();
			}
		}
		
		override protected function updateScrollBar():void
		{
			contentClip.graphics.clear();
			contentClip.graphics.beginFill(0,0);
			contentClip.graphics.drawRect(0,0,width,_data.length*(_cellHeight+_gap));
			contentClip.graphics.endFill();
			super.updateScrollBar();
		}
		
		override protected function onScrollEvent(event:ScrollEvent):void
		{
			super.onScrollEvent(event);
			renderCells();
		}
		/**
		 * 滚动时，渲染出需要显示出来的数据，其他不需要显示出来的数据就不会被渲染出来
		 * 
		 */		
		private function renderCells():void
		{
			while(contentClip.numChildren>0)
			{
				contentClip.removeChildAt(0);
			}
			if(_cells.length>0&&_data.length>0)
			{
				var index:int = Math.floor(contentClipWrap.scrollRect.y/(_cellHeight+_gap));
				var i:int=0;
				var cell:DisplayObject;
				while(index<_data.length)
				{
					cell = _cells[i] as DisplayObject;
					_cells[i].data = _data.getItemAt(index);
					cell.y = index*(_cellHeight+_gap);
					_cells[i].selected = _selectedData == _cells[i].data;
					contentClip.addChild(cell);
					if(_cellAutoSize)cell.width = width-vScrollWidth;
					if(cell is UIComponent)UIComponent(cell).drawNow();
					i++;index++;
					if((cell.y+cell.height)>contentClipWrap.scrollRect.bottom)break;
				}
			}
		}
		
		/**
		 *	根据单元格高与列表的高，生成要用到的所有单元格，单元格数量最多为列表可以显示的单元格数+2 
		 * 
		 */		
		private function createCells():void
		{
			var cellNum:Number = Math.min(_data.length,Math.ceil(height/(_cellHeight+_gap))+2)-_cells.length;
			for(var i:int=0;i<cellNum;i++)
			{
				var cell:DisplayObject = getDisplayObjectInstance(_cellRender);
				if(cell.hasOwnProperty("labelField"))
				{
					cell["labelField"] = labelField;
				}
				if(cell is UIComponent)UIComponent(cell).drawNow();
				cell.addEventListener(MouseEvent.CLICK,onCellClick);
				_cells.push(cell as ICellRender);
			}
		}
		
		private function onCellClick(event:MouseEvent):void
		{
			for each(var cell:ICellRender in _cells)
			{
				cell.selected = false;
			}
			cell = event.currentTarget as ICellRender;
			cell.selected = true;
			if(_selectedData != cell.data)
			{
				_selectedData = cell.data;
				dispatchEvent(new ListEvent(ListEvent.SELECTED_DATA_CHANGE));
			}
		}
		/**
		 *	需要组件呈现的DataProvider数据集合. 
		 * @param value 需要组件呈现的DataProvider数据集合. 
		 * @see coffe.data.DataProvider
		 */		
		[Collection(collectionClass="coffe.data.DataProvider", collectionItem="coffe.data.SimpleCollectionItem", identifier="item")]
		public function set data(value:DataProvider):void
		{
			if(_data == value)return;
			if(_data)
			{
				_data.removeAll();
				_data.removeEventListener(DataChangeEvent.DATA_CHANGE,onDataChange);
			}
			_data = value;
			if(_data == null)_data = new DataProvider();
			_data.addEventListener(DataChangeEvent.DATA_CHANGE,onDataChange);
			invalidate(InvalidationType.DATA);
		}
		
		private function onDataChange(event:DataChangeEvent):void
		{
			invalidate(InvalidationType.DATA);
		}
		
		public function get selectedData():Object
		{
			return _selectedData;
		}
		
		/**
		 *	当前组件选中的数据. 
		 * @param value 当前组件选中的数据.如果当前选中的数据发生改变.则发出ListEvent.SELECTED_DATA_CHANGE事件
		 * @see coffe.events.ListEvent.SELECTED_DATA_CHANGE
		 */
		public function set selectedData(value:Object):void
		{
			if(_selectedData == value)return;
			_selectedData = value;
			for each(var cell:ICellRender in _cells)
			{
				cell.selected = cell.data == _selectedData;
			}
			dispatchEvent(new ListEvent(ListEvent.SELECTED_DATA_CHANGE));
		}

		/**
		 *	单元格呈现的渲染器.为一个实现ICellRender的渲染器类名. 
		 * @param value 单元格呈现的渲染器.默认值:coffe.controls.CellRender
		 * @see coffe.interfaces.ICellRender
		 * @see coffe.controls.CellRender
		 */
		public function set cellRender(value:String):void
		{
			if(_cellRender == value)return;
			_cellRender = value;
			var cell:ICellRender = getDisplayObjectInstance(_cellRender) as ICellRender;
			if(cell is UIComponent)
			{
				UIComponent(cell).drawNow();
			}
			_cellHeight = DisplayObject(cell).height;
			_cellRender = value;
			invalidate(InvalidationType.CELL_RENDER);
		}

		public function get labelField():String
		{
			return _labelField;
		}
		/**
		 *	列表需要呈现的数据属性名.如果是自定义单元格渲染器.则此字段无效. 
		 * @param value 列表需要呈现的数据属性名.
		 * @see coffe.controls.CellRender.labelField
		 */
		public function set labelField(value:String):void
		{
			_labelField = value;
			invalidate(InvalidationType.CELL_RENDER)
		}
		
		override public function dispose():void
		{
			super.dispose();
			while(_cells.length>0)
			{
				_cells.pop().dispose();
			}
			_cells = null;
			_selectedData = null;
			if(_data)
			{
				_data.removeAll();
				_data.removeEventListener(DataChangeEvent.DATA_CHANGE,onDataChange);
			}
			_data = null;
		}

		public function get cellAutoSize():Boolean
		{
			return _cellAutoSize;
		}
		/**
		 *	单元格是否根据列表的宽度自动调整宽度. 
		 * @param value 单元格是否根据列表的宽度自动调整宽度.默认为true
		 * 
		 */
		[Inspectable(type="Boolean",name="单元格是否与列表等宽",defaultValue=true)]
		public function set cellAutoSize(value:Boolean):void
		{
			_cellAutoSize = value;
		}
		public function get gap():Number
		{
			return _gap;
		}
		/**
		 *	单元格之间的垂直间隔距离. 
		 * @param value 单元格之间的垂直间隔距离.默认值:2
		 * 
		 */
		[Inspectable(type="Number",name="单元格垂直间隔",defaultValue=2)]
		public function set gap(value:Number):void
		{
			_gap = value;
			invalidate(InvalidationType.SIZE);
		}

	}
}