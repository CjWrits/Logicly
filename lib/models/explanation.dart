class Approach {
  final String name;
  final String logic;
  final String code;
  final String timeComplexity;

  Approach({
    required this.name,
    required this.logic,
    required this.code,
    required this.timeComplexity,
  });
}

class Explanation {
  final String problem;
  final String intuition;
  final List<Approach> approaches;

  Explanation({
    required this.problem,
    required this.intuition,
    required this.approaches,
  });

  factory Explanation.fromRawText(String raw) {
    String extractSection(String label, String? nextLabel) {
      final startPattern = RegExp(
        r'[#*_]*\s*' + RegExp.escape(label) + r'\s*[#*_]*',
        caseSensitive: false,
      );
      final startMatch = startPattern.firstMatch(raw);
      if (startMatch == null) return '';
      final contentStart = startMatch.end;
      if (nextLabel == null) return raw.substring(contentStart).trim();
      final endPattern = RegExp(
        r'[#*_]*\s*' + RegExp.escape(nextLabel) + r'\s*[#*_]*',
        caseSensitive: false,
      );
      final endMatch = endPattern.firstMatch(raw.substring(contentStart));
      if (endMatch == null) return raw.substring(contentStart).trim();
      return raw.substring(contentStart, contentStart + endMatch.start).trim();
    }

    // Find all APPROACH blocks
    final approachPattern = RegExp(
      r'[#*_]*\s*APPROACH\s*\d+\s*[:\-–]?\s*([^\n*#_]+)[#*_]*',
      caseSensitive: false,
    );
    final approachMatches = approachPattern.allMatches(raw).toList();

    List<Approach> approaches = [];

    for (int i = 0; i < approachMatches.length; i++) {
      final match = approachMatches[i];
      final name = match.group(1)?.trim() ?? 'Approach ${i + 1}';
      final blockStart = match.end;
      final blockEnd = i + 1 < approachMatches.length
          ? approachMatches[i + 1].start
          : raw.length;
      final block = raw.substring(blockStart, blockEnd);

      String extractFromBlock(String label, String? nextLabel) {
        final startPattern = RegExp(
          r'[#*_]*\s*' + RegExp.escape(label) + r'\s*[#*_]*',
          caseSensitive: false,
        );
        final startMatch = startPattern.firstMatch(block);
        if (startMatch == null) return '';
        final contentStart = startMatch.end;
        if (nextLabel == null) return block.substring(contentStart).trim();
        final endPattern = RegExp(
          r'[#*_]*\s*' + RegExp.escape(nextLabel) + r'\s*[#*_]*',
          caseSensitive: false,
        );
        final endMatch = endPattern.firstMatch(block.substring(contentStart));
        if (endMatch == null) return block.substring(contentStart).trim();
        return block.substring(contentStart, contentStart + endMatch.start).trim();
      }

      approaches.add(Approach(
        name: name,
        logic: extractFromBlock('LOGIC:', 'CODE:'),
        code: extractFromBlock('CODE:', 'TIME COMPLEXITY:'),
        timeComplexity: extractFromBlock('TIME COMPLEXITY:', null),
      ));
    }

    // Fallback: if no APPROACH blocks found, wrap single response as one approach
    if (approaches.isEmpty) {
      approaches.add(Approach(
        name: 'Solution',
        logic: extractSection('LOGIC:', 'CODE:'),
        code: extractSection('CODE:', 'TIME COMPLEXITY:'),
        timeComplexity: extractSection('TIME COMPLEXITY:', null),
      ));
    }

    return Explanation(
      problem: extractSection('PROBLEM:', 'INTUITION:'),
      intuition: extractSection('INTUITION:', 'APPROACH'),
      approaches: approaches,
    );
  }
}
