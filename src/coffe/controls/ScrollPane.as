package coffe.controls
{
	import coffe.DebugSprite;
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;
	import coffe.events.ScrollEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class ScrollPane extends UIComponent
	{
		public static const DEFAULT_STYLE:Object={
			scrollBarStyle:ScrollBar.DEFAULT_STYLE,
			backgroundStyle:"ScrollPaneBackgroundSkin"
		};
		private var _background:DisplayObject;
		private var _vScrollBar:ScrollBar;
		private var _hScrollBar:ScrollBar;
		private var _backgroundStyle:String;
		private var _scrollBarStyle:Object;
		
		protected var _horizontalScrollPolicy:String=ScrollPolicy.AUTO;
		protected var _verticalScrollPolicy:String=ScrollPolicy.AUTO;
		
		protected var contentClip:Sprite;
		protected var contentClipWrap:Sprite;
		
		public function ScrollPane()
		{
			super();
			contentClipWrap = new Sprite();
			contentClip = new Sprite();
			contentClipWrap.addChild(contentClip);
			addChild(contentClipWrap);
		}
		
		override protected function initEvents():void
		{
			super.initEvents();
			addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
		}
		
		protected function onMouseWheel(event:MouseEvent):void
		{
			if(event.delta>0)
			{
				if(_vScrollBar && _vScrollBar.visible)
				{
					_vScrollBar.scrollPosition -= _vScrollBar.lineScrollSize;
				}
			}else
			{
				if(_vScrollBar && _vScrollBar.visible)
				{
					_vScrollBar.scrollPosition += _vScrollBar.lineScrollSize;
				}
			}
		}
		
		override protected function initDefaultStyle():void
		{
			setStyle(DEFAULT_STYLE);
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.STYLE))
			{
				if(_background && contains(_background))removeChild(_background);
				if(_vScrollBar){_vScrollBar.removeEventListener(ScrollEvent.SCROLL,onScrollEvent);_vScrollBar.dispose();}
				if(_hScrollBar){_hScrollBar.removeEventListener(ScrollEvent.SCROLL,onScrollEvent);_hScrollBar.dispose();}
				_background = getDisplayObjectInstance(_backgroundStyle);
				if(_background)addChildAt(_background,0);
				_vScrollBar = new ScrollBar();_vScrollBar.addEventListener(ScrollEvent.SCROLL,onScrollEvent)
				_hScrollBar = new ScrollBar();_hScrollBar.addEventListener(ScrollEvent.SCROLL,onScrollEvent);
				_vScrollBar.setStyle(_scrollBarStyle);
				_hScrollBar.setStyle(_scrollBarStyle);
				_hScrollBar.direction = ScrollBarDirection.HORIZONTAL;
				_vScrollBar.drawNow();
				_hScrollBar.drawNow();
				addChildAt(_vScrollBar,1);
				addChildAt(_hScrollBar,2);
			}
			if(isInvalid(InvalidationType.STYLE,InvalidationType.SIZE))
			{
				drawLayout();
				updateScrollRect();
			}
		}
		
		private function onScrollEvent(event:ScrollEvent):void
		{
			updateScrollRect();
		}
		
		override public function drawLayout():void
		{
			updateScrollBar();
		}
		/**
		 * @description 更新滚动条是否需要显示，以及滚动条的长度 
		 * 
		 */		
		protected function updateScrollBar():void
		{
			_hScrollBar.y = _background.height-_hScrollBar.height;
			_vScrollBar.x = _background.width - _vScrollBar.width;
			if(_horizontalScrollPolicy == ScrollPolicy.OFF)
			{
				_hScrollBar.visible = false;
			}else if(_horizontalScrollPolicy == ScrollPolicy.ON)
			{
				_hScrollBar.visible = true;
			}else
			{
				_hScrollBar.visible = width<contentClip.width;
			}
			if(_verticalScrollPolicy == ScrollPolicy.OFF)
			{
				_vScrollBar.visible = false;
			}else if(_horizontalScrollPolicy == ScrollPolicy.ON)
			{
				_vScrollBar.visible = true;
			}else
			{
				_vScrollBar.visible = height<contentClip.height;
			}
			_hScrollBar.width = _background.width - vScrollWidth;
			_vScrollBar.height = _background.height-hScrollHeight;
			_hScrollBar.pageSize = width;
			_hScrollBar.maxScrollPosition = contentClip.width-width;
			_vScrollBar.pageSize = height;
			_vScrollBar.maxScrollPosition = contentClip.height-height;
			_hScrollBar.drawNow();
			_vScrollBar.drawNow();
		}
		
		public function set scrollBarStyle(style:Object):void
		{
			_scrollBarStyle = style;
		}
		
		override public function set width(value:Number):void
		{
			_background.width = value;
			invalidate(InvalidationType.SIZE);
		}
		
		override public function get width():Number
		{
			return _background.width;
		}
		
		override public function set height(value:Number):void
		{
			_background.height = value;
			invalidate(InvalidationType.SIZE);
		}
		
		override public function get height():Number
		{
			return _background.height;
		}
		
		[Inspectable(type="String",name="上箭头样式",defaultValue="ScrollBarUpArrowSkin")]
		public function set upArrowStyle(value:String):void
		{
			_scrollBarStyle["upArrowStyle"] = value;
			invalidate(InvalidationType.STYLE);
		}
		
		[Inspectable(type="String",name="下箭头样式",defaultValue="ScrollBarDownArrowSkin")]
		public function set downArrowStyle(value:String):void
		{
			_scrollBarStyle["downArrowStyle"] = value;
			invalidate(InvalidationType.STYLE);
		}
		
		[Inspectable(type="String",name="滑动条样式",defaultValue="ScrollBarThumbSkin")]
		public function set thumbStyle(value:String):void
		{
			_scrollBarStyle["thumbStyle"] = value;
			invalidate(InvalidationType.STYLE);
		}
		
		[Inspectable(type="String",name="滑动条图标样式",defaultValue="ScrollBarThumbIconSkin")]
		public function set thumbIconStyle(value:String):void
		{
			_scrollBarStyle["thumbIconStyle"] = value;
			invalidate(InvalidationType.STYLE);
		}
		
		[Inspectable(type="String",name="轨道样式",defaultValue="ScrollBarTrackSkin")]
		public function set trackStyle(value:String):void
		{
			_scrollBarStyle["trackStyle"] = value;
			invalidate(InvalidationType.STYLE);
		}
		
		[Inspectable(type="String",name="背景样式",defaultValue="ScrollPaneBackgroundSkin")]
		public function set backgroundStyle(style:String):void
		{
			_backgroundStyle = style;
			invalidate(InvalidationType.STYLE);
		}
		
		[Inspectable(defaultValue="auto",name="水平滚动",enumeration="on,off,auto")]
		public function set horizontalScrollPolicy(value:String):void
		{
			_horizontalScrollPolicy = value;
		}

		[Inspectable(defaultValue="auto",name="垂直滚动",enumeration="on,off,auto")]
		public function set verticalScrollPolicy(value:String):void
		{
			_verticalScrollPolicy = value;
		}
		
		public function addContent(content:DisplayObject):void
		{
			contentClip.addChild(content);
			invalidate(InvalidationType.SIZE);
		}
		/**
		 *	@description 更新可显示区域 
		 * 
		 */		
		protected function updateScrollRect():void
		{
			contentClipWrap.scrollRect = new Rectangle(_hScrollBar.scrollPosition,_vScrollBar.scrollPosition,width-vScrollWidth,height-hScrollHeight);
		}
		
		public function set hScrollPosition(value:Number):void
		{
			_hScrollBar.scrollPosition = value;
			updateScrollRect();
		}
		
		public function set vScrollPosition(value:Number):void
		{
			_vScrollBar.scrollPosition = value;
			updateScrollRect();
		}
		
		protected function get vScrollWidth():Number
		{
			return _vScrollBar.visible?_vScrollBar.width:0;
		}
		
		protected function get hScrollHeight():Number
		{
			return _hScrollBar.visible?_hScrollBar.height:0;
		}
	}
}