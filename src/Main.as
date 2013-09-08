package {
  import com.minimalui.base.Application;
  import com.minimalui.controls.Label;
  import com.minimalui.controls.Input;
  import com.minimalui.factories.FullXMLFactory;
  import com.minimalui.factories.XMLFactory;
  import com.minimalui.factories.handlers.StaticSourceImageHandler;

  import com.clisp.LexicalAnalyzer;
  import com.clisp.CLispSymbol;
  import com.clisp.ScriptEngine;
  import com.clisp.ScriptContext;

  public class Main extends Application {

    [Embed(source="../res/styles.css", mimeType="application/octet-stream")]
    [CSS]
    public var rawStyles:Class;

    [Embed(source="../res/main.xml", mimeType="application/octet-stream")]
    [Interface]
    public var rawInterface:Class;

    private var mResource:Resource;
    private var mAnalizer:LexicalAnalyzer;
    private var mEngine:ScriptEngine;
    private var mContext:ScriptContext;

    public var program:Input;
    public var result:Label;

    public function process():void {
      try {
        var prog:CLispSymbol = mAnalizer.parse(program.text);
        var res:CLispSymbol = mEngine.execute(mContext, prog);
        result.text = res.toString();
      } catch(e:Error) {
        result.text = e.toString();
        throw e;
      }
    }

    protected override function getXMLFactory():XMLFactory {
      var xmlFactory:XMLFactory = new FullXMLFactory();
      mResource = new Resource;
      xmlFactory.addAttributeHandler(new StaticSourceImageHandler(mResource));
      return xmlFactory;
    }

    protected override function onAdd():void {
      screenManager.showScreen("main");
      mAnalizer = new LexicalAnalyzer();
      mEngine = new ScriptEngine;
      mContext = mEngine.buildDefaultContext();
    }
  }
}