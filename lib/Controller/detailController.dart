import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:todoapp/db_class.dart';
import 'package:uuid/uuid.dart';
import '../detailClass.dart';
import '../home_page.dart';


class DetailController extends GetxController{

  var uuid = Uuid().v4().toString();
  TextEditingController titlec = TextEditingController();
  TextEditingController descrptionc = TextEditingController();
  TextEditingController priorityc = TextEditingController();
  TextEditingController dueDatec = TextEditingController();
  TextEditingController createdDatec = TextEditingController();
  TextEditingController search = TextEditingController();
  String selectedItem = "Creation Date";
  var date=DateTime.now().millisecondsSinceEpoch.obs;
  var time =TimeOfDay.now();
  List<String> item = ['High', 'Medium', 'Low'];
  List<String> itemSort = ['Creation Date', 'Due Date', 'Priority'];
  String selectedPriority = 'Medium';
  ToDoDetail? tooDo;
  var filterToDoList = <ToDoDetail>[].obs;
  var mainToDoList =  <ToDoDetail>[].obs;
  var searchText = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAllDetail();
    filterToDoList = mainToDoList;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }


  List<ToDoDetail> get filteredData {
    List<ToDoDetail> filterData = [];
    if (searchText.isEmpty) {
      filterData = mainToDoList;
    } else {
       var filterData1 = mainToDoList.where((element) => (element.title.toLowerCase()).contains(searchText.value.toLowerCase())).toList();
       filterData = filterData1;
    }
    return filterData;
  }

  void setSearchText(String text) {
    searchText.value = text;
  }

  addListToDoDetails() async {
    ToDoDetail todo = ToDoDetail(id: Uuid().v4().toString(),title: titlec.text, description:descrptionc.text, priority: selectedPriority.toString(), dueDate: date.value.toString(), createdDate: DateTime.now().millisecondsSinceEpoch.toString());
    final database = await $FloorToDoData.databaseBuilder('todoListDb.db').build();
    final todoListDao = database.detailDao;
    await todoListDao.insertDetail(todo);
    titlec.clear();
    descrptionc.clear();
    Get.back(result: [todo, false]);
  }

  getAllDetail()async{
    final database = await $FloorToDoData.databaseBuilder('todoListDb.db').build();
    final todoDao = database.detailDao;
    mainToDoList.addAll(await todoDao.getAllDetail());
    mainToDoList.sort((a,b) {
      return b.createdDate.compareTo(a.createdDate);
    });
  }

  updateDetails(ToDoDetail todoModel)async{
    final database = await $FloorToDoData.databaseBuilder('todoListDb.db').build();
    final todoDao = database.detailDao;
    final updatedTodoDetail  = ToDoDetail(id: todoModel.id,title: titlec.text, description:descrptionc.text, priority: selectedPriority.toString(), dueDate: date.value.toString(), createdDate: DateTime.now().millisecondsSinceEpoch.toString());
    await todoDao.updateDetail(updatedTodoDetail);
    Get.back(result: [updatedTodoDetail, false]);
  }

  deleteDetails()async{
    ToDoDetail todo = ToDoDetail(id: uuid.toString(),title: titlec.text, description:descrptionc.text, priority: selectedPriority.toString(), dueDate: date.value.toString(), createdDate: DateTime.now().millisecondsSinceEpoch.toString(), );
    final database = await $FloorToDoData.databaseBuilder('todoListDb.db').build();
    final todoDao = database.detailDao;
    await todoDao.deleteDetail(todo);
  }

   AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', 'High importance notification',
      description: 'This channel is used for importance notification',
      importance: Importance.high,
      showBadge: true,
      playSound: true
  );


  void showNotification(){
    flutterLocalNotificationsPlugin.show(
      0,
      titlec.text,
      descrptionc.text,
      NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id, channel.name,
            channelDescription: channel.description,
            importance: Importance.high,
            color: Colors.red,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          )
      ),
    );
  }

  selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(3000)
    );
    if(pickedDate !=null) {
      date.value = pickedDate.add(Duration(hours: TimeOfDay.now().hour,minutes: TimeOfDay.now().minute)).millisecondsSinceEpoch;
      print(time.toString());
      print('$date.value.toString()');
    }
  }
}