import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:lucky2025/app/data/card_model.dart';
import 'package:lucky2025/app/modules/before_after/before_after.dart';
import 'package:lucky2025/app/modules/lucky_wheel/lucky_wheel_page.dart';
import 'package:lucky2025/app/modules/setting/setting_page.dart';
import 'package:pinput/pinput.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ValueListenableBuilder<Box<CardModel>>(
          valueListenable: Hive.box<CardModel>('cards').listenable(),
          builder: (context, box, _) {
            final cards = box.values.toList();
            cards.sort((a, b) => a.uid.compareTo(b.uid));
            return Column(
              children: [
                Expanded(
                    child: cards.isEmpty
                        ? Center(
                            child: ElevatedButton(
                              onPressed: showPinPut,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                              ),
                              child: const Text(
                                'Add a card!',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          )
                        : GridView.builder(
                            itemCount: (cards).length,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 10,
                                    mainAxisExtent: 205,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 5),
                            itemBuilder: (BuildContext context, int i) {
                              return _renderContent(context,
                                  item: cards[i],
                                  index: cards.indexOf(cards[i]));
                            })),
              ],
            );
          },
        ),
      ),
      floatingActionButton: IconButton(
          onPressed: showPinPut,
          icon: const Icon(Icons.lock, color: Colors.blue)),
    );
  }

  showPinPut() {
    final pinController = TextEditingController();
    final focusNode = FocusNode();
    final formKey = GlobalKey<FormState>();
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );
    return Alert(
        context: context,
        title: 'PIN',
        style: const AlertStyle(
            isOverlayTapDismiss: false,
            titlePadding: EdgeInsets.only(bottom: 10),
            buttonAreaPadding: EdgeInsets.symmetric(horizontal: 10),
            alertPadding: EdgeInsets.all(0),
            backgroundColor: Colors.white),
        content: Form(
          key: formKey,
          child: SizedBox(
            height: 100,
            child: Pinput(
              controller: pinController,
              focusNode: focusNode,
              obscureText: true,
              defaultPinTheme: defaultPinTheme,
              validator: (value) {
                return value == '1703' ? null : 'Pin is incorrect';
              },
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {
                if (pin == "1703") {
                  Navigator.pop(context);
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (_) => const SettingPage()));
                }
              },
              onChanged: (value) {
                debugPrint('onChanged: $value');
              },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: focusedBorderColor,
                  ),
                ],
              ),
            ),
          ),
        ),
        buttons: []).show();
  }

  _renderContent(context, {required CardModel item, required int index}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      color: const Color(0x00000000),
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        speed: 5000,
        flipOnTouch: !item.isFlip,
        onFlipDone: (bool isSuccess) async {
          if (item.name == 'LuckyWheel') {
            print("LuckyWheel");
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  contentPadding: const EdgeInsets.all(20.0),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Ảnh vòng quay may mắn
                      Image.asset(
                        'assets/images/1wheel.png', // Thay đường dẫn ảnh phù hợp
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context); // Đóng popup
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const LuckyWheelPage()),
                          );
                        },
                        child: const Text(
                          'Vòng Quay May Mắn',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          if (isSuccess) {
            print("Success ${item.name}");
            final box = Hive.box<CardModel>('cards');
            final card = box.values.firstWhere((card) => card.id == item.id);
            card.isFlip = true;
            await card.save();
          }
        },
        onFlip: () async {
          print("===== ${item.name}");
          switch (item.typeFlip) {
            case 1:
              break;
            case 2:
              _beforeAfter(item, true);
              break;
            case 3:
              _beforeAfter(item, false);
              break;
            default:
          }
        },
        front: item.isFlip
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                        image: AssetImage(
                          'assets/images/lixi.jpg',
                        ),
                        fit: BoxFit.cover)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(item.name.toString(),
                        style: Theme.of(context).textTheme.bodyMedium),
                    Image.asset(
                      item.path.toString(),
                      height: 45,
                    )
                  ],
                ))
            : Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  color: const Color.fromARGB(172, 224, 221, 240),
                  borderRadius: const BorderRadius.all(Radius.circular(6.0)),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        left: 5,
                        top: 2,
                        child: Text((index + 1).toString(),
                            style: GoogleFonts.roboto(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ))),
                    Center(
                      child: Lottie.asset('assets/images/lucky.json',
                          fit: BoxFit.cover, height: 110, width: 110),
                    ),
                  ],
                ),
              ),
        back: Container(
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 162, 186, 186),
              borderRadius: BorderRadius.all(
                Radius.circular(6.0),
              ),
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/lixi.jpg',
                ),
                fit: BoxFit.cover,
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(item.name.toString(),
                  style: Theme.of(context).textTheme.bodyMedium),
              Image.network(
                item.path.toString(),
                height: 45,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _beforeAfter(CardModel item, bool isCountdown) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(0),
          children: [
            BeforeAfter(
              imageWidth: MediaQuery.of(context).size.width * .8,
              imageHeight: MediaQuery.of(context).size.height * .8,
              beforeImage: Image.asset(item.path),
              afterImage: Center(
                child: Lottie.asset(
                    isCountdown
                        ? 'assets/images/countdown.json'
                        : 'assets/jsons/congratulation.json',
                    repeat: false,
                    fit: BoxFit.fitHeight),
              ),
              isVertical: false,
              temp: isCountdown ? 4 : 0,
            )
          ],
        );
      },
    );
  }
}
