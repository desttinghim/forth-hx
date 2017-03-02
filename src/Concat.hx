
enum StackType {
  Int;
  String;
}

class Concat {

  public var words:Map<String,Void->Void>;
  public var stack:Array<{value:Dynamic,type:StackType}>;
  public var rStack:Array<{value:Dynamic,type:StackType}>;

  public function compile(str) {
    var tokens = tokenize(str);
    for (token in tokens) {
      trace(token);
      var x = getWord(token);
      if (x != null) {
        x();
      }
    }
  }

  public function new() {
    words = new Map<String,Void->Void>();
    stack = [];
    rStack = [];
    addWord("print", function() trace(stack.pop().value));
  }

  public function addWord(name, f) {
    words.set(name, f);
  }

  public function push(val, type) {
    stack.push({value:val, type:type});
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
  // 2. Look up the word, put value on stack or push value on stack
  public function getWord(str:String) {
    if(str.charAt(0) == '"') {
      push(str, String);
      return null;
    }
    else if(Std.parseInt(str) != null) {
      push(str, Int);
      return null;
    }
    else if(words.get(str) != null) {
      return words.get(str);
    }
    return null;
  }
}
