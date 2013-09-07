package coffe.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;
	import coffe.events.ComponentEvent;
	import coffe.events.ScrollEvent;
	import coffe.core.ScrollBarDirection;
	
	/**
	 * 滚动条组件.滚动条分两个方向.默认是垂直方向的.可设置为水平方向
	 * <br>可设置样式
	 * <table width="100%">
	 * <tr><td>样式名称</td><td>描述</td><td>默认值</td></tr>
	 * <tr><td>upArrowStyle</td><td>上按钮样式</td><td>ScrollBarUpArrowSkin</td></tr>
	 * <tr><td>downArrowStyle</td><td>下按钮样式</td><td>ScrollBarDownArrowSkin</td></tr>
	 * <tr><td>thumbStyle</td><td>滑动条样式</td><td>ScrollBarThumbSkin</td></tr>
	 * <tr><td>trackStyle</td><td>轨道样式</td><td>ScrollBarTrackSkin</td></tr>
	 * <tr><td>thumbIconStyle</td><td>滑块样式</td><td>ScrollBarThumbIconSkin</td></tr>
	 * </table>
	 */
	public class ScrollBar extends UIComponent
	{
		/**
		 *	组件的全局默认样式.每个组件都拥有自己单独的 DEFAULT_STYLE,并且在组件初始化的时候,会将DEFAULT_STYLE的样式信息赋值给组件.
		 * 	<br>此默认样式信息是全局样式信息.所以可以在程序初始化的时候,设置组件的全局默认样式信息.
		 * 	<br>默认滚动条样式:
		 * 	<table width="100%">
		 * <tr><td>样式名称</td><td>描述</td><td>默认值</td></tr>
		 * <tr><td>upArrowStyle</td><td>上按钮样式</td><td>ScrollBarUpArrowSkin</td></tr>
		 * <tr><td>downArrowStyle</td><td>下按钮样式</td><td>ScrollBarDownArrowSkin</td></tr>
		 * <tr><td>thumbStyle</td><td>滑动条样式</td><td>ScrollBarThumbSkin</td></tr>
		 * <tr><td>trackStyle</td><td>轨道样式</td><td>ScrollBarTrackSkin</td></tr>
		 * <tr><td>thumbIconStyle</td><td>滑块样式</td><td>ScrollBarThumbIconSkin</td></tr>
		 * </table>
		 * 	@see coffe.core.UIComponent.initDefaultStyle()
		 * 	@see coffe.core.UIComponent.setStyle()
		 * 	@see coffe.core.UIComponent.combinStyle()
		 * 	@example
		 * 	ObjectUtils.combineObject(ComboBox.DEFAULT_STYLE,{"listStyle":{"cellRender":"com.dragonlance.view.ComboxCellRender","backgroundStyle":"dl.asset.core.ComboxListBgAsset"},"buttonStyle":{"labelFormat":'{"color":"0xffffff","font":"宋体","size":12}',"labelFilter":""}});
		 */
		public static var DEFAULT_STYLE:Object = {
			upArrowStyle:"ScrollBarUpArrowSkin",
			downArrowStyle:"ScrollBarDownArrowSkin",
			thumbStyle:"ScrollBarThumbSkin",
			trackStyle:"ScrollBarTrackSkin",
			thumbIconStyle:"ScrollBarThumbIconSkin"
		};
		
		protected var _direction:String=ScrollBarDirection.VERTICAL;
		
		private var _pageSize:Number = 10;
		private var _pageScrollSize:Number = 5;
		private var _lineScrollSize:Number = 10;
		private var _minScrollPosition:Number = 0;
		private var _maxScrollPosition:Number = 10;
		private var _scrollPosition:Number = 0;
		private var thumbScrollOffset:Number;
		protected var inDrag:Boolean = false;
		
		protected var _upArrow:Button;
		protected var _downArrow:Button;
		protected var _thumb:Button;
		protected var _track:DisplayObject;
		protected var _upArrowStyle:String;
		protected var _downArrowStyle:String;
		protected var _thumbStyle:String;
		protected var _thumbIconStyle:String;
		protected var _trackStyle:String;
		
		/**
		 *	创建一个滚动条组件. 
		 * 
		 */
		public function ScrollBar()
		{
			super();
		}
		
		override protected function initDefaultStyle():void
		{
			setStyle(DEFAULT_STYLE);
		}
		
		override protected function removeEvents():void
		{
			if(_upArrow)_upArrow.removeEventListener(ComponentEvent.BUTTON_DOWN,scrollPressHandler);
			if(_downArrow)_downArrow.removeEventListener(ComponentEvent.BUTTON_DOWN,scrollPressHandler);
			if(_thumb)_thumb.removeEventListener(MouseEvent.MOUSE_DOWN,thumbPressHandler);
			if(stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,handleThumbDrag);
				stage.removeEventListener(MouseEvent.MOUSE_UP,thumbReleaseHandler);
			}
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.STYLE))
			{
				if(_track&&contains(_track))removeChild(_track);
				_track = getDisplayObjectInstance(_trackStyle);
				addChild(_track);
				drawComponents();
				_upArrow.backGroundStyle = _upArrowStyle;
				_upArrow.drawNow();
				addChild(_upArrow);
				_downArrow.backGroundStyle = _downArrowStyle;
				_downArrow.drawNow();
				addChild(_downArrow);
				_thumb.backGroundStyle = _thumbStyle;
				_thumb.iconStyle = _thumbIconStyle;
				_thumb.drawNow();
				addChild(_thumb);
			}
			if(isInvalid(InvalidationType.STYLE,InvalidationType.SIZE,InvalidationType.ENABLE))
			{
				drawLayout();
			}
		}
		
		protected function drawComponents():void
		{
			if(_upArrow == null)
			{
				_upArrow = new Button();
				_upArrow.label = "";
				_upArrow.displacement = false;
				_upArrow.autoRepeat = true;
				_upArrow.addEventListener(ComponentEvent.BUTTON_DOWN,scrollPressHandler,false,0,true);
			}
			if(_downArrow == null)
			{
				_downArrow = new Button();
				_downArrow.label = "";
				_downArrow.displacement =false;
				_downArrow.autoRepeat = true;
				_downArrow.addEventListener(ComponentEvent.BUTTON_DOWN,scrollPressHandler,false,0,true);
			}
			if(_thumb == null)
			{
				_thumb = new Button();
				_thumb.label = "";
				_thumb.iconStyle = _thumbIconStyle;
				_thumb.displacement = false;
				_thumb.addEventListener(MouseEvent.MOUSE_DOWN,thumbPressHandler,false,0,true);
			}
		}
		
		override public function drawLayout():void
		{
			_track.height = direction == ScrollBarDirection.HORIZONTAL?width:height;
			_downArrow.y = _track.height-_downArrow.height;
			_thumb.y = _upArrow.height;
			_thumb.x = (_track.width-_thumb.width)*.5;
			updateThumb();
			_thumb.drawLayout();
		}
		
		/**
		 *	设置滚动条的位置属性. 
		 * @param pageSize.单页尺寸
		 * @param minScrollPosition 最小滚动位置.
		 * @param maxScrollPosition 最大滚动位置.
		 * @param pageScrollSize 鼠标拖动滑动条的滚动尺寸
		 * 
		 */
		protected function setScrollProperties(pageSize:Number,minScrollPosition:Number,maxScrollPosition:Number,pageScrollSize:Number=0):void {
			this.pageSize = pageSize;
			_minScrollPosition = minScrollPosition;
			_maxScrollPosition = maxScrollPosition;
			if (pageScrollSize >= 0) { _pageScrollSize = pageScrollSize; }
			enable = (_maxScrollPosition > _minScrollPosition);
			setScrollPosition(_scrollPosition, false);
			updateThumb();
		}
		public function get scrollPosition():Number { return _scrollPosition; }
		/**
		 *	当前滚动条的滚动位置 
		 * @param newScrollPosition 当前滚动条的滚动位置
		 * 
		 */		
		public function set scrollPosition(newScrollPosition:Number):void {
			setScrollPosition(newScrollPosition, true);
		}
		public function get minScrollPosition():Number {
			return _minScrollPosition;
		}		
		/**
		 *	滚动条的最小位置 
		 * @param value 滚动条的最小位置,默认为0
		 * 
		 */		
		public function set minScrollPosition(value:Number):void {
			setScrollProperties(_pageSize,value,_maxScrollPosition);
		}
		public function get maxScrollPosition():Number {
			return _maxScrollPosition;
		}		
		/**
		 *	滚动条的最大位置 
		 * @param value 滚动条的最大位置.默认为10
		 * 
		 */		
		public function set maxScrollPosition(value:Number):void {
			setScrollProperties(_pageSize,_minScrollPosition,value);
		}
		
		public function get pageSize():Number {
			return _pageSize;
		}
		/**
		 *	单页的尺寸.决定滑动条的最大高度. 值越大,滑动条的最大高度越接近整个滚动条的高度.值越接近0,滑动条的最大高度也越来越接近设定的滑动条最小高度.
		 * @param value.单页的尺寸.必须大于0
		 * 
		 */		
		public function set pageSize(value:Number):void {
			if (value > 0) {
				_pageSize = value;
			}
		}
		
		public function get pageScrollSize():Number {
			return (_pageScrollSize == 0) ? _pageSize : _pageScrollSize;
		}
		/**
		 *	鼠标拖动滑动条的滚动尺寸 
		 * @param value 鼠标拖动滑动条的滚动尺寸 默认为5
		 * 
		 */		
		public function set pageScrollSize(value:Number):void {
			if (value>=0) { _pageScrollSize = value; }
		}
		
		public function get lineScrollSize():Number {
			return _lineScrollSize;
		}		
		/**
		 *	单步滚动尺寸 
		 * @param value 单步滚动尺寸.默认值:10
		 * 
		 */		
		public function set lineScrollSize(value:Number):void {
			if (value>0) {_lineScrollSize = value; }
		}
		
		protected function scrollPressHandler(event:ComponentEvent):void {
			event.stopImmediatePropagation();
			if (event.currentTarget == _upArrow) {
				setScrollPosition(_scrollPosition-_lineScrollSize); 
			} else if (event.currentTarget == _downArrow) {
				setScrollPosition(_scrollPosition+_lineScrollSize);
			} else {
				var mousePosition:Number = (_track.mouseY)/_track.height * (_maxScrollPosition-_minScrollPosition) + _minScrollPosition;
				var pgScroll:Number = (pageScrollSize == 0)?pageSize:pageScrollSize;
				if (_scrollPosition < mousePosition) {
					setScrollPosition(Math.min(mousePosition,_scrollPosition+pgScroll));
				} else if (_scrollPosition > mousePosition) {
					setScrollPosition(Math.max(mousePosition,_scrollPosition-pgScroll));
				}
			}
		}
		
		protected function thumbPressHandler(event:MouseEvent):void {
			inDrag = true;
			thumbScrollOffset = mouseY-_thumb.y;
			mouseChildren = false; // Should be able to do stage.mouseChildren, but doesn't seem to work.
			stage.addEventListener(MouseEvent.MOUSE_MOVE,handleThumbDrag,false,0,true);
			stage.addEventListener(MouseEvent.MOUSE_UP,thumbReleaseHandler,false,0,true);
		}
		
		protected function handleThumbDrag(event:MouseEvent):void {
			var pos:Number = Math.max(0, Math.min(_track.height-_thumb.height, mouseY-_track.y-thumbScrollOffset));
			setScrollPosition(pos/(_track.height-_thumb.height) * (_maxScrollPosition-_minScrollPosition) + _minScrollPosition);
		}
		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function thumbReleaseHandler(event:MouseEvent):void {
			inDrag = false;
			mouseChildren = true;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,handleThumbDrag);
			stage.removeEventListener(MouseEvent.MOUSE_UP,thumbReleaseHandler);
		}
		
		/**
		 *	设置滚动条的滚动位置 
		 * @param newScrollPosition 滚动条的滚动位置.
		 * @param fireEvent 是否发出滚动条事件.默认为true
		 * @see coffe.events.ScrollEvent
		 */
		public function setScrollPosition(newScrollPosition:Number, fireEvent:Boolean=true):void {
			var oldPosition:Number = scrollPosition;
			_scrollPosition = Math.max(_minScrollPosition,Math.min(_maxScrollPosition, newScrollPosition));
			if (oldPosition == _scrollPosition) { return; }
			if (fireEvent) { dispatchEvent(new ScrollEvent(_direction, scrollPosition-oldPosition, scrollPosition)); }
			invalidate(InvalidationType.SIZE);
		}
		
		/**
		 *	更新滑动条尺寸 
		 * 
		 */
		protected function updateThumb():void {
			var per:Number = _maxScrollPosition - _minScrollPosition + _pageSize;
			if (_track.height <= 12 || _maxScrollPosition <= _minScrollPosition || (per == 0 || isNaN(per))) {
				_thumb.height = 12;
				_thumb.visible = false;
			} else {
				_thumb.height = Math.max(13,_pageSize / per * (_track.height-_upArrow.height*2));
				_thumb.y = _track.y+(_track.height-_thumb.height-_upArrow.height*2)*((_scrollPosition-_minScrollPosition)/(_maxScrollPosition-_minScrollPosition))+_upArrow.height;
				_thumb.visible = enable;
			}
		}
		/**
		 *	上按钮样式. 
		 * @param value 上按钮样式.默认值ScrollBarUpArrowSkin
		 * @see coffe.controls.Button.backGroundStyle
		 */		
		[Inspectable(type="String",name="上箭头样式",defaultValue="ScrollBarUpArrowSkin")]
		public function set upArrowStyle(value:String):void
		{
			_upArrowStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	下按钮样式. 
		 * @param value 下按钮样式.默认值ScrollBarDownArrowSkin
		 * @see coffe.controls.Button.backGroundStyle
		 */	
		[Inspectable(type="String",name="下箭头样式",defaultValue="ScrollBarDownArrowSkin")]
		public function set downArrowStyle(value:String):void
		{
			_downArrowStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	滑动条样式. 
		 * @param value 滑动条样式.默认值:ScrollBarThumbSkin
		 * @see coffe.controls.Button.backGroundStyle
		 */
		[Inspectable(type="String",name="滑动条样式",defaultValue="ScrollBarThumbSkin")]
		public function set thumbStyle(value:String):void
		{
			_thumbStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 * 滑动条图标样式.
		 * @param value 滑动条图标样式.默认值:ScrollBarThumbIconSkin
		 * @see coffe.controls.Button.iconStyle
		 */
		[Inspectable(type="String",name="滑动条图标样式",defaultValue="ScrollBarThumbIconSkin")]
		public function set thumbIconStyle(value:String):void
		{
			_thumbIconStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	轨道样式 
		 * @param value 轨道样式.默认值:ScrollBarTrackSkin
		 * 
		 */
		[Inspectable(type="String",name="轨道样式",defaultValue="ScrollBarTrackSkin")]
		public function set trackStyle(value:String):void
		{
			_trackStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		
		override protected function onCreationComplete(event:Event):void
		{
			width = width*super.scaleX;
			height = height*super.scaleY;
			if(_direction == ScrollBarDirection.HORIZONTAL)
			{
				setScaleX(-1);
			}else
			{
				setScaleX(1);
			}
			draw();
			removeEventListener(ComponentEvent.CREATION_COMPLETE,onCreationComplete);
		}
		
		public function get direction():String
		{
			return _direction;
		}
		/**
		 *	滚动条方向. 
		 * @param value 滚动条方向.默认值:ScrollBarDirection.VERTICAL
		 * @see coffe.core.ScrollBarDirection
		 */		
		[Inspectable(enumeration="horizontal,vertical", name="方向", defaultValue="vertical")]
		public function set direction(value:String):void
		{
			if(_direction == value)return;
			_direction = value;
			if(_direction == ScrollBarDirection.HORIZONTAL)
			{
				rotation = -90;
				setScaleX(-1);
			}else
			{
				rotation = 0;
				setScaleX(1);
			}
		}
		
		/**
		 *	组件的可用性.滚动条组件禁用后,不会应用灰度滤镜. 
		 * @param value 组件可用性.默认值:true
		 * 
		 */
		override public function set enable(value:Boolean):void
		{
			super.enable = value;
			filters=[];
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_upArrow)_upArrow.dispose();_upArrow = null;
			if(_downArrow)_downArrow.dispose();_downArrow = null;
			if(_thumb)_thumb.dispose();_thumb = null;
			if(_track && contains(_track))removeChild(_track);_track = null;
		}
	}
}