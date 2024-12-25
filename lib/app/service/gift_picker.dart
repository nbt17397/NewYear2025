import 'dart:math';
import 'package:hive/hive.dart';
import 'package:lucky2025/app/data/gift_model.dart';

class GiftPicker {
  late Box<Gift> giftBox; // Hive box chứa danh sách quà
  final Random _random = Random();

  GiftPicker();

  // Khợi tạo giftBox
  Future<void> initialize() async {
    giftBox = await Hive.openBox<Gift>('gifts');
  }

  /// Hàm chọn một quà ngẫu nhiên dựa trên tỉ lệ
  Gift? pickGift() {
    // Lọc danh sách quà còn số lượng > 0
    final availableGifts = giftBox.values.where((gift) => gift.quantity > 0).toList();

    if (availableGifts.isEmpty) {
      print("No gifts left!");
      return null; // Không còn quà để chọn
    }

    // Tính tổng xác suất
    double totalProbability =
        availableGifts.fold(0.0, (sum, gift) => sum + gift.probability);

    // Tính tỉ lệ tích lũy
    double cumulativeProbability = 0.0;
    final cumulativeRanges = availableGifts.map((gift) {
      cumulativeProbability += gift.probability / totalProbability * 100;
      return {'gift': gift, 'range': cumulativeProbability};
    }).toList();

    // Sinh số ngẫu nhiên trong khoảng [0, 100]
    double randomValue = _random.nextDouble() * 100;

    // Tìm quà dựa trên giá trị ngẫu nhiên
    for (var entry in cumulativeRanges) {
      if (randomValue <= (entry['range'] as num)) {
        Gift selectedGift = entry['gift'] as Gift;

        // Giảm số lượng quà
        selectedGift.quantity--;
        selectedGift.save();

        print(
            "Selected gift: ${selectedGift.name} (Remaining: ${selectedGift.quantity})");
        return selectedGift;
      }
    }

    return null; // Trường hợp không có quà nào hợp lệ
  }
}
