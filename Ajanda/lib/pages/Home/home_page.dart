import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:yonetici_paneli/pages/Home/add_task.dart';
import 'package:yonetici_paneli/service/user_service.dart';
import 'package:yonetici_paneli/style/database_color.dart';
import 'package:yonetici_paneli/style/style.dart';
import 'package:yonetici_paneli/widgets/category_text.dart';
import 'package:yonetici_paneli/widgets/stream_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final taskName = TextEditingController();
  var taskDate = TextEditingController();
  final taskDetails = TextEditingController();
  final taskDeadline = TextEditingController();
  final ValueNotifier<String> selectedTaskType = ValueNotifier<String>('Görev');
  String selectedCategory = "Görev";
  String searchText = '';
  Color categoryTextColor = textColor;
  int index = 1;

  Color getCategoryColor(String category) {
    return selectedCategory == category ? Colors.white : appcolor;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    return currentUser != null
        ? Scaffold(
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
            ),
            backgroundColor: appcolor,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: TextField(
                      style: const TextStyle(color: textColor),
                      //controller: arama,
                      onChanged: (value) {
                        setState(() {
                          searchText = value.toLowerCase();
                        });
                      },

                      decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          fillColor: const Color(0xff282C34),
                          prefixIcon:
                              Icon(Icons.search, color: Colors.blue.shade300),
                          hintText: "Ara",
                          hintStyle: const TextStyle(
                              color: Colors.grey, fontSize: 15)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 1,
                        child: categoryText(
                            () => {
                                  setState(() {
                                    selectedCategory = 'Görev';
                                  })
                                },
                            "Görevler",
                            getCategoryColor("Görev")),
                      ),
                      Expanded(
                        flex: 1,
                        child: categoryText(
                            () => {
                                  setState(() {
                                    selectedCategory = 'Toplantı';
                                  })
                                },
                            "Toplantılar",
                            getCategoryColor("Toplantı")),
                      ),
                      Expanded(
                        flex: 1,
                        child: categoryText(
                            () => {
                                  setState(() {
                                    selectedCategory = 'Not';
                                  })
                                },
                            "Notlar",
                            getCategoryColor("Not")),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: MyStreamBuilder(
                  selectedCategory: selectedCategory,
                  deleteCategory: selectedCategory,
                  searchText: searchText,
                  showPastDue: false,
                  check: false,
                )),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: textColor,
              child: const Icon(
                Icons.add,
                size: 35,
                color: appcolor,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.size,
                        alignment: Alignment.center,
                        child:const AddTask()));
              },
            ),
          )
        : const Center(child:  Text('Giriş yapmış bir kullanıcı bulunamadı.'));
  }
}
