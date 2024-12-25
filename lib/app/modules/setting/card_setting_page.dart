import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lucky2025/app/data/card_model.dart';
import 'package:lucky2025/app/data/items.dart';

class CardSettingPage extends StatefulWidget {
  const CardSettingPage({Key? key}) : super(key: key);

  @override
  _CardSettingPageState createState() => _CardSettingPageState();
}

class _CardSettingPageState extends State<CardSettingPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedEffect = '1';
  Item? _selectedGift;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Cards'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<Box<CardModel>>(
        valueListenable: Hive.box<CardModel>('cards').listenable(),
        builder: (context, box, _) {
          final cards = box.values.toList();
          cards.sort((a, b) => a.uid.compareTo(b.uid));
          return Column(
            children: [
              Expanded(
                child: cards.isEmpty
                    ? const Center(
                        child: Text(
                          'No cards available. Tap the button below to add one!',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 8,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 3 / 4,
                        ),
                        itemCount: cards.length,
                        itemBuilder: (context, index) {
                          final card = cards[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: card.path.isNotEmpty
                                        ? Image.asset(
                                            card.path,
                                            fit: BoxFit.cover,
                                          )
                                        : const Image(
                                            image: AssetImage(
                                                'assets/images/lixi.jpg'),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        card.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'UID: ${card.uid}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => _deleteCard(box, card),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () => _showAddCardDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Card'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _deleteCard(Box<CardModel> box, CardModel card) async {
    await card.delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Card deleted successfully!')),
    );
  }

  void _showAddCardDialog(BuildContext context) {
    _selectedGift = giftTypes.first;
    _selectedEffect = '1';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            'Add New Card',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<Item>(
                    value: _selectedGift,
                    decoration: const InputDecoration(
                      labelText: 'Select Gift',
                      border: OutlineInputBorder(),
                    ),
                    items: giftTypes.map((gift) {
                      return DropdownMenuItem(
                        value: gift,
                        child: Text(gift.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGift = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedEffect,
                    decoration: const InputDecoration(
                      labelText: 'Effect',
                      border: OutlineInputBorder(),
                    ),
                    items: effects.map((effect) {
                      return DropdownMenuItem(
                        value: effect.path,
                        child: Text(effect.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedEffect = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _saveCard,
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveCard() async {
    if (_formKey.currentState!.validate()) {
      // Kiểm tra điều kiện giftTypes.name = 'LuckyWheel' và effects.name = 'Flip'
      print(_selectedGift!.name);
      print(_selectedGift!.name);
      if (_selectedGift!.name == 'LuckyWheel' && _selectedEffect != '1') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Effect must be "Flip" for "LuckyWheel"!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final box = Hive.box<CardModel>('cards');
      final newCard = CardModel(
        id: box.length + 1,
        name: _selectedGift!.name,
        path: _selectedGift!.path,
        isFlip: false,
        typeFlip: int.parse(_selectedEffect),
      );

      await box.add(newCard);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card added successfully!')),
      );
    }
  }
}
