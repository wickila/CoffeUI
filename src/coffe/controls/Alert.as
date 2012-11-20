package coffe.controls
{
	import coffe.data.Language;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class Alert extends Frame
	{
		public function Alert()
		{
			super();
		}
		
		public static function show(parent:DisplayObjectContainer,title:String=Language.ALERT,text:String="",showOkBtn:Boolean = true,showCancelBtn:Boolean = true):void
		{
			var alert:Frame = new Frame();
			alert.title = title;
			alert.showCancelBtn = showCancelBtn;
			alert.showOkBtn = showOkBtn;
			var tf:TextField = new TextField();
			tf.selectable = tf.mouseEnabled = false;
			tf.text = text;
			tf.width = 200;
			tf.height = tf.textHeight + 20;
			alert.setContent(tf);
			alert.drawNow();
			parent.addChild(alert);
			alert.x = (parent.stage.stageWidth-alert.width)*.5;
			alert.y = (parent.stage.stageHeight - alert.height)*.5;
		}
	}
}