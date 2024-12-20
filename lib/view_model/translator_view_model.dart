import 'package:flutter/material.dart';
import 'package:translator_app/utils/app_logs.dart';
import 'package:translator_app/utils/debounce.dart';

import '../models/language.dart';
import '../services/translation_service.dart';

class TranslatorViewModel extends ChangeNotifier {
  final TranslationService _service = TranslationService();

  List<LanguageElement> _languages = [];

  List<LanguageElement> get languages => _languages;

  String _currentLanguageCode = '';

  String get currentLanguageCode => _currentLanguageCode;

  String _targetLanguageCode = '';

  String get targetLanguageCode => _targetLanguageCode;

  String _translatedText = '';

  String get translatedText => _translatedText;

  Future<void> loadLanguages() async {
    try {
      _languages = await _service.fetchLanguages();
    } catch (e) {
      AppLogs.printLog('loadLanguages:$e');
    } finally {
      notifyListeners();
    }
  }

  void setCurrentLanguage(String code) {
    _currentLanguageCode = code;
    notifyListeners();
  }

  void setTargetLanguage(String code) {
    _targetLanguageCode = code;
    notifyListeners();
  }

  Future<void> translate(String text) async {
    if (_targetLanguageCode.isEmpty) return;
    if (_currentLanguageCode.isEmpty) return;
    try {
      _translatedText = await _service.translateText(
          text, _targetLanguageCode, _currentLanguageCode);
    } catch (e) {
      _translatedText = 'Error: ${e.toString()}';
      AppLogs.printLog('translate:$e');
    } finally {
      notifyListeners();
    }
  }

  String searchQuery = '';

  List<LanguageElement> get filteredLanguages => languages
      .where((language) =>
      language.language.toLowerCase().contains(searchQuery.toLowerCase()))
      .toList();

  void setSearchQuery(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void clearSearchQuery() {
    searchQuery = '';
    notifyListeners();
  }
}
