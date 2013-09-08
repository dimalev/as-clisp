package {
  import cases.com.clisp.LexemTest;
  import cases.com.clisp.LexicalAnalyzerTest;
  import cases.com.clisp.ScriptEngineTest;
  import cases.com.clisp.ScriptContextTest;
  import cases.com.clisp.EasyFunctionTest;

  [Suite]
  [RunWith("org.flexunit.runners.Suite")]
  public class TestSuite {
    public var test0:LexemTest;
    public var test1:LexicalAnalyzerTest;
    public var test2:ScriptEngineTest;
    public var test3:ScriptContextTest;
    public var test4:EasyFunctionTest;
  }
}