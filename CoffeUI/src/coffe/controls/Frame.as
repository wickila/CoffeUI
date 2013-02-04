package coffe.controls
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
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
		public static const DEFAULT_STYLE:Object = {
			closeStyle:"CloseButtonSkin",
			backgroundStyle:"FrameSkin",
			okStyle:"ButtonDefaultSkin",
			cancelStyle:"ButtonDefaultSkin"
		};
		
		public var dragEnable:Boolean = true;
		
		private var _contentTop:int = 50;
		private var _contentBottom:int = 30;
		private var _contentSide:int = 20;
		private var _buttonToBottom:int = 10;
		
		private var _backgroundStyle:String;
		private var _closeStyle:String;
		private var _cancelStyle:String;
		private var _okStyle:String;
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
			if(dragEnable&&event.target==_background&&_background.scale9Grid!=null&&event.localY < _background.scale9Grid.y)
			{
				startDrag();
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
				if(_closeBtn){_closeBtn.backGroundStyle = _closeStyle;_closeBtn.drawNow();}
				if(_cancelBtn){_cancelBtn.backGroundStyle = _cancelStyle;_cancelBtn.drawNow();}
				if(_okBtn){_okBtn.backGroundStyle = _okStyle;_okBtn.drawNow();}
			}
			if(isInvalid(InvalidationType.STATE,InvalidationType.STYLE))
			{
				if(_closeBtn){_closeBtn.visible = _showCloseBtn}
				if(_cancelBtn){_cancelBtn.visible = _showCancelBtn;_cancelBtn.label = _cancelLabel;_cancelBtn.drawNow();}
				if(_okBtn){_okBtn.visible = _showOkBtn;_okBtn.label = _okLabel;_okBtn.drawNow();}
				if(_titleTF)_titleTF.text = _title;
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
			if(_titleTF){_titleTF.x = 10;_titleTF.y = 8;}
			if(_showCloseBtn){_closeBtn.x = _background.width - _closeBtn.width - 10;}
			if(_cancelBtn)
			{
				if(_showOkBtn)
				{
					_cancelBtn.x = _background.width*.5+(_background.width*.5-_cancelBtn.width)*.5;
				}else
				{
					_cancelBtn.x = (_background.width-_cancelBtn.width)*.5;
				}
				_cancelBtn.y = _background.height - _cancelBtn.height - 10;
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
				_okBtn.y = _background.height - _okBtn.height - 10;
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
		public function set closeStyle(value:String):void
		{
			if(_closeStyle == value)return;
			_closeStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		[Inspectable(type="String",defaultValue="ButtonDefaultSkin")]
		public function set okStyle(value:String):void
		{
			if(_okStyle == value)return;
			_okStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		[Inspectable(type="String",defaultValue="ButtonDefaultSkin")]
		public function set cancelStyle(value:String):void
		{
			if(_cancelStyle == value)return;
			_cancelStyle = value;
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

		/**
		 *	底部按钮距离底部的距离 
		 */
		[Inspectable(type="Number",defaultValue=10)]	
		public function set buttonToBottom(value:int):void
		{
			_buttonToBottom = value;
		}


	}
}