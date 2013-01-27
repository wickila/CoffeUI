package coffe.controls
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import coffe.core.AlignType;
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;
	import coffe.events.ComponentEvent;

	public class BaseButton extends UIComponent
	{
		protected var _labelTF:TextField;
		protected var _label:String = "Label";
		protected var _textColor:uint=0;
		protected var _displacement:Boolean = true;
		protected var _buttonMode:Boolean = true;
		protected var _autoRepeat:Boolean = false;
		protected var _mouseState:String="up";
		protected var pressTimer:Timer;
		protected var _repeatTime:int = 50;
		protected var _selected:Boolean;
		protected var _labelAlign:String = AlignType.CENTER;
		protected var _labelGap:int = 10;
		
		public function BaseButton()
		{
			super();
			super.buttonMode = _buttonMode;
			pressTimer = new Timer(_repeatTime,0);
			pressTimer.addEventListener(TimerEvent.TIMER,onPressTimer,false,0,true);
		}
		
		override protected function initEvents():void
		{
			super.initEvents();
			addEventListener(MouseEvent.ROLL_OVER,mouseEventHandler,false,0,true);
			addEventListener(MouseEvent.MOUSE_DOWN,mouseEventHandler,false,0,true);
			addEventListener(MouseEvent.MOUSE_UP,mouseEventHandler,false,0,true);
			addEventListener(MouseEvent.ROLL_OUT,mouseEventHandler,false,0,true);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeEventListener(MouseEvent.ROLL_OVER,mouseEventHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN,mouseEventHandler);
			removeEventListener(MouseEvent.MOUSE_UP,mouseEventHandler);
			removeEventListener(MouseEvent.ROLL_OUT,mouseEventHandler);
		}
		
		protected function mouseEventHandler(event:MouseEvent):void {
			if(event.type == MouseEvent.MOUSE_DOWN) {
				setMouseState("down");
				startPress();
				buttonDown();
			} else if (event.type == MouseEvent.ROLL_OVER || event.type == MouseEvent.MOUSE_UP) {
				setMouseState("over");
				endPress();
			} else if (event.type == MouseEvent.ROLL_OUT){
				setMouseState("up");
				endPress();
			}
		}
		
		public function setMouseState(state:String):void {
			if (_mouseState == state) { return; }
			_mouseState = state;
			invalidate(InvalidationType.STATE);
		}
		
		private function buttonUp():void
		{
			if(_displacement)
			{
				x--;y--;
				stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			}
		}
		
		private function buttonDown():void
		{
			if(_displacement)
			{
				x++;y++;
				stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			}
		}
		
		protected function onStageMouseUp(event:MouseEvent):void
		{
			buttonUp();
		}
		
		protected function startPress():void {
			if (_autoRepeat) {
				pressTimer.delay = _repeatTime;
				pressTimer.start();
			}
			dispatchEvent(new ComponentEvent(ComponentEvent.BUTTON_DOWN, true));
		}
		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function onPressTimer(event:TimerEvent):void {
			if (!_autoRepeat) { endPress(); return; }
			if (pressTimer.currentCount == 1) { pressTimer.delay = _repeatTime; }
			dispatchEvent(new ComponentEvent(ComponentEvent.BUTTON_DOWN, true));
		}
		
		/**
		 * @private (protected)
		 *
		 * @langversion 3.0
		 * @playerversion Flash 9.0.28.0
		 */
		protected function endPress():void {
			pressTimer.reset();
		}
		
		public function set label(value:String):void
		{
			_label = value;
			invalidate(InvalidationType.LABEL);
		}
		
		[Inspectable(type="Color",name="文本颜色",defaultValue=0)]
		public function set textColor(value:uint):void
		{
			_textColor = value;
			if(_labelTF)_labelTF.textColor = value;
		}
		
		[Inspectable(type="Boolean",name="动态位移",defaultValue=true)]
		public function set displacement(value:Boolean):void
		{
			_displacement = value;
		}
		[Inspectable(type="Boolean",name="手形鼠标",defaultValue=true)]
		override public function set buttonMode(value:Boolean):void
		{
			_buttonMode = value;
			super.buttonMode = _buttonMode && enable;
		}
		
		[Inspectable(type="Boolean",name="是否可用",defaultValue=true)]
		override public function set enable(value:Boolean):void
		{
			super.enable = value;
			super.buttonMode = _buttonMode && enable;
		}
		[Inspectable(defaultValue=10, name="标签间隔", type="Number")]
		public function set labelGap(value:int):void
		{
			_labelGap = value;
			invalidate(InvalidationType.LABEL);
		}

		public function get autoRepeat():Boolean
		{
			return _autoRepeat;
		}

		public function set autoRepeat(value:Boolean):void
		{
			_autoRepeat = value;
		}
		
		override public function dispose():void
		{
			super.dispose();
			if(_labelTF && contains(_labelTF))removeChild(_labelTF);
			_labelTF = null;
		}
	}
}