
import sys.io.File;

class Main {
  static function main() {
    // new Concat.compile(File.getContent(Sys.args()[0]));
    new Concat().compile('"Hello, World!" print');
  }
}
