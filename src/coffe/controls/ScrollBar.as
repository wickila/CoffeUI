package coffe.controls
{
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;
	import coffe.events.ComponentEvent;
	import coffe.events.ScrollEvent;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	public class ScrollBar extends UIComponent
	{
		public static const DEFAULT_STYLE:Object = {
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
		
		public function ScrollBar()
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
				if(_upArrow)_upArrow.dispose();
				if(_downArrow)_downArrow.dispose();
				if(_thumb)_thumb.dispose();
				if(_track&&contains(_track))removeChild(_track);
				_track = getDisplayObjectInstance(_trackStyle);
				if(_track)addChild(_track);
				_upArrow = new Button();
				_upArrow.label = "";
				_upArrow.backGroundStyle = _upArrowStyle;
				_upArrow.displacement = false;
				_upArrow.autoRepeat = true;
				_upArrow.addEventListener(ComponentEvent.BUTTON_DOWN,scrollPressHandler,false,0,true);
				addChild(_upArrow);
				_upArrow.drawNow();
				_downArrow = new Button();
				_downArrow.label = "";
				_downArrow.backGroundStyle = _downArrowStyle;
				_downArrow.displacement =false;
				_downArrow.autoRepeat = true;
				_downArrow.addEventListener(ComponentEvent.BUTTON_DOWN,scrollPressHandler,false,0,true);
				addChild(_downArrow);
				_downArrow.drawNow();
				_thumb = new Button();
				_thumb.label = "";
				_thumb.backGroundStyle = _thumbStyle;
				_thumb.iconStyle = _thumbIconStyle;
				_thumb.displacement = false;
				_thumb.addEventListener(MouseEvent.MOUSE_DOWN,thumbPressHandler,false,0,true);
				addChild(_thumb);
				_thumb.drawNow();
				_thumb.y = _upArrow.height;
				_thumb.x = (_track.width-_thumb.width)*.5;
			}
			if(isInvalid(InvalidationType.STYLE,InvalidationType.SIZE,InvalidationType.ENABLE))
			{
				drawLayout();
			}
			validate();
		}
		
		override public function drawLayout():void
		{
			_downArrow.y = _track.height-_downArrow.height;
			updateThumb();
			_thumb.drawLayout();
		}
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
		
		
		public function set scrollPosition(newScrollPosition:Number):void {
			setScrollPosition(newScrollPosition, true);
		}
		
		public function get minScrollPosition():Number {
			return _minScrollPosition;
		}		
		
		public function set minScrollPosition(value:Number):void {
			setScrollProperties(_pageSize,value,_maxScrollPosition);
		}
		
		public function get maxScrollPosition():Number {
			return _maxScrollPosition;
		}		
		
		public function set maxScrollPosition(value:Number):void {
			setScrollProperties(_pageSize,_minScrollPosition,value);
		}
		
		public function get pageSize():Number {
			return _pageSize;
		}
		
		public function set pageSize(value:Number):void {
			if (value > 0) {
				_pageSize = value;
			}
		}
		
		public function get pageScrollSize():Number {
			return (_pageScrollSize == 0) ? _pageSize : _pageScrollSize;
		}
		
		public function set pageScrollSize(value:Number):void {
			if (value>=0) { _pageScrollSize = value; }
		}
		
		public function get lineScrollSize():Number {
			return _lineScrollSize;
		}		
		
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
		
		public function setScrollPosition(newScrollPosition:Number, fireEvent:Boolean=true):void {
			var oldPosition:Number = scrollPosition;
			_scrollPosition = Math.max(_minScrollPosition,Math.min(_maxScrollPosition, newScrollPosition));
			if (oldPosition == _scrollPosition) { return; }
			if (fireEvent) { dispatchEvent(new ScrollEvent(_direction, scrollPosition-oldPosition, scrollPosition)); }
			callLater(updateThumb);
		}
		
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
		
		override public function set height(value:Number):void
		{
			if(height == value)return;
			if(_direction == ScrollBarDirection.VERTICAL)
			{
				_track.height = value;
				invalidate(InvalidationType.SIZE);
			}
		}
		
		override public function set width(value:Number):void
		{
			if(width == value)return;
			if(_direction == ScrollBarDirection.HORIZONTAL)
			{
				_track.height = value;
				invalidate(InvalidationType.SIZE);
			}
		}
		
		[Inspectable(type="String",name="上箭头样式",defaultValue="ScrollBarUpArrowSkin")]
		public function set upArrowStyle(value:String):void
		{
			_upArrowStyle = value;
			invalidate(InvalidationType.STYLE);
		}

		[Inspectable(type="String",name="下箭头样式",defaultValue="ScrollBarDownArrowSkin")]
		public function set downArrowStyle(value:String):void
		{
			_downArrowStyle = value;
			invalidate(InvalidationType.STYLE);
		}

		[Inspectable(type="String",name="滑动条样式",defaultValue="ScrollBarThumbSkin")]
		public function set thumbStyle(value:String):void
		{
			_thumbStyle = value;
			invalidate(InvalidationType.STYLE);
		}

		[Inspectable(type="String",name="滑动条图标样式",defaultValue="ScrollBarThumbIconSkin")]
		public function set thumbIconStyle(value:String):void
		{
			_thumbIconStyle = value;
			invalidate(InvalidationType.STYLE);
		}

		[Inspectable(type="String",name="轨道样式",defaultValue="ScrollBarTrackSkin")]
		public function set trackStyle(value:String):void
		{
			_trackStyle = value;
			invalidate(InvalidationType.STYLE);
		}

		public function get direction():String
		{
			return _direction;
		}
		
		[Inspectable(enumeration="horizontal,vertical", name="方向", defaultValue="vertical")]
		public function set direction(value:String):void
		{
			if(_direction == value)return;
			_direction = value;
			if(isLivePreview) {
				if (_direction == ScrollBarDirection.HORIZONTAL) {
					setScaleX(-1);
					y = _track.height;
				} else {
					setScaleY(1);
					y = 0;
				}
			}else
			{
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
		}
	}
}