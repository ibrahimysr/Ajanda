import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yonetici_paneli/pages/Home/add_task.dart';
import 'package:yonetici_paneli/service/user_service.dart';
import 'package:yonetici_paneli/style/database_color.dart';
import 'package:yonetici_paneli/style/style.dart';
import 'package:yonetici_paneli/widgets/category_text.dart';
import 'package:yonetici_paneli/widgets/stream_builder.dart';

class FinishTaskPage extends StatefulWidget {
  const FinishTaskPage({super.key});

  @override
  State<FinishTaskPage> createState() => _FinishTaskPageState();
}

class _FinishTaskPageState extends State<FinishTaskPage> {
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
                    check: true,
                  ),
                ),
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
                    MaterialPageRoute(
                      builder: (context) => const AddTask(),
                    ));
              },
            ),
          )
        : const Text('Giriş yapmış bir kullanıcı bulunamadı.');
  }
}
