import 'package:hive/hive.dart';

part 'gift_model.g.dart';

@HiveType(typeId: 0)
class Gift extends HiveObject {
  @HiveField(0)
  String name; // Tên quà tặng

  @HiveField(1)
  int quantity; // Số lượng còn lại

  @HiveField(2)
  double probability; // Tỉ lệ %

  @HiveField(3)
  int result; // Múi tương ứng (1 - 12)

  Gift({
    required this.name,
    required this.quantity,
    required this.probability,
    required this.result,
  });
}
