package coffe.controls
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;
	import coffe.events.ScrollEvent;
	
	public class ScrollPane extends UIComponent
	{
		public static var DEFAULT_STYLE:Object={
			scrollBarStyle:ScrollBar.DEFAULT_STYLE,
			backgroundStyle:"ScrollPaneBackgroundSkin"
		};
		protected var _background:DisplayObject;
		protected var _vScrollBar:ScrollBar;
		protected var _hScrollBar:ScrollBar;
		protected var _backgroundStyle:String;
		protected var _scrollBarStyle:Object={};
		
		protected var _horizontalScrollPolicy:String=ScrollPolicy.AUTO;
		protected var _verticalScrollPolicy:String=ScrollPolicy.AUTO;
		
		protected var contentClip:Sprite;
		protected var contentClipWrap:Sprite;
		
		public function ScrollPane()
		{
			super();
			contentClipWrap = new Sprite();
			contentClip = new Sprite();
		}
		
		override protected function initEvents():void
		{
			super.initEvents();
			addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
		}
		
		override protected function removeEvents():void
		{
			if(_vScrollBar)_vScrollBar.removeEventListener(ScrollEvent.SCROLL,onScrollEvent);
			if(_vScrollBar)_vScrollBar.removeEventListener(MouseEvent.CLICK,onScrollbarClick);
			if(_hScrollBar)_hScrollBar.removeEventListener(ScrollEvent.SCROLL,onScrollEvent);
			if(_hScrollBar)_hScrollBar.removeEventListener(MouseEvent.CLICK,onScrollbarClick);
			removeEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
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
		/**
		 *	垂直方向最大滚动位置 
		 * @return 
		 * 
		 */		
		public function get vScrollMaxPosition():Number
		{
			return _vScrollBar.maxScrollPosition;
		}
		
		public function get hScrollMaxPosition():Number
		{
			return _hScrollBar.maxScrollPosition;
		}
		
		override protected function initDefaultStyle():void
		{
			setStyle(DEFAULT_STYLE);
		}
		
		override protected function draw():void
		{
			drawComponents();
			if(isInvalid(InvalidationType.STYLE,InvalidationType.SIZE))
			{
				drawLayout();
				updateScrollRect();
			}
		}
		
		protected function drawComponents():void
		{
			if(isInvalid(InvalidationType.STYLE))
			{
				if(_background && contains(_background))removeChild(_background);
				_background = getDisplayObjectInstance(_backgroundStyle);
				if(_background)addChildAt(_background,0);
				if(_vScrollBar == null){_vScrollBar = new ScrollBar();_vScrollBar.addEventListener(ScrollEvent.SCROLL,onScrollEvent);_vScrollBar.addEventListener(MouseEvent.CLICK,onScrollbarClick);}
				if(_hScrollBar == null){_hScrollBar = new ScrollBar();_hScrollBar.addEventListener(ScrollEvent.SCROLL,onScrollEvent);_hScrollBar.addEventListener(MouseEvent.CLICK,onScrollbarClick);}
				_vScrollBar.setStyle(_scrollBarStyle);
				_hScrollBar.setStyle(_scrollBarStyle);
				_hScrollBar.direction = ScrollBarDirection.HORIZONTAL;
				_vScrollBar.drawNow();
				_hScrollBar.drawNow();
				if(contentClipWrap==null)contentClipWrap = new Sprite();
				if(contentClip==null)contentClip = new Sprite();
				contentClipWrap.addChild(contentClip);
				addChild(contentClipWrap);
				addChildAt(_vScrollBar,1);
				addChildAt(_hScrollBar,2);
			}
		}
		
		override public function get width():Number
		{
			if(!isNaN(_width))return _width;
			if(_background)return _background.width;
			return super.width;
		}
		
		override public function get height():Number
		{
			if(!isNaN(_height))return _height;
			if(_background)return _background.height;
			return super.height;
		}
		
		protected function onScrollbarClick(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
		}
		
		protected function onScrollEvent(event:ScrollEvent):void
		{
			updateScrollRect();
		}
		
		override public function drawLayout():void
		{
			if(_background){
				_background.width = width;
				_background.height = height;
			}
			updateScrollBar();
		}
		/**
		 * @description 更新滚动条是否需要显示，以及滚动条的长度 
		 * 
		 */		
		protected function updateScrollBar():void
		{
			_hScrollBar.y = height -_hScrollBar.height;
			_vScrollBar.x = width - _vScrollBar.width;
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
			}else if(_verticalScrollPolicy == ScrollPolicy.ON)
			{
				_vScrollBar.visible = true;
			}else
			{
				_vScrollBar.visible = height<contentClip.height;
			}
			_hScrollBar.width = width - vScrollWidth;
			_vScrollBar.height = height-hScrollHeight;
			_hScrollBar.pageSize = width;
			_hScrollBar.maxScrollPosition = contentClip.width-width;
			_vScrollBar.pageSize = height;
			_vScrollBar.maxScrollPosition = contentClip.height-height;
			_hScrollBar.drawNow();
			_vScrollBar.drawNow();
		}
		/**
		 *	滚动条样式 
		 * @param style
		 * 
		 */		
		public function set scrollBarStyle(style:Object):void
		{
			combinStyle(_scrollBarStyle,style);
			invalidate(InvalidationType.STYLE);
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
			invalidate(InvalidationType.SIZE);
		}

		[Inspectable(defaultValue="auto",name="垂直滚动",enumeration="on,off,auto")]
		public function set verticalScrollPolicy(value:String):void
		{
			_verticalScrollPolicy = value;
			invalidate(InvalidationType.SIZE);
		}
		/**
		 *	添加显示内容 
		 * @param content
		 * 
		 */		
		public function addContent(content:DisplayObject):void
		{
			contentClip.addChild(content);
			invalidate(InvalidationType.SIZE);
		}
		/**
		 *	移除显示内容 
		 * @param content
		 * 
		 */		
		public function removeContent(content:DisplayObject):void
		{
			if(contentClip.contains(content))
			{
				contentClip.removeChild(content);
				invalidate(InvalidationType.SIZE);
			}
		}
		/**
		 *	@description 更新可显示区域 
		 * 
		 */		
		protected function updateScrollRect():void
		{
			contentClipWrap.scrollRect = new Rectangle(_hScrollBar.scrollPosition,_vScrollBar.scrollPosition,width-vScrollWidth,height-hScrollHeight);
		}
		/**
		 *	水平滚动位置 
		 * @param value
		 * 
		 */		
		public function set hScrollPosition(value:Number):void
		{
			_hScrollBar.scrollPosition = value;
			updateScrollRect();
		}
		/**
		 *	垂直滚动位置 
		 * @param value
		 * 
		 */		
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
		
		override public function dispose():void
		{
			super.dispose();
			if(_background && contains(_background))removeChild(_background);_background = null;
			if(_vScrollBar)_vScrollBar.dispose();_vScrollBar = null;
			if(_hScrollBar)_hScrollBar.dispose();_hScrollBar = null;
			if(contentClip)
			{
				if(contentClip.parent)contentClip.parent.removeChild(contentClip);
				while(contentClip.numChildren){contentClip.removeChildAt(0)};
			}
			if(contentClipWrap&&contains(contentClipWrap))removeChild(contentClipWrap);
		}
	}
}