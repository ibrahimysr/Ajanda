import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yonetici_paneli/service/task_service.dart';
import 'package:yonetici_paneli/service/user_service.dart';
import 'package:yonetici_paneli/style/database_color.dart';
import 'package:yonetici_paneli/style/style.dart';
import 'package:yonetici_paneli/widgets/add_task_textfield.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController taskName = TextEditingController();
  TextEditingController taskDate = TextEditingController();
  TextEditingController taskDetail = TextEditingController();
  TextEditingController taskDeadline = TextEditingController();
  TextEditingController taskDeadlineTime = TextEditingController();
  final ValueNotifier<String> selectedTaskType = ValueNotifier<String>('Görev');

  static String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void getTaskDate() {
    DateTime now = DateTime.now();
    taskDate.text =
        "${now.toLocal().toString().split(' ')[0]} ${_formatTime(TimeOfDay(hour: now.hour, minute: now.minute))}";
    taskDeadline.clear();
  }

  static Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      controller.text = pickedDate.toLocal().toString().split(' ')[0];
    }
  }

  static Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      controller.text = _formatTime(pickedTime);
    }
  }

  static void clearControllers(List<TextEditingController> controllers) {
    for (var controller in controllers) {
      controller.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    getTaskDate();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;
    final taskService = Provider.of<TaskService>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff0f0fa),
      appBar: AppBar(
        backgroundColor: const Color(0xfff0f0fa),
        elevation: 0,
        title: Text(
          'Kayıt Ekle',
          style: AppStyle.mainTitle.copyWith(fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Başlık',
              style: AppStyle.mainTitle.copyWith(fontSize: 16),
            ),
            addTaskTextfield('Title', taskName, 'Başlık', 1, context),
            Text(
              'Detay',
              style: AppStyle.mainTitle.copyWith(fontSize: 16),
            ),
            addTaskTextfield2('Detay', taskDetail, 'Detay Giriniz', 3, context),
            Text(
              'Başlangıç Tarihi',
              style: AppStyle.mainTitle.copyWith(fontSize: 16),
            ),
            addTaskTextfield(
                'Başlangıç Tarihi', taskDate, 'Başlık', 1, context),
            Text(
              'Bitiş Tarihi',
              style: AppStyle.mainTitle.copyWith(fontSize: 15),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextField(
                            onTap: () async {
                              await _selectDate(context, taskDeadline);
                            },
                            style: const TextStyle(color: textColor),
                            controller: taskDeadline,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                fillColor: Color(0xff282C34),
                                hintText: "Tarih",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextField(
                            onTap: () async {
                              await _selectTime(context, taskDeadlineTime);
                            },
                            style: const TextStyle(color: textColor),
                            controller: taskDeadlineTime,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                fillColor: Color(0xff282C34),
                                hintText: "Saat",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              'Kategori',
              style: AppStyle.mainTitle.copyWith(fontSize: 15),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: ValueListenableBuilder<String>(
                  valueListenable: selectedTaskType,
                  builder: (context, value, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedTaskType.value,
                          dropdownColor: Colors.white,
                          style: const TextStyle(color: Colors.black),
                          items: <String>['Not', 'Toplantı', 'Görev']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 15),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedTaskType.value = newValue!;
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: textColor),
                onPressed: () async {
                  if (taskName.text.isEmpty ||
                      taskDate.text.isEmpty ||
                      taskDetail.text.isEmpty ||
                      taskDeadline.text.isEmpty ||
                      taskDeadlineTime.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: appcolor,
                        title: Text(
                          "Eksik Bilgi!",
                          style: AppStyle.mainContent,
                        ),
                        content: Text(
                          "Lütfen tüm alanları doldurun.",
                          style: AppStyle.mainContent,
                        ),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: textColor,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Tamam",
                              style: AppStyle.mainContent.copyWith(
                                color: appcolor2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    await taskService.addTask(
                        context,
                        currentUser!,
                        taskName.text,
                        taskDate.text,
                        taskDetail.text,
                        "${taskDeadline.text} ${taskDeadlineTime.text}",
                        selectedTaskType.value);

                    Navigator.pop(context);
                    clearControllers([
                      taskName,
                      taskDate,
                      taskDetail,
                      taskDeadline,
                      taskDeadlineTime
                    ]);
                  }
                },
                child: const Text(
                  "Kaydet",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
