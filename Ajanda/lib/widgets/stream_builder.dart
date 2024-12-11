import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:yonetici_paneli/pages/Home/detail_page.dart';
import 'package:yonetici_paneli/service/task_service.dart';
import 'package:yonetici_paneli/service/user_service.dart';
import 'package:yonetici_paneli/style/database_color.dart';
import 'package:yonetici_paneli/style/style.dart';
import 'package:yonetici_paneli/widgets/animated_check.dart';

class MyStreamBuilder extends StatelessWidget {
  final String selectedCategory;
  final String deleteCategory;
  final String searchText;
  final bool showPastDue;
  final bool check;

  const MyStreamBuilder({
    super.key,
    required this.selectedCategory,
    required this.deleteCategory,
    required this.searchText,
    required this.showPastDue,
    required this.check,
  });

  String getTruncatedText(String text) {
    if (text.isNotEmpty && text.length > 60) {
      return '${text.substring(0, 60)}...';
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final taskService = Provider.of<TaskService>(context);

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: taskService.getTasksStream(
        userProvider.currentUser!,
        selectedCategory,
        showPastDue,
        check,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Hata: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Bir Bilgi Bulunamadı"));
        } else {
          List<Map<String, dynamic>> tasks = snapshot.data!;
          List<Map<String, dynamic>> filteredTasks =
              taskService.searchTasks(tasks, searchText);
          filteredTasks = filteredTasks.reversed.toList();
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio:
                  2.75 / 2.5, 
            ),
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> task = filteredTasks[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.size,
                        alignment: Alignment.center,
                        child: DetailPage(
                          task: task,
                          selectCategory: selectedCategory,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: DatabaseStyle.cardsColor[task["color_id"]],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task["bitis_tarihi"].toString().split(' ')[0],
                            style: AppStyle.mainContent.copyWith(
                              fontSize: 14,
                              color: appcolor2,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            task["adı"],
                            style: AppStyle.mainTitle.copyWith(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            getTruncatedText(task["açıklama"] ?? ''),
                            style: AppStyle.mainContent.copyWith(
                              fontSize: 14,
                              color: appcolor2,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Center(
                                      child: AlertDialog(
                                        backgroundColor: appcolor,
                                        title: Text("Silmek istiyor musunuz?",
                                            style: AppStyle.mainContent),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.red),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "İptal",
                                                      style: AppStyle
                                                          .mainContent
                                                          .copyWith(
                                                              fontSize: 15,
                                                              color: appcolor),
                                                    )),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.green),
                                                    onPressed: () async {
                                                      taskService.deleteTask(
                                                        context,
                                                        userProvider
                                                            .currentUser!,
                                                        task,
                                                        deleteCategory,
                                                      );

                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "Evet",
                                                      style: AppStyle
                                                          .mainContent
                                                          .copyWith(
                                                              fontSize: 15,
                                                              color: appcolor),
                                                    ))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.delete,
                                    color: tdRed),
                              ),
                              IconButton(
                                onPressed: () async {
                                  taskService.completeTask(
                                    context,
                                    userProvider.currentUser!,
                                    task,
                                    selectedCategory,
                                    check,
                                  );
                                  showDialog(
                                    context: context,
                                    builder: (context) => const Center(
                                      child: AnimatedCheckIcon(
                                        title: 'check',
                                      ),
                                    ),
                                  );
                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  check
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank_outlined,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
