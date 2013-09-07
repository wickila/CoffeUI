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

	[Event(name="frameEvent", type="coffe.events.FrameEvent")]
	
	/**
	 *	弹出框组件.包含一个关闭按钮,确定按钮,取消按钮.支持键盘事件.使用的时候可以把自定义的显示对象添加进弹出框内显示
	 * 	<br>可设置样式属性
	 * <table width="100%">
	 * <tr><td>样式名称</td><td>描述</td><td>默认值</td></tr>
	 * <tr><td>closeBackGroundStyle</td><td>关闭按钮背景样式</td><td>CloseButtonSkin</td></tr>
	 * <tr><td>okBackGroundStyle</td><td>确定按钮背景样式</td><td>ButtonDefaultSkin</td></tr>
	 * <tr><td>cancelBackGroundStyle</td><td>取消按钮背景样式</td><td>ButtonDefaultSkin</td></tr>
	 * <tr><td>backgroundStyle</td><td>背景样式</td><td>FrameSkin</td></tr>
	 * <tr><td>okStyle</td><td>确定按钮样式</td><td>{"backGroundStyle":"ButtonDefaultSkin",<br>"labelFormat":'{"color":"0xFDE4AE","font":"Arial",<br>"size":14,"kerning":true,"letterSpacing":5}',<br>"labelFilter":'{"color":"0x522A07","alpha":1,<br>"blurX":4,"blurY":4,"strength":10,"quality":1,<br>"inner":false,"knockout":false}'}</td></tr>
	 * <tr><td>okLabel</td><td>确定按钮标签</td><td>Language.OK</td></tr>
	 * <tr><td>cancelStyle</td><td>取消按钮样式</td><td>{"backGroundStyle":"ButtonDefaultSkin",<br>"labelFormat":'{"color":"0xFDE4AE","font":"Arial",<br>"size":14,"kerning":true,"letterSpacing":5}',<br>"labelFilter":'{"color":"0x522A07","alpha":1,<br>"blurX":4,"blurY":4,"strength":10,"quality":1,<br>"inner":false,"knockout":false}'}</td></tr>
	 * <tr><td>cancelLable</td><td>取消按钮标签</td><td>Language.CANCEL</td></tr>
	 * <tr><td>closeBtnRight</td><td>关闭按钮距离弹出框最右边的距离</td><td>13</td></tr>
	 * <tr><td>closeBtnTop</td><td>关闭按钮距离弹出框最顶端的距离</td><td>-1</td></tr>
	 * <tr><td>titleFilter</td><td>标题发光滤镜</td><td>'{"color":"0x482B15","alpha":1,"blurX":4,<br>"blurY":4,"strength":10,"quality":1,<br>"inner":false,"knockout":false}'</td></tr>
	 * <tr><td>titleFormat</td><td>标题文本样式</td><td>'{"color":"0xFFE9B3","font":"Arial","size":14,<br>"kerning":true,"letterSpacing":5,"bold":true,<br>"align":"center"}'</td></tr>
	 * <tr><td>titleAlign</td><td>标题水平对齐方式</td><td>"center"</td></tr>
	 * <tr><td>buttonToBottom</td><td>确定取消按钮距离底部的距离</td><td>15</td></tr>
	 * <tr><td>titleTop</td><td>标题距离顶部的按钮</td><td>5</td></tr>
	 * <tr><td>titleLeft</td><td>标题距离左边的按钮</td><td>10</td></tr>
	 * </table>
	 * @see coffe.events.FrameEvent
	 */	
	public class Frame extends UIComponent
	{
		/**
		 *	组件的全局默认样式.每个组件都拥有自己单独的 DEFAULT_STYLE,并且在组件初始化的时候,会将DEFAULT_STYLE的样式信息赋值给组件.
		 * 	<br>此默认样式信息是全局样式信息.所以可以在程序初始化的时候,设置组件的全局默认样式信息.
		 * 	<br>默认弹出框样式:
		 * 	<table width="100%">
		 * <tr><td>样式名称</td><td>描述</td><td>默认值</td></tr>
		 * <tr><td>closeBackGroundStyle</td><td>关闭按钮背景样式</td><td>CloseButtonSkin</td></tr>
		 * <tr><td>backgroundStyle</td><td>背景样式</td><td>FrameSkin</td></tr>
		 * <tr><td>okStyle</td><td>确定按钮样式</td><td>{"backGroundStyle":"ButtonDefaultSkin",<br>"labelFormat":'{"color":"0xFDE4AE","font":"Arial",<br>"size":14,"kerning":true,"letterSpacing":5}',<br>"labelFilter":'{"color":"0x522A07","alpha":1,<br>"blurX":4,"blurY":4,"strength":10,"quality":1,<br>"inner":false,"knockout":false}'}</td></tr>
		 * <tr><td>cancelStyle</td><td>取消按钮样式</td><td>{"backGroundStyle":"ButtonDefaultSkin",<br>"labelFormat":'{"color":"0xFDE4AE","font":"Arial",<br>"size":14,"kerning":true,"letterSpacing":5}',<br>"labelFilter":'{"color":"0x522A07","alpha":1,<br>"blurX":4,"blurY":4,"strength":10,"quality":1,<br>"inner":false,"knockout":false}'}</td></tr>
		 * <tr><td>closeBtnRight</td><td>关闭按钮距离弹出框最右边的距离</td><td>13</td></tr>
		 * <tr><td>closeBtnTop</td><td>关闭按钮距离弹出框最顶端的距离</td><td>-1</td></tr>
		 * <tr><td>titleFilter</td><td>标题发光滤镜</td><td>'{"color":"0x482B15","alpha":1,"blurX":4,<br>"blurY":4,"strength":10,"quality":1,<br>"inner":false,"knockout":false}'</td></tr>
		 * <tr><td>titleFormat</td><td>标题文本样式</td><td>'{"color":"0xFFE9B3","font":"Arial","size":14,<br>"kerning":true,"letterSpacing":5,"bold":true,<br>"align":"center"}'</td></tr>
		 * <tr><td>titleAlign</td><td>标题水平对齐方式</td><td>"center"</td></tr>
		 * </table>
		 * 	@see coffe.core.UIComponent.initDefaultStyle()
		 * 	@see coffe.core.UIComponent.setStyle()
		 * 	@see coffe.core.UIComponent.combinStyle()
		 * 	@example
		 * 	ObjectUtils.combineObject(ComboBox.DEFAULT_STYLE,{"listStyle":{"cellRender":"com.dragonlance.view.ComboxCellRender","backgroundStyle":"dl.asset.core.ComboxListBgAsset"},"buttonStyle":{"labelFormat":'{"color":"0xffffff","font":"宋体","size":12}',"labelFilter":""}});
		 */
		public static var DEFAULT_STYLE:Object = {
			closeBackGroundStyle:"CloseButtonSkin",
			backgroundStyle:"FrameSkin",
			okStyle:{"backGroundStyle":"ButtonDefaultSkin","labelFormat":'{"color":"0xFDE4AE","font":"Arial","size":14,"kerning":true,"letterSpacing":5}',"labelFilter":'{"color":"0x522A07","alpha":1,"blurX":4,"blurY":4,"strength":10,"quality":1,"inner":false,"knockout":false}'},
			cancelStyle:{"backGroundStyle":"ButtonDefaultSkin","labelFormat":'{"color":"0xFDE4AE","font":"Arial","size":14,"kerning":true,"letterSpacing":5}',"labelFilter":'{"color":"0x522A07","alpha":1,"blurX":4,"blurY":4,"strength":10,"quality":1,"inner":false,"knockout":false}'},
			closeBtnRight:13,
			closeBtnTop:-1,
			titleFilter:'{"color":"0x482B15","alpha":1,"blurX":4,"blurY":4,"strength":10,"quality":1,"inner":false,"knockout":false}',
			titleFormat:'{"color":"0xFFE9B3","font":"Arial","size":14,"kerning":true,"letterSpacing":5,"bold":true,"align":"center"}',
			titleAlign:'center'
		};
		/**
		 *	是否可以按住弹出框标题栏拖拽.默认为true.
		 * 	只有九宫格的背景可以拖拽.如果普通的MovieClip背景需要可以拖拽.请主动设置dragRect属性 
		 *  @see coffe.controls.Frame.dragRect
		 * 	@see flash.display.DisplayObject.scale9Grid
		 */
		public var dragEnable:Boolean = true;
		
		private var _okStyle:Object;
		private var _cancelStyle:Object;
		
		private var _contentTop:int = 50;
		private var _contentBottom:int = 30;
		private var _contentSide:int = 20;
		private var _buttonToBottom:int = 15;
		
		private var _titleTop:int = 5;
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
		private var _soundPlayFun:Function;
		private var _openSoundId:String;
		private var _closeSoundId:String;
		
		private var _dragRect:Rectangle;
		
		/**
		 *	是否在处理关闭事件时自动销毁.默认为true 
		 */
		public var autoDispose:Boolean=true;
		/**
		 *	创建一个弹出框 
		 * 
		 */		
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
		
		/**
		 *	添加到舞台时.舞台焦点设置到弹出框上.并且添加键盘事件. 
		 * @param event 添加到舞台事件
		 * 
		 */
		protected function onAddToStage(event:Event):void
		{
			stage.focus = this;
			addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
		}
		
		/**
		 *	监听到键盘的escape与enter按下时,发出弹出框事件. 
		 * @param event 键盘按下事件
		 * @see coffe.events.FrameEvent
		 */
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
		
		/**
		 *	监听到弹出框事件后的处理函数. 可覆写该方法,根据事件的类型来处理相应的事务.
		 * @param event 弹出框事件
		 * @see coffe.events.FrameEvent
		 */
		protected function onClose(event:FrameEvent):void
		{
			if(autoDispose)
			{
				dispose();
			}else if(parent!=null)
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
				_titleTF.width = _titleTF.textWidth+20;
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
			if(_background && contains(_background)){removeChild(_background)}
			_background = getDisplayObjectInstance(_backgroundStyle);
			addChildAt(_background,0);
			if(_title){if(_titleTF == null){_titleTF = new TextField();_titleTF.multiline = _titleTF.selectable = _titleTF.mouseEnabled = false;_titleTF.width=width;_titleTF.height=30;addChild(_titleTF);}}
		}
		
		/**
		 *	关闭按钮,确定按钮,取消按钮的鼠标点击事件处理函数 
		 * @param event
		 * @see coffe.events.FrameEvent
		 */
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
		/**
		 *	背景样式.一般为九宫格显示对象的类名. 
		 * 默认值:FrameSkin
		 * @param value 背景样式
		 * 
		 */		
		[Inspectable(type="String",defaultValue="FrameSkin")]
		public function set backgroundStyle(value:String):void
		{
			if(_backgroundStyle == value)return;
			_backgroundStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	 关闭按钮背景样式.
		 * 默认值:CloseButtonSkin
		 * @param value 关闭按钮背景样式.
		 * @see coffe.controls.Button.backGroundStyle
		 */		
		[Inspectable(type="String",defaultValue="CloseButtonSkin")]
		public function set closeBackGroundStyle(value:String):void
		{
			if(_closeBackGroundStyle == value)return;
			_closeBackGroundStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	确定按钮背景样式
		 * 默认值: ButtonDefaultSkin
		 * @param value 确定按钮背景样式
		 * @see coffe.controls.Button.backGroundStyle
		 */		
		[Inspectable(type="String",defaultValue="ButtonDefaultSkin")]
		public function set okBackGroundStyle(value:String):void
		{
			if(_okBackGroundStyle == value)return;
			_okBackGroundStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	取消按钮背景样式
		 * 默认值: ButtonDefaultSkin
		 * @param value 取消按钮背景样式
		 * @see coffe.controls.Button.backGroundStyle
		 */	
		[Inspectable(type="String",defaultValue="ButtonDefaultSkin")]
		public function set cancelBackGroundStyle(value:String):void
		{
			if(_cancelBackGroundStyle == value)return;
			_cancelBackGroundStyle = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	是否显示取消按钮.默认为true. 
		 * @param value 是否显示取消按钮.
		 * 
		 */		
		[Inspectable(type="Boolean",defaultValue=true)]
		public function set showCancelBtn(value:Boolean):void
		{
			if(_showCancelBtn == value)return;
			_showCancelBtn = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	是否显示确定按钮.默认为true. 
		 * @param value 是否显示确定按钮.
		 * 
		 */		
		[Inspectable(type="Boolean",defaultValue=true)]
		public function set showOkBtn(value:Boolean):void
		{
			if(_showOkBtn == value)return;
			_showOkBtn = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	是否显示关闭按钮.默认为true. 
		 * @param value 是否显示关闭按钮.
		 * 
		 */		
		[Inspectable(type="Boolean",defaultValue=true)]
		public function set showCloseBtn(value:Boolean):void
		{
			if(_showCloseBtn == value)return;
			_showCloseBtn = value;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	取消按钮标签值.默认为Language.CANEL 
		 * @param value 取消按钮标签值.
		 * @see coffe.data.Language
		 */		
		[Inspectable(type="String")]
		public function set cancelLabel(value:String):void
		{
			if(_cancelLabel == value)return;
			_cancelLabel = value;
			invalidate(InvalidationType.STATE);
		}
		/**
		 *	确定按钮标签值.默认为Language.OK 
		 * @param value 确定按钮标签值
		 * @see coffe.data.Language
		 */		
		[Inspectable(type="String")]
		public function set okLabel(value:String):void
		{
			if(_okLabel == value)return;
			_okLabel = value;
			invalidate(InvalidationType.STATE);
		}
		/**
		 *	弹出框标题.默认为"" 
		 * @param value 弹出框标题
		 * 
		 */		
		[Inspectable(type="String",defaultValue="")]
		public function set title(value:String):void
		{
			if(_title == value)return;
			_title = value;
			invalidate(InvalidationType.STYLE);
		}
		
		/**
		 *	把自定义的显示对象添加到弹出框内显示. 如果adaptive为true,则弹出框根据自适应属性自动适应显示内容的大小.如果adaptive为false,则自适应的属性如contentTop,contentBottom,contentSide等会失效.
		 * @param content 需要显示的显示对象
		 * @param adaptive 弹出框是否自适应显示内容.是否需要弹出框自动适应显示内容的尺寸.默认为true
		 * 
		 */
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
			disposeObject(_background);_background = null;
			disposeObject(_closeBtn);_closeBtn = null;
			disposeObject(_okBtn);_okBtn = null;
			disposeObject(_cancelBtn);_cancelBtn = null;
			disposeObject(_titleTF);_titleTF = null;
			disposeObject(_content);_content = null;
			super.dispose();
		}
		/**
		 *	显示内容距离弹出框顶部的距离.
		 * @param value 显示内容距离弹出框顶部的距离.默认为50 
		 * @see coffe.controls.Frame.setContent()
		 */		
		[Inspectable(type="Number",defaultValue=50)]	
		public function set contentTop(value:int):void
		{
			_contentTop = value;
		}
		/**
		 *	显示内容距离弹出框底部的距离.
		 * @param value 显示内容距离弹出框底部的距离.默认为30 
		 * @see coffe.controls.Frame.setContent()
		 */		
		[Inspectable(type="Number",defaultValue=30)]	
		public function set contentBottom(value:int):void
		{
			_contentBottom = value;
		}
		/**
		 *	显示内容距离弹出框两边的距离.
		 * @param value 显示内容距离弹出框两边的距离.默认为20 
		 * @see coffe.controls.Frame.setContent()
		 */	
		[Inspectable(type="Number",defaultValue=20)]		
		public function set contentSide(value:int):void
		{
			_contentSide = value;
		}
		/**
		 *	标题发光滤镜.为一个json格式的字符串,里面可以包含GlowFilter的各种属性值
		 * 	@param value 一段json格式的标签滤镜字符串.<br>默认值: '{"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":5,"quality":1,"inner":false,"knockout":false}'
		 * 	@see flash.filters.GlowFilter
		 */		
		[Inspectable(type="String",name="标题滤镜",defaultValue='{"color":"0xffffff","alpha":1,"blurX":2,"blurY":2,"strength":5,"quality":1,"inner":false,"knockout":false}')]
		public function set titleFilter(value:String):void
		{
			_titleFitler = value;
			invalidate(InvalidationType.STATE);
		}
		/**
		 *	标题样式.为一个json格式的字符串,里面可以包含TextFormat的各种属性值
		 * 	@param value 一段json格式的文本样式字符串.<br>默认值: {"color":"0x000000","font":"Arial","size":12}
		 * 	@see flash.text.TextFormat
		 */
		[Inspectable(type="String",name="标题样式",defaultValue='{"color":"0x000000","font":"Arial","size":12}')]
		public function set titleFormat(value:String):void
		{
			_titleFormat = value;
			invalidate(InvalidationType.STATE);
		}
		/**
		 * 确定取消按钮距离弹出框底部的距离.
		 * @param value 确定取消按钮距离弹出框底部的距离.默认值:15
		 * 
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
		/**
		 *	弹出框标题水平对齐方式. 
		 * @param value 弹出框标题水平对齐方式.默认值:"center"
		 * @see coffe.core.AlignType
		 */		
		[Inspectable(defaultValue="center", type="list", enumeration="left,center,right")]
		public function set titleAlign(value:String):void
		{
			_titleAlign = value;
			invalidate(InvalidationType.STATE);
		}
		
		public function get titleTop():int
		{
			return _titleTop;
		}
		/**
		 *	标题距离弹出框顶部的距离 
		 * @param value 骠骑距离弹出顶部的距离.默认值:5;
		 * 
		 */
		[Inspectable(type="Number",defaultValue=5)]	
		public function set titleTop(value:int):void
		{
			_titleTop = value;
			invalidate(InvalidationType.STATE);
		}	
		
		public function get titleLeft():int
		{
			return _titleLeft;
		}
		/**
		 * 标题距离弹出框左边的距离.(只在标题对齐方式不为"center"的时候有效) 
		 * @param value 标题距离弹出框左边的距离.
		 * 
		 */	
		[Inspectable(type="Number",defaultValue=10)]	
		public function set titleLeft(value:int):void
		{
			_titleLeft = value;
			invalidate(InvalidationType.STATE);
		}

		/**
		 *	确定按钮的样式信息. 为一个包含按钮样式信息的Object对象
		 * @param obj 确定按钮的样式信息.
		 * @see coffe.controls.Button
		 * @see coffe.controls.Button.DEFAULT_STYLE
		 * @see coffe.core.UIComponent.setStyle()
	 	 * @see coffe.core.UIComponent.combinStyle()
		 */
		public function set okStyle(obj:Object):void
		{
			_okStyle = obj;
			invalidate(InvalidationType.STYLE);
		}
		/**
		 *	取消按钮的样式信息. 为一个包含按钮样式信息的Object对象
		 * @param obj 确定按钮的样式信息.
		 * @see coffe.controls.Button
		 * @see coffe.controls.Button.DEFAULT_STYLE
		 * @see coffe.core.UIComponent.setStyle()
		 * @see coffe.core.UIComponent.combinStyle()
		 */
		public function set cancelStyle(obj:Object):void
		{
			_cancelStyle = obj;
			invalidate(InvalidationType.STYLE);
		}

		public function get closeBtnRight():int
		{
			return _closeBtnRight;
		}
		/**
		 *	关闭按钮距离弹出框右边的距离. 
		 * @param value 关闭按钮距离弹出框右边的距离.默认值10
		 * 
		 */
		[Inspectable(type="Number",defaultValue=10)]	
		public function set closeBtnRight(value:int):void
		{
			_closeBtnRight = value;
			invalidate(InvalidationType.SIZE);
		}

		public function get closeBtnTop():int
		{
			return _closeBtnTop;
		}
		/**
		 *	关闭按钮距离弹出框顶部的距离. 
		 * @param value 关闭按钮距离弹出框顶部的距离.默认值:0
		 * 
		 */
		[Inspectable(type="Number",defaultValue=0)]	
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
		/**
		 * 弹出框的背景.
		 * @return 弹出框的背景.为一个显示对象.
		 * 
		 */
		public function get background():DisplayObject
		{
			return _background;
		}

		public function get dragRect():Rectangle
		{
			return _dragRect;
		}
		/**
		 *	弹出框的拖拽矩形.如果背景不是一个九宫格对象.可以通过设置此值来响应鼠标的拖拽.当鼠标按下时,如果鼠标在此矩形范围内并且dragEnable为true,则弹出框开始拖拽.
		 * @param value 弹出框的拖拽矩形.
		 * @see coffe.controls.Frame.dragEnable
		 */
		public function set dragRect(value:Rectangle):void
		{
			_dragRect = value;
		}

		/**
		 *	弹出框的关闭按钮. 
		 * @return 弹出框的关闭按钮.
		 * 
		 */
		public function get closeButton():Button
		{
			return _closeBtn;
		}
		/**
		 *	弹出框的确定按钮. 
		 * @return  弹出的确定按钮.
		 * 
		 */		
		public function get okButton():Button
		{
			return _okBtn;
		}
		/**
		 *	弹出框的取消按钮. 
		 * @return 弹出框的取消按钮.
		 * 
		 */		
		public function get cancelButton():Button
		{
			return _cancelBtn;
		}
	}
}