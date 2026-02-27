import 'package:advicely/pages/conseil_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
  await dotenv.load(fileName: '.env');
  runApp(MaterialApp(title: "Advicely",home: ConseilPage(),));
}
