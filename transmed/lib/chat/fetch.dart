import 'package:google_generative_ai/google_generative_ai.dart';

Future<String?> generateResponse(String userInput) async {
  const apiKey =
      'AIzaSyB1aFambm7OuA4PoQ8Au4UNZ3MD_jch-dk'; // 请替换为你的 API 密钥

  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: apiKey,
  );

  final content = [Content.text(userInput)];
  final response = await model.generateContent(content);
  return response.text;
}