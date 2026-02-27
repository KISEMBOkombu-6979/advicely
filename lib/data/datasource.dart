import 'dart:convert';

import 'package:advicely/data/model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<Conseil> genererConseil() async {
  final client = http.Client();
  final uri = dotenv.env ["API_URL"] ?? "";
  final cle = dotenv.env ["API_KEY"] ?? "";
  final reponse = await client.get(Uri.parse(uri), headers: {"X-Api-Key": cle});
  final json =
      jsonDecode(utf8.decode(reponse.bodyBytes))
          as Map; 


  final anglais = json["advice"] as String;
  final francais = await _translateToFrench(anglais);
  json["advice"] = francais;

  return Conseil.fromJSON(json);
}


Future<String> _translateToFrench(String text) async {
  try {
    final uri = Uri.parse(
      'https://api.mymemory.translated.net/get?langpair=en|fr&q=${Uri.encodeComponent(text)}',
    );
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      final map = jsonDecode(res.body) as Map;
      final translated = map['responseData']?['translatedText'] as String?;
      if (translated != null && translated.isNotEmpty) {
        return translated;
      }
    }
  } catch (_) {}

  return text;
}