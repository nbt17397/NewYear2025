import 'package:flutter/material.dart';
import 'package:lucky2025/app/data/gift_model.dart';
import 'package:lucky2025/app/service/gift_picker.dart';
import 'package:lucky2025/lucky_wheel/luckywheel.dart';

class LuckyWheelPage extends StatefulWidget {
  const LuckyWheelPage({Key? key}) : super(key: key);

  @override
  State<LuckyWheelPage> createState() => _LuckyWheelPageState();
}

class _LuckyWheelPageState extends State<LuckyWheelPage>
    with TickerProviderStateMixin {
  final ValueNotifier<String> _result = ValueNotifier<String>('');
  late GiftPicker _giftPicker;
  late LuckyWheelController _wheelController;

  @override
  void initState() {
    super.initState();
    _wheelController = LuckyWheelController(
      vsync: this,
      totalParts: 12,
      onRotationEnd: (idx) {
        // Cập nhật kết quả khi quay
        // _result.value = idx;
        final gifts = _giftPicker.giftBox.values.toList();
        if (idx < gifts.length) {
          final selectedGift = gifts[idx];
          print("Tên quà: ${selectedGift.name}");
          _result.value = selectedGift.name;
        } else {
          print("Không tìm thấy quà cho kết quả này.");
        }
      },
    );
    _giftPicker = GiftPicker();
    _giftPicker.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blue,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _result,
                  builder: (context, child) => Text(
                    _result.value, // Hiển thị phần đã thắng
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 40),
                  ),
                ),
                const SizedBox(height: 50),
                Stack(
                  children: [
                    LuckyWheel(
                      controller: _wheelController,
                      onResult: (result) {
                        // Cập nhật kết quả khi quay xong
                        // _result.value = result;
                      },
                      child: Image.asset('images/1wheel.png',
                          width: 500, height: 500),
                      // child: const SpinningWidget(width: 500, height: 500, totalParts: 12),
                    ),
                    Container(
                      width: 500,
                      height: 500,
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          // Lấy quà ngẫu nhiên
                          Gift? selectedGift = _giftPicker.pickGift();
                          if (selectedGift != null) {
                            int selectedIndex = _giftPicker.giftBox.values
                                .toList()
                                .indexOf(selectedGift);

                            // Đặt lại vòng quay và bắt đầu
                            _wheelController.reset();
                            _wheelController.start();

                            // Dừng vòng quay tại phần quà được chọn
                            _wheelController.stop(atIndex: selectedIndex);
                          } else {
                            // Hiển thị thông báo nếu hết quà
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
                        },
                        onDoubleTap: () {
                          _wheelController.reset();
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
}
