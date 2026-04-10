import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/explanation.dart';

class AiService {
  static String get _apiKey => dotenv.env['GROQ_API_KEY'] ?? '';
  static const String _endpoint = 'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama-3.3-70b-versatile';

  static const String _systemPrompt =
      'You are a DSA tutor. Explain DSA problems in the simplest way possible using simple English. '
      'For every problem, provide multiple solution approaches (e.g. Brute Force, Better, Optimal). '
      'You MUST respond in EXACTLY this format with no markdown on the section headers:\n\n'
      'PROBLEM:\n'
      '<2-3 line simple explanation of the problem>\n\n'
      'INTUITION:\n'
      '<general intuition that applies across approaches>\n\n'
      'APPROACH 1: <Approach Name e.g. Brute Force>\n'
      'LOGIC:\n'
      '<numbered step-by-step logic>\n'
      'CODE:\n'
      '```java\n<clean Java code>\n```\n'
      'TIME COMPLEXITY:\n'
      '<one line>\n\n'
      'APPROACH 2: <Approach Name e.g. Optimized>\n'
      'LOGIC:\n'
      '<numbered step-by-step logic>\n'
      'CODE:\n'
      '```java\n<clean Java code>\n```\n'
      'TIME COMPLEXITY:\n'
      '<one line>\n\n'
      'Add more approaches if relevant. Do NOT add ** or ## or any decoration to section headers.';

  static Future<Explanation> explain(String input) async {
    final response = await http
        .post(
          Uri.parse(_endpoint),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_apiKey',
          },
          body: jsonEncode({
            'model': _model,
            'messages': [
              {'role': 'system', 'content': _systemPrompt},
              {'role': 'user', 'content': input},
            ],
            'temperature': 0.4,
            'max_tokens': 4000,
          }),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['choices'][0]['message']['content'] as String;
      return Explanation.fromRawText(text);
    } else if (response.statusCode == 401) {
      throw Exception('Invalid API key. Please check your Groq API key.');
    } else if (response.statusCode == 429) {
      throw Exception('Rate limit exceeded. Please try again in a moment.');
    } else {
      throw Exception('API error (${response.statusCode}): ${response.body}');
    }
  }
}
