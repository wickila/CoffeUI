##关于CoffeUI


CoffeUI是一个小巧灵活，即插即用的Flash UI框架。采用Adobe原生的Flash CS作为UI编辑器，支持即时预览与丰富的自定义选项，并且与Flex完美无缝连接。作为游戏开发用的UI框架，让开发者能够非常迅速的开发UI界面。

> 1. coffe的使用非常简单。coffe可以像fl组件一样，从库面板里面直接拖拽到舞台来使用，编辑时，所见即所得。也可以像其他组件一样，在代码中直接new 出来。
> 1. coffe的样式修改非常简单，无论是默认样式修改，还是动态样式修改，都非常简单。动态样式的修改，在Flash cs里编辑时，修改组件的style属性即可。例如，你可以拖拽一个Button到舞台，然后在属性面板里面修改他的字体颜色，背景图片等。（修改背景图片需要按Ctrl+Enter发布才能看到效果，im sorry，如果谁有好的主意改进，也教我一下吧）
> 1. coffe修改比较麻烦，但是这样也造就了coffe的稳定性（想修改一下组件也懒的动手啊）
> 1. coffe的体积非常小哦。

##如何使用coffeui
CoffeUI可以在Flash Cs与Flash Builder中单独使用，也可以在结合两者一起使用。
###在Flash builder中的ActionScript工程或者Flex工程中使用coffeui:

1. 在Flash cs中打开coffeuiout.fla。
1. 发布coffeuiout.fla，得到coffeuiout.swc。
1. 把coffeuiout.swc拷贝到项目中，并且加入到构建路径中。
1. 在代码中导入coffe.controls.Button,然后new Button()即可。
	
	`var btn:Button = new Button();
	this.addChild(btn);`

###在Flash cs中使用coffeui:

在你要使用的目标fla文件中，选择“文件-->导入-->打开外部库”，然后选择coffeuiout.fla，就可以看到coffeuiout.fla里面的组件了，直接拖拽到舞台即可。选中组件后，可以在Flash cs的属性面板中编辑组件的属性（除编辑style类型的属性不能即时预览之外，修改属性一般都可以在Flash cs中即时刷新，style类型的属性修改后需要按Ctrl+Enter发布才能看到）。


##如何修改coffeui
修改coffeui需要用到src文件夹里面的源代码，与coffeuisource.fla的源Flash cs文件

###修改源代码
1. 打开src文件夹，选择需要修改的源代码文件，修改以后保存（不习惯记事本或者Flash cs的话，就建Flex库项目来修改啦，coffeui不依赖于其他任何库,所以很轻松地就可以建立coffeui的库项目）。
1. 打开coffeuisource.fla文件，选择你刚刚修改过的组件（例如你修改过Button.as，那需要选择Button,ScrollBar等组件，因为这些组件都有引用Button）。右键点击组件，选择“导出swc文件”，导出到“C:\Users\UserName\AppData\Local\Adobe\Flash CS6\zh_CN\Configuration\Components\CoffeUI”文件夹下，导出的文件名就是组件的名字，例如Button.swc。
1. 在Flash cs里面新建一个Actionscrip 3.0的fla文件，然后Ctrl+F7选择组件面板，点击重新加载组件，即可以看到你刚刚修改过的组件。拖到舞台上来测试一下修改是否成功吧。
1. 如果测试成功，就打包一个可用的coffeuiout.fla吧。（见下文中，如何打包一个可用的coffeuiout.fla）

###修改默认外观样式

1. 打开coffeuisource.fla文件，在库面板中选择“Component Assets”文件夹。
1. 随心所欲地修改里面的样式资源吧。只要记得不要改动资源的外链URL就没问题的。
1. 右键点击修改过的组件，选择“导出swc文件”，导出到“C:\Users\UserName\AppData\Local\Adobe\Flash CS6\zh_CN\Configuration\Components\CoffeUI”文件夹下，导出的文件名就是组件的名字，例如Button.swc。
1. 在Flash cs里面新建一个Actionscrip 3.0文件，然后Ctrl+F7选择组件面板，点击重新加载组件，即可以看到你刚刚修改过的组件。拖到舞台上来测试一下修改是否成功吧。
1. 如果测试成功，打包可用的coffeuiout.fla。（见下文中，如何打包一个可用的coffeuiout.fla）

##已知问题
在FlashBuilder4.7下，嵌入代码中的coffeuiout.swc经过FlashBuilder4.7的重新编译后，组件的皮肤的九宫格会失效。（应该是FlashBuilder4.7的问题，换成FlashBuilder4.6就不会有这个问题）。解决办法：

- 改用FlashBuilder4.6

- FlashBuilder4.7下使用时，把coffeuiout.swc的链接类型改成外部，然后在程序开始时通过加载coffeuiout.swf来导入coffeui。（防止coffeui被FlashBuilder4.7重新编译)

如有疑问，请参考文档，或请联系gzswicki@gmail.com