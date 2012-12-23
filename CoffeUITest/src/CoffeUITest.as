package
{
	import coffe.controls.Alert;
	import coffe.controls.Button;
	import coffe.controls.CellRender;
	import coffe.controls.CheckBox;
	import coffe.controls.ComboBox;
	import coffe.controls.Frame;
	import coffe.controls.List;
	import coffe.controls.RadioButton;
	import coffe.controls.ScrollBar;
	import coffe.controls.ScrollPane;
	import coffe.core.AlignType;
	import coffe.data.DataProvider;
	import coffe.data.Language;
	import coffe.events.ListEvent;
	import coffe.events.ScrollEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	[SWF(width="1000",height="600")]
	public class CoffeUITest extends Sprite
	{
		public function CoffeUITest()
		{
			embedSkins();
			testButton();
			testCheckBox();
			testRadioButton();
			testScrollBar();
			testScrollPane();
			testList();
			testComboBox();
			testFrame();
			stage.stageFocusRect = false;
		}
		
		private function testButton():void
		{
			var btn:Button = new Button();
			btn.buttonMode = true;
			btn.labelAlign = AlignType.RIGHT;
			btn.label = "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww";
			addChild(btn);
			btn.addEventListener(MouseEvent.CLICK,onBtnClick);
		}
		
		protected function onBtnClick(event:MouseEvent):void
		{
			testAlert();
		}
		
		private function testCheckBox():void
		{
			var checkBox:CheckBox = new CheckBox();
			checkBox.y = 50;
			checkBox.buttonMode = true;
			checkBox.selected = false;
			addChild(checkBox);
		}
		
		private function testRadioButton():void
		{
			var radio:RadioButton = new RadioButton();
			radio.y = 100;
			addChild(radio);
			radio = new RadioButton();
			radio.y = 120;
			radio.selected = true;
			addChild(radio);
		}
		
		private function testScrollBar():void
		{
			var scrollBar:ScrollBar = new ScrollBar();
			scrollBar.x = 100;
			scrollBar.addEventListener(ScrollEvent.SCROLL,onScroll);
			addChild(scrollBar);
		}
		
		protected function onScroll(event:ScrollEvent):void
		{
			trace(event.delta);
			trace(event.position);
		}
		
		private function testScrollPane():void
		{
			var scrollBar:ScrollPane = new ScrollPane();
			scrollBar.x = 140;
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0x000099);
			sp.graphics.drawCircle(150,150,150);
			sp.graphics.endFill();
			scrollBar.addContent(sp);
			addChild(scrollBar);
			sp = new Sprite();
			sp.graphics.beginFill(0x990000);
			sp.graphics.drawCircle(150,200,150);
			sp.graphics.endFill();
			scrollBar.addContent(sp);
		}
		
		private function testList():void
		{
			var list:List = new List();
			list.x = 450;
			var data:DataProvider = new DataProvider([1,2,3,4,5,6,7,8,9,10]);
			list.data = data;
			data.addItem(11);
			list.addEventListener(ListEvent.SELECTED_DATA_CHANGE,onListChange);
			addChild(list);
		}
		
		protected function onListChange(event:ListEvent):void
		{
			var list:List = event.target as List;
			trace(list.selectedData);
		}
		
		private function testComboBox():void
		{
			var comboBox:ComboBox = new ComboBox();
			comboBox.move(0,200);
			comboBox.width = 200;
			comboBox.data = new DataProvider([1,2,3,4,5,6,7,8,9,10]);
			addChild(comboBox);
		}
		
		private function testFrame():void
		{
			var frame:Frame = new Frame();
			frame.showCloseBtn = true;
			frame.showOkBtn = true;
			frame.showCancelBtn = true;
			frame.title = "提示";
			frame.setSize(200,150);
			frame.move(0,300);
			addChild(frame);
		}
		
		private function testAlert():void
		{
			Alert.show(stage,Language.ALERT,"asdfadsf");
		}
		
		private function embedSkins():void
		{
			ButtonDefaultSkin;
			CheckBoxSelectOverSkin;
			CheckBoxUnSelectOverSkin;
			RadioButtonSelectedUpSkin;
			RadioButtonUnSelectedUpSkin;
			ScrollBarUpArrowSkin;
			ScrollBarDownArrowSkin;
			ScrollBarThumbSkin;
			ScrollBarTrackSkin;
			ScrollBarThumbIconSkin;
			ScrollPaneBackgroundSkin;
			CellRenderBackgroundSkin;
			CellRender;
			ComboBoxSkin;
			CloseButtonSkin;
			FrameSkin;
		}
	}
}