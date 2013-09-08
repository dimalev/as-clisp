package cases.com.clisp {
  import org.flexunit.Assert;
  import com.clisp.ScriptContext;
  import com.clisp.Bindings;

  public class ScriptContextTest {
    [Test(description = "Simple bindings")]
    public function simpleBindings():void {
      var sc:ScriptContext = new ScriptContext;
      sc.setAttribute("var-a", 12, 0);
      sc.setAttribute("var-b", "str", 0);
      sc.setAttribute("var-a", 22, 1);
      Assert.assertTrue("get global var-b", sc.getAttribute("var-b") == "str");
      Assert.assertTrue("get closest var-a", sc.getAttribute("var-a") == 22);
      Assert.assertTrue("get global var-a", sc.getAttribute("var-a", 0) == 12);
    }
    [Test(description = "Remove binding")]
    public function removeBinding():void {
      var sc:ScriptContext = new ScriptContext;
      sc.setAttribute("var-a", 12, 0);
      sc.setAttribute("var-b", "str", 0);
      sc.setAttribute("var-a", 22, 1);
      sc.setBindings(null, 1);
      Assert.assertTrue("get closest var-a", sc.getAttribute("var-a") == 12);
    }
  }
}