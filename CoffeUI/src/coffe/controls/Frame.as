package coffe.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import coffe.core.AlignType;
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;
	import coffe.data.Language;
	import coffe.events.FrameEvent;

	/**
	 *	弹出框 
	 * @author wicki
	 * 
	 */	
	[Event(name="frameEvent", type="coffe.events.FrameEvent")]
	public class Frame extends UIComponent
	{
		public static var DEFAULT_STYLE:Object = {
			closeBackGroundStyle:"CloseButtonSkin",
			backgroundStyle:"FrameSkin",
			okStyle:{"backGroundStyle":"ButtonDefaultSkin","labelFormat":'{"color":"0x000000","font":"Arial","size":16,"kerning":true,"letterSpacing":5}'},
			cancelStyle:{"backGroundStyle":"ButtonDefaultSkin","labelFormat":'{"color":"0x000000","font":"Arial","size":16,"kerning":true,"letterSpacing":5}'},
			closeBtnRight:10,
			closeBtnTop:0,
			titleFilter:'{"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":5,"quality":1,"inner":false,"knockout":false}',
			titleFormat:'{"color":"0x000000","font":"Arial","size":12}',
			titleAlign:'left'
		};
		
		public var dragEnable:Boolean = true;
		
		private var _okStyle:Object;
		private var _cancelStyle:Object;
		
		private var _contentTop:int = 50;
		private var _contentBottom:int = 30;
		private var _contentSide:int = 20;
		private var _buttonToBottom:int = 15;
		
		private var _titleTop:int = 8;
		private var _titleLeft:int=10;
		private var _titleAlign:String=AlignType.LEFT;
		
		private var _closeBtnRight:int = 10;
		private var _closeBtnTop:int = 0;
		
		private var _backgroundStyle:String;
		private var _closeBackGroundStyle:String;
		private var _cancelBackGroundStyle:String;
		private var _okBackGroundStyle:String;
		private var _title:String;
		
		private var _cancelLabel:String = Language.CANCEL;
		private var _okLabel:String = Language.OK;
		
		private var _background:DisplayObject;
		private var _closeBtn:Button;
		private var _okBtn:Button;
		private var _cancelBtn:Button;
		private var _titleTF:TextField;
		private var _showCancelBtn:Boolean=true;
		private var _showOkBtn:Boolean=true;
		private var _showCloseBtn:Boolean=true;
		private var _adaptive:Boolean = true;
		private var _content:DisplayObject;
		private var _titleFormat:String;
		private var _titleFitler:String;
		
		private var _dragRect:Rectangle;
		
		public function Frame()
		{
			super();
			focusRect = false;
		}
		
		override protected function initEvents():void
		{
			super.initEvents();
			addEventListener(FrameEvent.FRAMEEVENT,onClose,false,-1);
			addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			stopDrag();
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			if(dragEnable&&event.target==_background)
			{
				if(_background.scale9Grid!=null&&event.localY < _background.scale9Grid.y){
					startDrag();
				}else if(_dragRect&&_dragRect.contains(event.localX,event.localX)){
					startDrag();
				}
			}
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			if(_cancelBtn)_cancelBtn.removeEventListener(MouseEvent.CLICK,onBtnClick);
			if(_okBtn)_okBtn.removeEventListener(MouseEvent.CLICK,onBtnClick);
			if(_closeBtn)_closeBtn.removeEventListener(MouseEvent.CLICK,onBtnClick);
			removeEventListener(Event.ADDED_TO_STAGE,onAddToStage);
			removeEventListener(FrameEvent.FRAMEEVENT,onClose);
			removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		protected function onAddToStage(event:Event):void
		{
			stage.focus = this;
			addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.ESCAPE:
					dispatchEvent(new FrameEvent(FrameEvent.FRAMEEVENT,FrameEvent.CLOSE));
					break;
				case Keyboard.ENTER:
					dispatchEvent(new FrameEvent(FrameEvent.FRAMEEVENT,FrameEvent.OK));
					break;
			}
		}
		
		protected function onClose(event:FrameEvent):void
		{
			if(parent!=null)
			{
				removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
				parent.removeChild(this);
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
				initComponents();
				if(_closeBtn){_closeBtn.backGroundStyle = _closeBackGroundStyle;_closeBtn.drawNow();}
				if(_cancelBtn){_cancelBtn.backGroundStyle = _cancelBackGroundStyle;if(_cancelStyle)_cancelBtn.setStyle(_cancelStyle);_cancelBtn.drawNow();}
				if(_okBtn){_okBtn.backGroundStyle = _okBackGroundStyle;if(_okStyle)_okBtn.setStyle(_okStyle);_okBtn.drawNow();}
			}
			if(isInvalid(InvalidationType.STATE,InvalidationType.STYLE))
			{
				if(_closeBtn){_closeBtn.visible = _showCloseBtn}
				if(_cancelBtn){_cancelBtn.visible = _showCancelBtn;_cancelBtn.label = _cancelLabel;_cancelBtn.drawNow();}
				if(_okBtn){_okBtn.visible = _showOkBtn;_okBtn.label = _okLabel;_okBtn.drawNow();}
				if(_titleTF)
				{
					_titleTF.text = _title;
					if(_titleFitler!="")
					{
						try{
							var filter:Object = JSON.parse(_titleFitler);
							_titleTF.filters = [new GlowFilter(parseInt(filter.color),filter.alpha,filter.blurX,filter.blurY,filter.strength,filter.quality,filter.inner,filter.knockout)];
						}catch(e:Error)
						{
							trace("框体标题滤镜格式错误");
							_titleTF.filters=null;
						}
					}else
					{
						_titleTF.filters=null;
					}
					if(_titleFormat!="")
					{
						try{
							var format:Object = JSON.parse(_titleFormat);
							var tf:TextFormat = new TextFormat(format.font,format.size,format.color,format.bold,format.italic,format.underline,format.url,format.target,format.align,format.leftMargin,format.rightMargin,format.indent,format.leading);
							tf.letterSpacing = format.letterSpacing;tf.kerning=format.kerning;
							_titleTF.defaultTextFormat = tf;
							_titleTF.setTextFormat(tf);
						}catch(e:Error)
						{
							trace("框体标题样式格式错误");
						}
					}
				}
			}
			if(isInvalid(InvalidationType.CONTENT))
			{
				if(_content)
				{
					if(_adaptive)
					{
						width = Math.max(_content.width + _contentSide*2,getMinWidth());
						height = _content.height + _contentTop + _contentBottom;
						_content.x = _contentSide;
						_content.y = _contentTop;
					}
					addChild(_content);
				}
			}
			if(isInvalid(InvalidationType.STYLE,InvalidationType.STATE,InvalidationType.SIZE))
			{
				drawLayout();
			}
		}
		
		override public function drawLayout():void
		{
			_background.width = width;
			_background.height = height;
			if(_titleTF){
				if(_titleAlign==AlignType.LEFT)
				{
					_titleTF.x=0;
				}else
				{
					_titleTF.x=(width-_titleTF.textWidth)*.5;
				}
				_titleTF.x += _titleLeft;
				_titleTF.y = _titleTop;
			}
			if(_showCloseBtn){_closeBtn.x = _background.width - _closeBtn.width - _closeBtnRight;_closeBtn.y=_closeBtnTop;}
			if(_cancelBtn)
			{
				if(_showOkBtn)
				{
					_cancelBtn.x = _background.width*.5+(_background.width*.5-_cancelBtn.width)*.5;
				}else
				{
					_cancelBtn.x = (_background.width-_cancelBtn.width)*.5;
				}
				_cancelBtn.y = _background.height - _cancelBtn.height - _buttonToBottom;
				_cancelBtn.visible = _showCancelBtn;
			}
			if(_okBtn)
			{
				if(_showCancelBtn)
				{
					_okBtn.x = (_background.width*.5-_okBtn.width)*.5;
				}else
				{
					_okBtn.x = (_background.width-_okBtn.width)*.5;
				}
				_okBtn.y = _background.height - _okBtn.height - _buttonToBottom;
				_okBtn.visible = _showOkBtn;
			}
		}
		
		private function initComponents():void
		{
			if(_showCancelBtn){if(_cancelBtn == null){_cancelBtn = new Button();_cancelBtn.label = "";addChild(_cancelBtn);_cancelBtn.addEventListener(MouseEvent.CLICK,onBtnClick);}}
			if(_showOkBtn){if(_okBtn == null){_okBtn = new Button();_okBtn.label = "";addChild(_okBtn);_okBtn.addEventListener(MouseEvent.CLICK,onBtnClick);}}
			if(_showCloseBtn){if(_closeBtn == null){_closeBtn = new Button();_closeBtn.label = "";addChild(_closeBtn);_closeBtn.addEventListener(MouseEvent.CLICK,onBtnClick);}}
			if(_title){if(_titleTF == null){_titleTF = new TextField();_titleTF.multiline = _titleTF.selectable = _titleTF.mouseEnabled = false;addChild(_titleTF);}}
			if(_background && contains(_background)){removeChild(_background)}
			_background = getDisplayObjectInstance(_backgroundStyle);
			addChildAt(_background,0);
		}
		
		protected function onBtnClick(event:MouseEvent):void
		{
			switch(event.currentTarget)
			{
				case _closeBtn:
					dispatchEvent(new FrameEvent(FrameEvent.FRAMEEVENT,FrameEvent.CLOSE));
					break;
				case _cancelBtn:
					dispatchEvent(new FrameEvent(FrameEvent.FRAMEEVENT,FrameEvent.CANCEL));
					break;
				case _okBtn:
					dispatchEvent(new FrameEvent(FrameEvent.FRAMEEVENT,FrameEvent.OK));
					break;
			}
		}
		[Inspectable(type="String",defaultValue="FrameSkin")]
		public function set backgroundStyle(value:String):void
		{
			if(_backgroundStyle == value)return;
			_backgroundStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		[Inspectable(type="String",defaultValue="CloseButtonSkin")]
		public function set closeBackGroundStyle(value:String):void
		{
			if(_closeBackGroundStyle == value)return;
			_closeBackGroundStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		[Inspectable(type="String",defaultValue="ButtonDefaultSkin")]
		public function set okBackGroundStyle(value:String):void
		{
			if(_okBackGroundStyle == value)return;
			_okBackGroundStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		[Inspectable(type="String",defaultValue="ButtonDefaultSkin")]
		public function set cancelBackGroundStyle(value:String):void
		{
			if(_cancelBackGroundStyle == value)return;
			_cancelBackGroundStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		[Inspectable(type="Boolean",defaultValue=true)]
		public function set showCancelBtn(value:Boolean):void
		{
			if(_showCancelBtn == value)return;
			_showCancelBtn = value;
			invalidate(InvalidationType.STYLE);
		}
		[Inspectable(type="Boolean",defaultValue=true)]
		public function set showOkBtn(value:Boolean):void
		{
			if(_showOkBtn == value)return;
			_showOkBtn = value;
			invalidate(InvalidationType.STYLE);
		}
		[Inspectable(type="Boolean",defaultValue=true)]
		public function set showCloseBtn(value:Boolean):void
		{
			if(_showCloseBtn == value)return;
			_showCloseBtn = value;
			invalidate(InvalidationType.STYLE);
		}
		[Inspectable(type="String")]
		public function set cancelLabel(value:String):void
		{
			if(_cancelLabel == value)return;
			_cancelLabel = value;
			invalidate(InvalidationType.STATE);
		}
		
		[Inspectable(type="String")]
		public function set okLabel(value:String):void
		{
			if(_okLabel == value)return;
			_okLabel = value;
			invalidate(InvalidationType.STATE);
		}
		[Inspectable(type="String",defaultValue="")]
		public function set title(value:String):void
		{
			if(_title == value)return;
			_title = value;
			invalidate(InvalidationType.STYLE);
		}
		
		public function setContent(content:DisplayObject,adaptive:Boolean = true):void
		{
			_content = content;
			_adaptive = adaptive;
			invalidate(InvalidationType.CONTENT);
		}
		
		private function getMinWidth():int
		{
			var result:int = 20;
			if(_titleTF)result+=_titleTF.textWidth;
			if(_okBtn)result+=_okBtn.width;
			if(_cancelBtn)result+=_cancelBtn.width;
			return result;
		}
		
		override public function dispose():void
		{
			if(_background && contains(_background))removeChild(_background);_background = null;
			if(_closeBtn)_closeBtn.dispose();_closeBtn = null;
			if(_okBtn)_okBtn.dispose();_okBtn = null;
			if(_cancelBtn)_cancelBtn.dispose();_cancelBtn = null;
			if(_titleTF&&contains(_titleTF))removeChild(_titleTF);_titleTF = null;
			if(_content&&contains(_content))removeChild(_content);_content = null;
			super.dispose();
		}
		[Inspectable(type="Number",defaultValue=50)]	
		public function set contentTop(value:int):void
		{
			_contentTop = value;
		}
		[Inspectable(type="Number",defaultValue=30)]	
		public function set contentBottom(value:int):void
		{
			_contentBottom = value;
		}
		[Inspectable(type="Number",defaultValue=20)]		
		public function set contentSide(value:int):void
		{
			_contentSide = value;
		}
		
		[Inspectable(type="String",name="标题滤镜",defaultValue='{"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":5,"quality":1,"inner":false,"knockout":false}')]
		public function set titleFilter(value:String):void
		{
			_titleFitler = value;
			invalidate(InvalidationType.STATE);
		}
		
		[Inspectable(type="String",name="标题样式",defaultValue='{"color":"0x000000","font":"Arial","size":12}')]
		public function set titleFormat(value:String):void
		{
			_titleFormat = value;
			invalidate(InvalidationType.STATE);
		}

		/**
		 *	底部按钮距离底部的距离 
		 */
		[Inspectable(type="Number",defaultValue=15)]	
		public function set buttonToBottom(value:int):void
		{
			_buttonToBottom = value;
		}
		
		public function get titleAlign():String
		{
			return _titleAlign;
		}
		
		[Inspectable(defaultValue="left", type="list", enumeration="left,center,right")]
		public function set titleAlign(value:String):void
		{
			_titleAlign = value;
			invalidate(InvalidationType.STATE);
		}
		
		/**
		 * 标题距离框体顶部的距离
		 * @return 
		 * 
		 */
		public function get titleTop():int
		{
			return _titleTop;
		}

		[Inspectable(type="Number",defaultValue=8)]	
		public function set titleTop(value:int):void
		{
			_titleTop = value;
			invalidate(InvalidationType.STATE);
		}	
		
		/**
		 * 标题横向偏移量
		 * @return 
		 * 
		 */
		public function get titleLeft():int
		{
			return _titleLeft;
		}
	
		[Inspectable(type="Number",defaultValue=10)]	
		public function set titleLeft(value:int):void
		{
			_titleLeft = value;
			invalidate(InvalidationType.STATE);
		}

		public function set okStyle(obj:Object):void
		{
			_okStyle = obj;
			invalidate(InvalidationType.STYLE);
		}
		
		public function set cancelStyle(obj:Object):void
		{
			_cancelStyle = obj;
			invalidate(InvalidationType.STYLE);
		}

		public function get closeBtnRight():int
		{
			return _closeBtnRight;
		}

		public function set closeBtnRight(value:int):void
		{
			_closeBtnRight = value;
			invalidate(InvalidationType.SIZE);
		}

		public function get closeBtnTop():int
		{
			return _closeBtnTop;
		}

		public function set closeBtnTop(value:int):void
		{
			_closeBtnTop = value;
			invalidate(InvalidationType.SIZE);
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

		public function get background():DisplayObject
		{
			return _background;
		}

		public function get dragRect():Rectangle
		{
			return _dragRect;
		}

		public function set dragRect(value:Rectangle):void
		{
			_dragRect = value;
		}


	}
}