import 'dart:convert';

import 'package:translator_app/models/translate.dart';
import 'package:translator_app/utils/app_logs.dart';
import 'package:translator_app/utils/network_client.dart';

import '../contants/api_constants.dart';
import '../models/language.dart';

class TranslationService {
  /// Fetch the list of available languages
  Future<List<LanguageElement>> fetchLanguages() async {
    var networkClient = NetworkClient(baseUrl: ApiConstants.baseUrl);

    try {
      final response = await networkClient.get(url: '/languages');

      if (response.statusCode == 200) {
        Language language = Language.fromJson(jsonDecode(response.body));
        return language.data.languages;
      } else {
        throw Exception('Failed to load languages');
      }
    } catch (e) {
      throw Exception('Failed to load languages: $e');
    }
  }

  // Translate text to the selected language
  Future<String> translateText(
      String text, String targetLanguage, String source) async {
    var networkClient = NetworkClient(baseUrl: ApiConstants.baseUrl);

    final Map<String, String> requestBody = {
      'q': text,
      'target': targetLanguage,
      'source': source,
    };

    try {
      final response = await networkClient.post(
          url: '',
          body: requestBody,
          headers: {'Content-Type': 'application/x-www-form-urlencoded'});

      if (response.statusCode == 200) {
        Translate translate = Translate.fromJson(jsonDecode(response.body));
        return translate.data.translations[0].translatedText;
      } else {
        throw Exception('Failed to translate text');
      }
    } catch (e) {
      throw Exception('Failed to translate text : ${e}');
    }
  }
}
