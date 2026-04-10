import 'package:flutter/material.dart';

class JavaSyntaxHighlighter extends StatelessWidget {
  final String code;

  const JavaSyntaxHighlighter({super.key, required this.code});

  static const _keywords = {
    'abstract', 'assert', 'boolean', 'break', 'byte', 'case', 'catch', 'char',
    'class', 'const', 'continue', 'default', 'do', 'double', 'else', 'enum',
    'extends', 'final', 'finally', 'float', 'for', 'goto', 'if', 'implements',
    'import', 'instanceof', 'int', 'interface', 'long', 'native', 'new',
    'package', 'private', 'protected', 'public', 'return', 'short', 'static',
    'strictfp', 'super', 'switch', 'synchronized', 'this', 'throw', 'throws',
    'transient', 'try', 'void', 'volatile', 'while', 'var', 'null', 'true', 'false',
  };

  // VS Code dark+ inspired palette
  static const _keyword   = Color(0xFF569CD6); // blue
  static const _type      = Color(0xFF4EC9B0); // teal  (class names / types)
  static const _string    = Color(0xFFCE9178); // orange-brown
  static const _number    = Color(0xFFB5CEA8); // light green
  static const _comment   = Color(0xFF6A9955); // green
  static const _method    = Color(0xFFDCDCAA); // yellow
  static const _symbol    = Color(0xFFD4D4D4); // light grey
  static const _plain     = Color(0xFFCDD6F4); // default text

  List<TextSpan> _tokenize(String src) {
    final spans = <TextSpan>[];
    int i = 0;

    while (i < src.length) {
      // Single-line comment
      if (i + 1 < src.length && src[i] == '/' && src[i + 1] == '/') {
        final end = src.indexOf('\n', i);
        final text = end == -1 ? src.substring(i) : src.substring(i, end);
        spans.add(TextSpan(text: text, style: const TextStyle(color: _comment)));
        i = end == -1 ? src.length : end;
        continue;
      }

      // Multi-line comment
      if (i + 1 < src.length && src[i] == '/' && src[i + 1] == '*') {
        final end = src.indexOf('*/', i + 2);
        final text = end == -1 ? src.substring(i) : src.substring(i, end + 2);
        spans.add(TextSpan(text: text, style: const TextStyle(color: _comment)));
        i = end == -1 ? src.length : end + 2;
        continue;
      }

      // String literal
      if (src[i] == '"') {
        int j = i + 1;
        while (j < src.length && !(src[j] == '"' && src[j - 1] != '\\')) j++;
        final text = src.substring(i, j < src.length ? j + 1 : j);
        spans.add(TextSpan(text: text, style: const TextStyle(color: _string)));
        i = j < src.length ? j + 1 : j;
        continue;
      }

      // Char literal
      if (src[i] == "'") {
        int j = i + 1;
        while (j < src.length && !(src[j] == "'" && src[j - 1] != '\\')) j++;
        final text = src.substring(i, j < src.length ? j + 1 : j);
        spans.add(TextSpan(text: text, style: const TextStyle(color: _string)));
        i = j < src.length ? j + 1 : j;
        continue;
      }

      // Number
      if (_isDigit(src[i]) || (src[i] == '-' && i + 1 < src.length && _isDigit(src[i + 1]))) {
        int j = i + 1;
        while (j < src.length && (_isDigit(src[j]) || src[j] == '.' || src[j] == 'L' || src[j] == 'f')) j++;
        spans.add(TextSpan(text: src.substring(i, j), style: const TextStyle(color: _number)));
        i = j;
        continue;
      }

      // Word (keyword / type / method / identifier)
      if (_isLetter(src[i])) {
        int j = i + 1;
        while (j < src.length && (_isLetter(src[j]) || _isDigit(src[j]))) j++;
        final word = src.substring(i, j);

        Color color;
        if (_keywords.contains(word)) {
          color = _keyword;
        } else if (word[0] == word[0].toUpperCase() && word[0] != word[0].toLowerCase()) {
          color = _type; // PascalCase → class/type
        } else if (j < src.length && src[j] == '(') {
          color = _method; // followed by ( → method call
        } else {
          color = _plain;
        }

        spans.add(TextSpan(text: word, style: TextStyle(color: color)));
        i = j;
        continue;
      }

      // Symbols / operators / whitespace
      final ch = src[i];
      final isOp = '+-*/%=<>!&|^~?:'.contains(ch);
      spans.add(TextSpan(
        text: ch,
        style: TextStyle(color: isOp ? _symbol : _plain),
      ));
      i++;
    }

    return spans;
  }

  bool _isDigit(String c) => c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;
  bool _isLetter(String c) {
    final code = c.codeUnitAt(0);
    return (code >= 65 && code <= 90) || (code >= 97 && code <= 122) || c == '_' || c == '\$';
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontFamily: 'monospace', fontSize: 13, height: 1.7),
        children: _tokenize(code),
      ),
    );
  }
}
