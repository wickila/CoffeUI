package coffe.controls
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import coffe.core.InvalidationType;
	import coffe.core.ScrollBarDirection;
	import coffe.core.ScrollPolicy;
	import coffe.core.UIComponent;
	import coffe.events.ScrollEvent;
	
	/**
	 *	滚动面板.具有水平与垂直的滚动条的可滚动显示的显示容器.
	 * 	<br>可设置样式
	 * 	<table width="100%">
	 *	<tr><td>样式名称</td><td>描述</td><td>默认值</td></tr>
	 * 	<tr><td>backgroundStyle</td><td>背景样式</td><td>ScrollPaneBackgroundSkin</td></tr>
	 * 	<tr><td>scrollBarStyle</td><td>滚动条样式</td><td>ScrollBar.DEFAULT_STYLE</td></tr>
	 * 	<tr><td>upArrowStyle</td><td>上按钮样式</td><td>ScrollBarUpArrowSkin</td></tr>
	 * 	<tr><td>downArrowStyle</td><td>下按钮样式</td><td>ScrollBarDownArrowSkin</td></tr>
	 * 	<tr><td>thumbStyle</td><td>滑动条样式</td><td>ScrollBarThumbSkin</td></tr>
	 * 	<tr><td>trackStyle</td><td>轨道样式</td><td>ScrollBarTrackSkin</td></tr>
	 * 	<tr><td>thumbIconStyle</td><td>滑块样式</td><td>ScrollBarThumbIconSkin</td></tr>
	 * </table>
	 * @see coffe.controls.ScrollBar.DEFAULT_STYLE
	 */
	public class ScrollPane extends UIComponent
	{
		/**
		 *	组件的全局默认样式.每个组件都拥有自己单独的 DEFAULT_STYLE,并且在组件初始化的时候,会将DEFAULT_STYLE的样式信息赋值给组件.
		 * 	<br>此默认样式信息是全局样式信息.所以可以在程序初始化的时候,设置组件的全局默认样式信息.
		 * 	<br>默认滚动面板样式:
		 * 	<table width="100%">
		 *  <tr><td>样式名称</td><td>描述</td><td>默认值</td></tr>
		 *  <tr><td>backgroundStyle</td><td>背景样式</td><td>ScrollPaneBackgroundSkin</td></tr>
		 *  <tr><td>scrollBarStyle</td><td>滚动条样式</td><td>ScrollBar.DEFAULT_STYLE</td></tr>
		 *  </table>
		 * 	@see coffe.core.UIComponent.initDefaultStyle()
		 * 	@see coffe.core.UIComponent.setStyle()
		 * 	@see coffe.core.UIComponent.combinStyle()
		 *  @see coffe.controls.ScrollBar.DEFAULT_STYLE
		 * 	@example
		 * 	ObjectUtils.combineObject(ComboBox.DEFAULT_STYLE,{"listStyle":{"cellRender":"com.dragonlance.view.ComboxCellRender","backgroundStyle":"dl.asset.core.ComboxListBgAsset"},"buttonStyle":{"labelFormat":'{"color":"0xffffff","font":"宋体","size":12}',"labelFilter":""}});
		 */
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
		
		/**
		 *	创建一个新的滚动面板 
		 * 
		 */
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
		public function get vScrollMaxPosition():Number
		{
			return _vScrollBar.maxScrollPosition;
		}
		/**
		 *	垂直方向最大滚动位置 
		 * @return 垂直方向最大滚动位置
		 * @see coffe.controls.ScrollBar.maxScrollPosition
		 */		
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
		
		/**
		 *	鼠标滚动时.更新显示区域与滚动条. 
		 * @param event 鼠标滚动事件.
		 * 
		 */
		protected function onScrollEvent(event:ScrollEvent):void
		{
			updateScrollRect();
		}
		
		override public function drawLayout():void
		{
			if(_background){
				_background.width = width;
				_background.height = height;
			}else
			{
				graphics.clear();
				graphics.beginFill(0,0);
				graphics.drawRect(0,0,width,height);
				graphics.endFill();
			}
			updateScrollBar();
		}
		/**
		 * 更新滚动条是否需要显示，以及滚动条的长度 
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
		 *	滚动条的样式. 
		 * @param style 一个包含滚动条样式信息的Object对象
		 * @see coffe.controls.ScrollBar
		 * @see coffe.controls.ScrollBar.DEFAULT_STYLE
		 */
		public function set scrollBarStyle(style:Object):void
		{
			combinStyle(_scrollBarStyle,style);
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	滚动条上箭头样式 
		 * @param value 滚动条上箭头样式.默认值:ScrollBarUpArrowSkin
		 * @see coffe.controls.ScrollBar.upArrowStyle
		 */		
		[Inspectable(type="String",name="上箭头样式",defaultValue="ScrollBarUpArrowSkin")]
		public function set upArrowStyle(value:String):void
		{
			_scrollBarStyle["upArrowStyle"] = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	滚动条下箭头样式 
		 * @param value 滚动条下箭头样式.默认值:ScrollBarDownArrowSkin
		 * @see coffe.controls.ScrollBar.upArrowStyle
		 */
		[Inspectable(type="String",name="下箭头样式",defaultValue="ScrollBarDownArrowSkin")]
		public function set downArrowStyle(value:String):void
		{
			_scrollBarStyle["downArrowStyle"] = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	滚动条滑动条样式 
		 * @param value 滚动条滑动条样式.默认值:ScrollBarThumbSkin
		 * @see coffe.controls.ScrollBar.upArrowStyle
		 */
		[Inspectable(type="String",name="滑动条样式",defaultValue="ScrollBarThumbSkin")]
		public function set thumbStyle(value:String):void
		{
			_scrollBarStyle["thumbStyle"] = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	滚动条的滑动条图标样式 
		 * @param value 滚动条的滑动条图标样式.默认值:ScrollBarThumbIconSkin
		 * @see coffe.controls.ScrollBar.upArrowStyle
		 */
		[Inspectable(type="String",name="滑动条图标样式",defaultValue="ScrollBarThumbIconSkin")]
		public function set thumbIconStyle(value:String):void
		{
			_scrollBarStyle["thumbIconStyle"] = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	滚动条轨道样式 
		 * @param value 滚动条轨道样式.默认值:ScrollBarTrackSkin
		 * @see coffe.controls.ScrollBar.upArrowStyle
		 */
		[Inspectable(type="String",name="轨道样式",defaultValue="ScrollBarTrackSkin")]
		public function set trackStyle(value:String):void
		{
			_scrollBarStyle["trackStyle"] = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	背景样式 
		 * @param style.背景样式.一个显示对象类的类名.默认值:ScrollPaneBackgroundSkin
		 * 
		 */		
		[Inspectable(type="String",name="背景样式",defaultValue="ScrollPaneBackgroundSkin")]
		public function set backgroundStyle(style:String):void
		{
			_backgroundStyle = style;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	水平滚动开关状态
		 * @param value 水平滚动开关状态.默认值:auto.
		 * @see coffe.core.ScrollPolicy
		 */		
		[Inspectable(defaultValue="auto",name="水平滚动",enumeration="on,off,auto")]
		public function set horizontalScrollPolicy(value:String):void
		{
			_horizontalScrollPolicy = value;
			invalidate(InvalidationType.SIZE);
		}
		/**
		 *	垂直滚动开关状态
		 * @param value 垂直滚动开关状态.默认值:auto.
		 * @see coffe.core.ScrollPolicy
		 */	
		[Inspectable(defaultValue="auto",name="垂直滚动",enumeration="on,off,auto")]
		public function set verticalScrollPolicy(value:String):void
		{
			_verticalScrollPolicy = value;
			invalidate(InvalidationType.SIZE);
		}
		/**
		 *	添加显示内容到滚动面板中.添加后滚动面板会自动调整滚动条的显示.
		 * @param content 需要显示的显示对象.
		 * 
		 */		
		public function addContent(content:DisplayObject):void
		{
			contentClip.addChild(content);
			invalidate(InvalidationType.SIZE);
		}
		/**
		 *	移除显示内容.移除显示内容后,滚动面板会自动调整滚动条的显示.
		 * 用addContent添加显示内容后,记得主动调用此方法移除显示内容.否则滚动面板不会更新滚动条.
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
		 *	更新可显示区域 
		 * 
		 */		
		protected function updateScrollRect():void
		{
			contentClipWrap.scrollRect = new Rectangle(_hScrollBar.scrollPosition,_vScrollBar.scrollPosition,width-vScrollWidth,height-hScrollHeight);
		}
		/**
		 *	水平滚动位置,设置此值会主动刷新滚动面板的显示区域.
		 * @param value 水平滚动位置.
		 * @see coffe.controls.ScrollBar.scrollPosition
		 */		
		public function set hScrollPosition(value:Number):void
		{
			_hScrollBar.scrollPosition = value;
			updateScrollRect();
		}
		/**
		 *	垂直滚动位置,设置此值会主动刷新滚动面板的显示区域.
		 * @param value 垂直滚动位置.
		 * @see coffe.controls.ScrollBar.scrollPosition
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