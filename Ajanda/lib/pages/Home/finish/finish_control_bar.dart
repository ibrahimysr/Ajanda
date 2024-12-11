import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:yonetici_paneli/pages/Home/finish/finish_task.dart';
import 'package:yonetici_paneli/pages/Home/finish/time_end_task.dart';
import 'package:yonetici_paneli/style/database_color.dart';
import 'package:yonetici_paneli/style/style.dart';
import 'package:yonetici_paneli/widgets/bottomnavigator_button.dart';

class EndTimeController extends StatefulWidget {
  const EndTimeController({super.key});

  @override
  _EndTimeControllerState createState() => _EndTimeControllerState();
}

class _EndTimeControllerState extends State<EndTimeController>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int index = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        length: 2, vsync: this); // Sekme sayısı 2 olarak ayarlandı
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appcolor,
        centerTitle: true,
        title: Text(
          "TaskFlow",
          style: AppStyle.mainTitle,
        ),
        actions: [
           SizedBox( 
                  height: 100, 
                  width: 100,
                  child: Lottie.asset("assets/animations/logo.json"),
                )
        ],
        leading: IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: textColor,
            )),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            bottomNavigatorButton(
              () {
                setState(() {
                  _tabController.animateTo(0);
                });
              },
              _tabController.index,
              0,
              'assets/images/check.png',
              "Tamamlananlar",
            ),
            bottomNavigatorButton(
              () {
                setState(() {
                  _tabController.animateTo(1);
                });
              },
              _tabController.index,
              1,
              'assets/images/pause.png',
              "Zamanı Dolanlar",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[FinishTaskPage(), EndTimeTaskPage()],
      ),
    );
  }
}
