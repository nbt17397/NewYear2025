import 'package:flutter/material.dart';
import 'package:lucky2025/app/modules/lucky_wheel/lucky_wheel_page.dart';
import 'package:lucky2025/app/modules/setting/card_setting_page.dart';

import 'package:lucky2025/app/modules/setting/gift_setting_page.dart'; // Để sử dụng rootBundle khi cần thiết

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),backgroundColor: Colors.blue,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Settings Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Gift Settings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GiftSettingPage()),
                  ).then(Navigator.of(context).pop);
                },
              ),
              ListTile(
                title: const Text('Card Settings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CardSettingPage()),
                  ).then(Navigator.of(context).pop);
                },
              ),
            ],
          ),
        ),
        body: const LuckyWheelPage());
  }
}
