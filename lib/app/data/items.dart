class Item {
  final String name;
  final String path;

  Item({required this.name, required this.path});
}

final List<Item> effects = [
  Item(name: 'Flip', path: '1'),
  Item(name: 'Countdown', path: '2'),
  Item(name: 'Before - After', path: '3'),
  Item(name: 'Scratcher', path: '4'),
];

final List<Item> giftTypes = [
  Item(name: 'Vòng quay', path: 'assets/images/1wheel.png'),
  Item(name: '10K', path: 'assets/images/10k.png'),
  Item(name: '20K', path: 'assets/images/20k.png'),
  Item(name: '50K', path: 'assets/images/50k.png'),
  Item(name: '100K', path: 'assets/images/100k.png'),
  Item(name: '200K', path: 'assets/images/200k.png'),
  Item(name: '500K', path: 'assets/images/500k.png'),
  Item(name: 'Mất lượt', path: 'assets/images/boom.png'),
  Item(name: 'Thêm 2 lượt vào năm sau', path: 'assets/images/2.png'),
];

final List<Item> itemWheels = [
  Item(name: '100k', path: '1'),
  Item(name: 'Mất lượt', path: '2'),
  Item(name: '200k', path: '3'),
  Item(name: '100k', path: '4'),
  Item(name: 'Quà đặc biệt', path: '5'),
  Item(name: '50k', path: '6'),
  Item(name: '100k', path: '7'),
  Item(name: 'Thêm 2 lượt vào năm sau', path: '8'),
  Item(name: '200k', path: '9'),
  Item(name: '500k', path: '10'),
];
