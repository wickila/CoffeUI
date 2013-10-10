package coffe.controls
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import coffe.core.AlignType;
	import coffe.core.InvalidationType;
	import coffe.core.UIComponent;
	import coffe.events.ComponentEvent;

	/**
	 *	所有按钮的基类.拥有三个鼠标状态:up(正常状态与鼠标弹起),over(鼠标划过),down(鼠标按下).
	 * 	<br>可设置样式属性:
	 * 	<table>
	 * 	<tr><td>样式名称</td><td>描述</td><td>默认值</td></tr>
	 * 	<tr><td>label</td><td>文本标签</td><td>"label"</td></tr>
	 * 	<tr><td>textColor</td><td>文本标签颜色</td><td>0</td></tr>
	 * 	<tr><td>labelAlign</td><td>文本标签对齐方式</td><td>"center"</td></tr>
	 * 	<tr><td>labelGap</td><td>文本标签水平偏移</td><td>10</td></tr>
	 * 	<tr><td>labelTopGap</td><td>文本标签垂直偏移</td><td>-2</td></tr>
	 * 	</table>
	 * 
	 */
	public class BaseButton extends UIComponent
	{
		/**
		 *	组件的默认样式,每个组件都拥有自己单独的 DEFAULT_STYLE,并且在组件初始化的时候,会将DEFAULT_STYLE的样式信息赋值给组件.
		 * 	<br>此默认样式信息是全局样式信息.所以可以在程序初始化的时候,设置组件的全局默认样式信息.
		 * 	<br>默认为空
		 * 	@see coffe.core.UIComponent.initDefaultStyle()
		 * 	@see coffe.core.UIComponent.setStyle()
		 * 	@see coffe.core.UIComponent.combinStyle()
		 * 	@example
		 * 	ObjectUtils.combineObject(ComboBox.DEFAULT_STYLE,{"listStyle":{"cellRender":"com.dragonlance.view.ComboxCellRender","backgroundStyle":"dl.asset.core.ComboxListBgAsset"},"buttonStyle":{"labelFormat":'{"color":"0xffffff","font":"宋体","size":12}',"labelFilter":""}});
		 */
		public static var DEFAULT_STYLE:Object = {
		};
		
		protected var _labelTF:TextField;
		protected var _labelFitler:String;
		protected var _labelFormat:String;
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
		protected var _labelTopGap:int = -2;
		protected var _clickFunction:Function;
		protected var _clickFunctionArgs:Object;
		
		/**
		 *	构造函数.创建实例后,默认设置buttonMode为true 
		 * 
		 */
		public function BaseButton()
		{
			super();
			super.buttonMode = _buttonMode;
			pressTimer = new Timer(_repeatTime,0);
			pressTimer.addEventListener(TimerEvent.TIMER,onPressTimer,false,0,true);
		}
		
		override protected function initDefaultStyle():void
		{
			setStyle(DEFAULT_STYLE);
		}
		
		override protected function initEvents():void
		{
			super.initEvents();
			addEventListener(MouseEvent.ROLL_OVER,mouseEventHandler,false,0,true);
			addEventListener(MouseEvent.MOUSE_DOWN,mouseEventHandler,false,0,true);
			addEventListener(MouseEvent.MOUSE_UP,mouseEventHandler,false,0,true);
			addEventListener(MouseEvent.ROLL_OUT,mouseEventHandler,false,0,true);
			addEventListener(MouseEvent.CLICK, onClickHandler, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
		}
		
		override protected function removeEvents():void
		{
			super.removeEvents();
			removeEventListener(MouseEvent.ROLL_OVER,mouseEventHandler);
			removeEventListener(MouseEvent.MOUSE_DOWN,mouseEventHandler);
			removeEventListener(MouseEvent.MOUSE_UP,mouseEventHandler);
			removeEventListener(MouseEvent.ROLL_OUT,mouseEventHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			pressTimer.removeEventListener(TimerEvent.TIMER,onPressTimer,false);
			if(stage!=null)
				stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			removeEventListener(MouseEvent.CLICK, onClickHandler);
		}
		
		protected function onClickHandler(event:MouseEvent):void
		{
			if(clickFunction != null)
			{
				clickFunction(clickFunctionArgs);
			}
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
		
		/**
		 *	设置鼠标状态 
		 * @param state 需要设置的鼠标状态.可选值为"up","down","over"
		 * 
		 */
		public function setMouseState(state:String):void {
			if (_mouseState == state) { return; }
			_mouseState = state;
			invalidate(InvalidationType.STATE);
		}
		
		private var _stageHasListen:Boolean=false;//舞台是否监听了鼠标弹起事件
		private function buttonUp():void
		{
			if(_displacement)
			{
				x--;y--;
				stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
				_stageHasListen = false;
			}
		}
		
		private function buttonDown():void
		{
			if(_displacement)
			{
				x++;y++;
				stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
				_stageHasListen = true;
			}
		}
		
		protected function onStageMouseUp(event:MouseEvent):void
		{
			buttonUp();
		}
		
		protected function onRemoveFromStage(event:Event):void
		{
			if(_stageHasListen){
				buttonUp();
			}
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
		
		/**
		 *	按钮标签,默认为"label" 
		 * @param value 需要设置的按钮标签
		 * 
		 */
		public function set label(value:String):void
		{
			_label = value;
			invalidate(InvalidationType.LABEL);
		}
		/**
		 * 按钮文本颜色.(如果同时设置了标签的textformat,则此属性会覆盖textformat的颜色值)
		 * @param value 按钮文本颜色
		 */
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
		/**
		 *	标签水平偏移距离 
		 */
		[Inspectable(defaultValue=10, name="标签间隔", type="Number")]
		public function set labelGap(value:int):void
		{
			_labelGap = value;
			invalidate(InvalidationType.LABEL);
		}
		/**
		 *	标签垂直偏移距离.(按钮标签垂直居中后,将加上垂直偏移距离以校正标签垂直位置) 
		 */
		[Inspectable(defaultValue=-2, name="标签顶部间隔", type="Number")]
		public function set labelTopGap(value:int):void
		{
			_labelTopGap = value;
			invalidate(InvalidationType.LABEL);
		}
		
		/**
		 *	点击回调函数,通常用于按钮点击发出声音等按钮同意行为,可在DEFAULT_STYLE里面全局设置统一的按钮行为 
		 * @return 按钮点击回调函数
		 * @see coffe.controls.BaseButton.DEFAULT_STYLE
		 * @see coffe.controls.BaseButton.clickFunctionArgs
		 */
		public function get clickFunction():Function
		{
			return _clickFunction;
		}
		
		public function set clickFunction(value:Function):void
		{
			_clickFunction = value;
		}
		
		/**
		 *	点击回调函数的参数. 可在DEFAULT_STYLE里面全局设置统一的按钮行为 
		 * @return 点击回调函数的参数
		 * @see coffe.controls.BaseButton.DEFAULT_STYLE
		 * @see coffe.controls.BaseButton.clickFunction
		 * 
		 */
		public function get clickFunctionArgs():Object
		{
			return _clickFunctionArgs;
		}
		
		public function set clickFunctionArgs(value:Object):void
		{
			_clickFunctionArgs = value;
		}

		/**
		 *	是否重复发出ComponentEvent.BUTTON_DOWN事件(用于滚动条的上下按钮等)
		 * @return 是否重复发出ComponentEvent.BUTTON_DOWN事件 
		 * 
		 */
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
			_clickFunction = null;
			_clickFunctionArgs=null;
			disposeObject(_labelTF);
			_labelTF = null;
		}
	}
}