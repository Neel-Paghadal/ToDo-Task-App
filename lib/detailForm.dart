
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/detailClass.dart';
import 'Controller/detailController.dart';

class DetailForm extends StatefulWidget {
  const DetailForm({Key? key}) : super(key: key);

  @override
  State<DetailForm> createState() => _DetailFormState();
}

class _DetailFormState extends State<DetailForm> {

  final DetailController detailsController = Get.put(DetailController());
  GlobalKey<FormState> valkey = GlobalKey();

  dynamic argumentData = Get.arguments;
  ToDoDetail? todoData;
  bool isEditable = true;
  bool isDoneVisible = true;
  bool isEditVisible = false;
  bool isDeleteVisible = false;
  bool isItemDeleted = false;
  @override
  void initState() {
    super.initState();
    if (argumentData != null) {
      todoData = argumentData[0]['TodoData'];
      detailsController.uuid = todoData!.id;
      detailsController.titlec.text = todoData!.title;
      detailsController.descrptionc.text = todoData!.description;
      detailsController.selectedPriority = todoData!.priority;
      detailsController.dueDatec.text = todoData!.dueDate;
      detailsController.createdDatec.text = todoData!.createdDate;
    } else {
      detailsController.uuid = "";
      detailsController.titlec.clear();
      detailsController.descrptionc.clear();
      detailsController.dueDatec.clear();
      detailsController.createdDatec.clear();
    }


    if (todoData == null){
      isEditable = false;
      isDoneVisible = true;
      isEditVisible = false;
      isDeleteVisible = false;
    } else {
      isEditable = true;
      isDoneVisible = false;
      isEditVisible = true;
      isDeleteVisible = true;
    }

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5F2FA),
      appBar: AppBar(
        title: Text(todoData == null ? "Add New Task" : todoData!.title.toString(),style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xff00384E),
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,color: Colors.white,
          ),
        ),
        actions: [
            Visibility(
              visible: isDoneVisible,
              child: IconButton(
                onPressed: () {
                  if (valkey.currentState!.validate()) {
                    if(todoData == null) {
                      detailsController.showNotification();
                      detailsController.addListToDoDetails();
                    }else{
                      // detailsController.showNotification();
                      detailsController.updateDetails(todoData!);
                    }
                  } else {
                    Get.snackbar('Enter Valid Data', '');
                  }
                },
                icon: const Icon(Icons.done_outline_outlined,color: Colors.white,)
            ),),

          Visibility(
            visible: isEditVisible,
            child: IconButton(
              onPressed: (){
                setState(() {
                  isEditable = false;
                  isDoneVisible = true;
                  isEditVisible = false;
                });
              },
              icon: const Icon(Icons.edit,color: Colors.white,)
          ),),

          Visibility(
              visible: isDeleteVisible,
            child: IconButton(
              onPressed: ()async{

                Get.defaultDialog(
                  backgroundColor: Colors.white,
                  radius: 10,

                  title: '', titleStyle: const TextStyle(fontSize: 0),
                  content: Column(

                      children:  [
                        const Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Are you sure you want to delete this action?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)),
                        ),

                        const Padding(
                          padding: EdgeInsets.only(left: 10, top: 15),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("This will delete this task permanently. \nYou cannot undo this action.", style: TextStyle(fontWeight: FontWeight.normal))),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              Padding(
                                padding:  EdgeInsets.only(left: 15.0,top: 25, right: 15,bottom: 0),
                                child: Container(
                                  height : 45,
                                  width : 100,
                                  child: ElevatedButton(

                                    onPressed: (){
                                      Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),side: BorderSide(color: Colors.black)),
                                        backgroundColor: Colors.white

                                    ),
                                    child: const Text("No", style: TextStyle(color: Colors.black)),
                                  ),
                                ),

                              ),

                              Padding(
                                padding:  EdgeInsets.only(left: 0.0,top: 25, right: 15,bottom: 0),
                                child: Container(
                                  height : 45,
                                  width : 100,
                                  child: ElevatedButton(
                                      onPressed: (){
                                        isItemDeleted = true;
                                        detailsController.deleteDetails();
                                        Navigator.of(context).pop();
                                        Get.back(result: [todoData, true]);
                                      },
                                        style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),side: BorderSide(color: Colors.black)),
                                        backgroundColor: Colors.red
                                    ),
                                      child: const Text("Yes", style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                );

              },
              icon: const Icon(Icons.delete,color: Colors.white,)
          ),)
        ],
      ),
      body: Obx(()=>
         AbsorbPointer(
           absorbing: isEditable,
           child: Form(
             key: valkey,
             child: Column(

              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0,left: 13,right: 13),
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: detailsController.titlec,
                      decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff00384E),
                              )
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Task Name",
                          hintText: "Title",
                          prefixIcon: Icon(Icons.person,color: Colors.black,),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15.0)))),
                      validator: (myvalue){
                        if(myvalue!.isEmpty){
                          return "Title is requried";
                        }else{
                          return null;
                        }
                      },
                      ),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.only(top: 15,left: 13,right: 13),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: detailsController.descrptionc,
                    maxLines: 4,
                    minLines: 3,
                    decoration: const InputDecoration(

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff00384E),
                          )
                      ),

                      fillColor: Colors.white,
                      hintText: "Description",
                      labelText: "Task Description",
                      filled: true,
                    ),
                    validator: (myvalue){
                      if(myvalue!.isEmpty){
                        return "Descrption is requried";
                      }else{
                        return null;
                      }
                    },
                  ),
                ),


                const Padding(
                  padding: EdgeInsets.only(top: 10,left: 15),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text("Priority : ",style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8,bottom: 08,left: 13,right: 13),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0,left: 10),
                        child: DropdownButton(
                          alignment: Alignment.bottomRight,
                          borderRadius: BorderRadius.circular(20),
                          underline: Container(),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            size: 40,
                          ),
                          iconEnabledColor: Colors.black,
                          isExpanded: true,
                          hint: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(detailsController.selectedPriority.toString()),
                          ), // Not necessary for Option 1
                          value: detailsController.selectedPriority,

                          onChanged: (newValue) {
                            setState(() {
                              detailsController.selectedPriority = newValue!;
                            });
                            print(detailsController.selectedPriority);
                          },
                          items: detailsController.item.map((location) {
                            return DropdownMenuItem(

                              value: location,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(location,style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500
                                  ),),
                                ],
                              ),
                            );
                          }
                          ).toList(),
                        ),
                      ),
                    ),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(right: 10,left: 10),
                  child: GestureDetector(
                    onTap: (){
                      detailsController.selectDate();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left:5.0),
                          child: Text("Due Date : ",style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),),
                        ),

                        Card(
                          color: Colors.white,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 12,left: 12),
                                child: Text(
                                  DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(detailsController.date.value)) ,
                                  style: const TextStyle(
                                  fontSize: 14
                                ),),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Icon(Icons.calendar_month),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
             ),
           ),
         ),
      ),
    );
  }
}
