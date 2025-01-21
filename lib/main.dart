import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lucky2025/app/data/card_model.dart';
import 'package:lucky2025/app/data/gift_model.dart';
import 'package:lucky2025/app/data/items.dart';
import 'package:lucky2025/app/modules/home/home_page.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Đăng ký adapter cho Gift
  Hive.registerAdapter(GiftAdapter());
  Hive.registerAdapter(CardModelAdapter());
  await Hive.openBox<Gift>('gifts');
  await Hive.openBox<CardModel>('cards');
  var giftBox = Hive.box<Gift>('gifts');

  if (giftBox.isEmpty) {
    List<Gift> defaultGifts = List.generate(
      10,
      (index) => Gift(
        name: itemWheels[index].name,
        quantity: 0,
        probability: 10.0,
        result: index + 1,
      ),
    );
    await giftBox.addAll(defaultGifts);
  }

  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LuckyWheel 2025',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
