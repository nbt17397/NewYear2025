import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lucky2025/app/data/gift_model.dart';

class GiftSettingPage extends StatefulWidget {
  const GiftSettingPage({super.key});

  @override
  _GiftSettingPageState createState() => _GiftSettingPageState();
}

class _GiftSettingPageState extends State<GiftSettingPage> {
  late Box<Gift> giftBox;

  @override
  void initState() {
    super.initState();
    giftBox = Hive.box<Gift>('gifts');
  }

  // Hàm cập nhật thông tin món quà
  void _updateGift(Gift gift, String name, int quantity, double probability) {
    setState(() {
      gift.name = name;
      gift.quantity = quantity;
      gift.probability = probability;
      gift.save(); // Lưu lại vào Hive
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gift Settings')),
      body: ValueListenableBuilder(
        valueListenable: giftBox.listenable(),
        builder: (context, Box<Gift> box, _) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              Gift gift = box.getAt(index)!;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 4.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 5,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  title: Text(
                    gift.name,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Quantity: ${gift.quantity}', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 2),
                      Text('Probability: ${gift.probability}%', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () async {
                      // Mở dialog để chỉnh sửa quà tặng
                      await _showEditDialog(gift);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Hàm hiển thị dialog để chỉnh sửa
  Future<void> _showEditDialog(Gift gift) async {
    TextEditingController nameController = TextEditingController(text: gift.name);
    TextEditingController quantityController = TextEditingController(text: gift.quantity.toString());
    TextEditingController probabilityController = TextEditingController(text: gift.probability.toString());

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Edit Gift: ${gift.name}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Gift Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: probabilityController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Probability (%)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Thoát mà không thay đổi gì
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Cập nhật quà tặng
                String name = nameController.text;
                int quantity = int.tryParse(quantityController.text) ?? gift.quantity;
                double probability = double.tryParse(probabilityController.text) ?? gift.probability;

                _updateGift(gift, name, quantity, probability);

                Navigator.pop(context); // Đóng dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
