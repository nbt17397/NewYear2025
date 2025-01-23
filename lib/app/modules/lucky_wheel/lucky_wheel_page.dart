import 'package:flutter/material.dart';
import 'package:lucky2025/app/data/gift_model.dart';
import 'package:lucky2025/app/service/gift_picker.dart';
import 'package:lucky2025/lucky_wheel/luckywheel.dart';
import 'package:scratcher/scratcher.dart';

class LuckyWheelPage extends StatefulWidget {
  final int initialValue; // Thêm biến initialValue

  const LuckyWheelPage({Key? key, required this.initialValue})
      : super(key: key);

  @override
  State<LuckyWheelPage> createState() => _LuckyWheelPageState();
}

class _LuckyWheelPageState extends State<LuckyWheelPage>
    with TickerProviderStateMixin {
  final ValueNotifier<String> _result = ValueNotifier<String>('');
  late GiftPicker _giftPicker;
  late LuckyWheelController _wheelController;
  late int currentValue;

  @override
  void initState() {
    super.initState();
    currentValue =
        widget.initialValue; // Khởi tạo currentValue bằng initialValue
    _wheelController = LuckyWheelController(
      vsync: this,
      totalParts: 10,
      onRotationEnd: (idx) {
        final gifts = _giftPicker.giftBox.values.toList();
        if (idx < gifts.length) {
          final selectedGift = gifts[idx];
          print("Tên quà: ${selectedGift.name}");
          _result.value = selectedGift.name;
          if (selectedGift.name == 'Quà đặc biệt' ||
              selectedGift.name == 'Thêm 2 lượt vào năm sau') {
            showScratcherDialog(selectedGift.name);
          }
          if (selectedGift.name == '500k') {
            show500kDialog();
          }
        } else {
          print("Không tìm thấy quà cho kết quả này.");
        }
        setState(() {
          currentValue--; // Giảm giá trị hiện tại đi 1 sau khi quay xong
        });
      },
    );
    _giftPicker = GiftPicker();
    _giftPicker.initialize();
  }

  @override
  Widget build(BuildContext context) {
    double hightWheel = MediaQuery.of(context).size.height * .92;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: !(_result.value == 'Quà đặc biệt' ||
                      _result.value == 'Thêm 2 lượt vào năm sau'),
                  child: AnimatedBuilder(
                    animation: _result,
                    builder: (context, child) => Text(
                      _result.value, // Hiển thị phần đã thắng
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 40),
                    ),
                  ),
                ),
                Stack(
                  children: [
                    LuckyWheel(
                      controller: _wheelController,
                      onResult: (result) {},
                      child: Image.asset('assets/images/wheel.png',
                          width: hightWheel, height: hightWheel),
                    ),
                    Container(
                      width: hightWheel,
                      height: hightWheel,
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          if (currentValue > 0) {
                            // Kiểm tra giá trị hiện tại
                            Gift? selectedGift = _giftPicker.pickGift();
                            if (selectedGift != null) {
                              int selectedIndex = _giftPicker.giftBox.values
                                  .toList()
                                  .indexOf(selectedGift);

                              _wheelController.reset();
                              _wheelController.start();

                              _wheelController.stop(atIndex: selectedIndex);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Thông báo"),
                                  content: const Text("Hết quà để quay!"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Thông báo"),
                                content: const Text("Hết lượt quay!"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: Image.asset('assets/images/btn_rotate.png',
                            width: 64, height: 64),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showScratcherDialog(String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * .65,
            height: MediaQuery.of(context).size.height * .6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blueAccent, width: 4.0),
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              child: Scratcher(
                brushSize: 50,
                threshold: 30,
                image: Image.asset('assets/images/lixi.png'),
                onChange: (value) {
                  print("Scratch progress: $value%");
                },
                onThreshold: () {
                  print("Threshold reached, reveal prize!");
                },
                child: Container(
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: Image.asset(
                      name == 'Thêm 2 lượt vào năm sau'
                          ? 'assets/images/2.png'
                          : 'assets/images/500k.png',
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void show500kDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * .65,
            height: MediaQuery.of(context).size.height * .6,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blueAccent, width: 4.0),
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                child: Image.asset('assets/images/500k.png')),
          ),
        );
      },
    );
  }
}
