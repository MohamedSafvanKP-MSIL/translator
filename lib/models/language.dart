// To parse this JSON data, do
//
//     final language = languageFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Language languageFromJson(String str) => Language.fromJson(json.decode(str));

String languageToJson(Language data) => json.encode(data.toJson());

class Language {
  final Data data;

  Language({
    required this.data,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  final List<LanguageElement> languages;

  Data({
    required this.languages,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        languages: List<LanguageElement>.from(
            json["languages"].map((x) => LanguageElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "languages": List<dynamic>.from(languages.map((x) => x.toJson())),
      };
}

class LanguageElement {
  final String language;

  LanguageElement({
    required this.language,
  });

  factory LanguageElement.fromJson(Map<String, dynamic> json) =>
      LanguageElement(
        language: json["language"],
      );

  Map<String, dynamic> toJson() => {
        "language": language,
      };
}
