import 'dart:math';
import 'package:hive/hive.dart';

part 'card_model.g.dart'; // Đường dẫn cho file adapter được tạo tự động

@HiveType(typeId: 2) // typeId duy nhất cho model này
class CardModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String path; // Đường dẫn ảnh

  @HiveField(3)
  bool isFlip; // Đã được mở hay chưa

  @HiveField(4)
  final int typeFlip; // Hiệu ứng mở thẻ

  @HiveField(5)
  final int uid; // ID ngẫu nhiên từ 1 đến 10000

  CardModel({
    required this.id,
    required this.name,
    required this.path,
    required this.isFlip,
    required this.typeFlip,
    int? uid, // Tạo tự động nếu không truyền vào
  }) : uid = uid ?? Random().nextInt(10000) + 1;
}
