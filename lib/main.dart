import 'package:flutter/material.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Language Identifier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Language Identifier'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _detectionSource = "";
  String _errorMessage = "";
  List<IdentifiedLanguage> _identifiedLanguages = <IdentifiedLanguage>[];
  final TextEditingController _detectionAreaController = TextEditingController();
  final _languageIdentifier = LanguageIdentifier(confidenceThreshold: 0);

  void _detect() {
    setState(() {
      _detectionSource = _detectionAreaController.text.toString();
    });
    _identifyPossibleLanguages();
  }

  Future<void> _identifyPossibleLanguages() async {
    if (_detectionSource == "") return;
    String error;
    try {
      final possibleLanguages = await _languageIdentifier.identifyPossibleLanguages(_detectionSource);
      setState(() {
        _identifiedLanguages = possibleLanguages;
        _errorMessage = "";
      });
      return;
    } catch (e) {
      error = 'error: ${e.toString()}';
    }
    setState(() {
      _identifiedLanguages = [];
      _errorMessage = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 15.0,
              ),
              TextFormField(
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Your text goes here', labelText: 'Text'),
                keyboardType: TextInputType.text,
                minLines: 3,
                maxLines: 10,
                controller: _detectionAreaController,
              ),
              Container(
                height: 15.0,
              ),
              ElevatedButton(
                  onPressed: () => {
                        _detect()
                      },
                  child: const Text("Detect Language")),
              Container(
                height: 15.0,
              ),
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: _identifiedLanguages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Language: ${_identifiedLanguages[index].languageTag}  Confidence: ${_identifiedLanguages[index].confidence.toString()}'),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
