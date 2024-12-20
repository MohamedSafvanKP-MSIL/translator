import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator_app/utils/app_logs.dart';
import 'package:translator_app/widgets/text_fieild.dart';
import '../contants/app_constans.dart';
import '../models/language.dart';
import '../view_model/translator_view_model.dart';
import '../widgets/language_selector_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textController = TextEditingController();

  Future<void> _showLanguageSelector(
      TranslatorViewModel viewModel, bool isSource) async {
    viewModel
        .clearSearchQuery(); // Reset the search query when opening the bottom sheet
    TextEditingController searchController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ChangeNotifierProvider.value(
          value: viewModel,
          child: Consumer<TranslatorViewModel>(
            builder: (context, model, _) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  children: [
                    // Search bar at the top of the bottom sheet
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppTextField(
                          controller: searchController,
                          label: 'Search Language',
                          hitText: 'Type to search...',
                          onChanged: model.setSearchQuery,
                          prefixIcon: const Icon(Icons.search),
                        )),
                    // List of filtered languages
                    Expanded(
                      child: ListView.builder(
                        itemCount: model.filteredLanguages.length,
                        itemBuilder: (_, index) {
                          final language = model.filteredLanguages[index];
                          return ListTile(
                            title: Text(language.language),
                            onTap: () {
                              if (isSource) {
                                model.setCurrentLanguage(language.language);
                              } else {
                                model.setTargetLanguage(language.language);
                              }
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _loadLanguages() async {
    Provider.of<TranslatorViewModel>(context, listen: false).loadLanguages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Translator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
            future: _loadLanguages(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final viewModel = Provider.of<TranslatorViewModel>(context);
                return Column(
                  children: [
                    LanguageSelectorButton(
                      label: viewModel.currentLanguageCode.isEmpty
                          ? 'Source Language'
                          : viewModel.currentLanguageCode,
                      onPressed: () async {
                        await _showLanguageSelector(viewModel, true);
                      },
                    ),
                    Icon(Icons.swap_horiz),
                    LanguageSelectorButton(
                      label: viewModel.targetLanguageCode.isEmpty
                          ? 'Target Language'
                          : viewModel.targetLanguageCode,
                      onPressed: () async {
                        await _showLanguageSelector(viewModel, false);
                      },
                    ),
                    const SizedBox(height: 20),
                    AppTextField(
                        controller: _textController,
                        label: 'Enter text to translate',
                        hitText: '',
                        onChanged: (value) {
                          if (value.isNotEmpty &&
                              viewModel.currentLanguageCode.isNotEmpty &&
                              viewModel.targetLanguageCode.isNotEmpty) {
                            translateDebounce(() {
                              viewModel.translate(_textController.text);
                            });
                          }
                        }),
                    const SizedBox(height: 20),
                    if (viewModel.translatedText.isNotEmpty)
                      Text('Translated Text: ${viewModel.translatedText}'),
                  ],
                );
              }
            }),
      ),
    );
  }
}
