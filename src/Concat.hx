
enum StackType {
  Int;
  String;
}

typedef DictEntry = {
  var word:String;
  var native:Bool;
  var immediate:Bool;
  var func:Void->Void;
  var def:Array<Int>;
};

class Concat {

  public var words:Array<DictEntry>;
  public var tokens:Array<String>;
  public var stack:Array<{value:Dynamic,type:StackType}>;
  public var rStack:Array<{value:Dynamic,type:StackType}>;

  public function run() {
    while(true) {
      if (tokens.length == 0)  getInput();
      var token:String = nextToken();
      if (token==null) continue;
      var xword = null;
      for (word in words) {
        if (word.word == token) xword = word;
      }
      if (xword!=null)  {
        if (xword.native) xword.func();
        else              interpWords(xword.def);
      } else {
        push(Std.parseInt(token), Int);
      }
    }
  }

  public function getInput() {
    tokens = tokens.concat(tokenize(Sys.stdin().readLine()));
  }

  public function nextToken() {
    return tokens.shift();
  }

  public function new() {
    tokens = [];
    words = [];
    stack = [];
    rStack = [];
    addWord("+", function() push(pop().value + pop().value, Int));
    addWord("-", function() push(pop().value - pop().value, Int));
    addWord("*", function() push(pop().value * pop().value, Int));
    addWord("/", function() push(pop().value / pop().value, Int));
    addWord("print", function() Sys.print(pop().value));
    addWord("clear", function() Sys.command("clear"));
  }

  public function addWord(word, func, ?def=null) {
    words.push({
      word:word,
      native:false,
      immediate:false,
      func:func,
      def: def==null?[]:def,
    });
  }

  public function interpWords(tokens:Array<Int>) {
    for (token in tokens) interpOneWord(token);
  }

  public function interpOneWord(xtoken) {
    if (words[xtoken].native) words[xtoken].func();
    else                      interpWords(words[xtoken].def);
  }

  public function push(val, type) {
    stack.push({value:val, type:type});
  }

  public function pop() {
    return stack.pop();
  }
  // Steps:
  // 1. Tokenize
  public function tokenize(str:String) {
    var s = str.split(' ');
    var strCopy:Array<String> = [];
    var joining = false;
    for (t in s) {
      if(joining) {
        strCopy.push(strCopy.pop() + t);
      } else {
        strCopy.push(t);
      }
      if (t.charAt(0) == '"') {
        joining = true;
        t.substr(1);
      }
      if (t.charAt(t.length-1) == '"') {
        joining = false;
        t.substr(0,t.length-1);
      }
    }
    return strCopy;
  }
  // // 2. Look up the word, put value on stack or push value on stack
  // public function getWord(str:String) {
  //   if(str.charAt(0) == '"') {
  //     push(str, String);
  //     return null;
  //   }
  //   else if(Std.parseInt(str) != null) {
  //     push(str, Int);
  //     return null;
  //   }
  //   else if(words.get(str) != null) {
  //     return words.get(str);
  //   }
  //   return null;
  // }
}
