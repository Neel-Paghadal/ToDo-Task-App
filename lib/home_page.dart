

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'Controller/detailController.dart';
import 'detailForm.dart';





final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final DetailController detailsController = Get.put(DetailController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE5F2FA),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff00384E),
        onPressed: () async {
          var response = await Get.to(()=>const DetailForm());
          if(response != null){
            setState(() {
              if(detailsController.search.text.isEmpty) {
                detailsController.filteredData.add(response[0]);
              } else {
                detailsController.filteredData.add(response[0]);
                detailsController.mainToDoList.add(response[0]);
              }
                detailsController.filteredData.sort((a,b) {
                  return b.createdDate.compareTo(a.createdDate);
                });
            });
          }
        },
        child: const Icon(Icons.add,color: Colors.white,),
      ),
      appBar: AppBar(
        title: const Text("Todo List",style: TextStyle(
          color: Colors.white
        ),),
        actions: [

          Flexible(
            child: DropdownButton(
              dropdownColor: const Color(0xff00384E),
              alignment: Alignment.bottomRight,
              borderRadius: BorderRadius.circular(20),
              underline: Container(),
              icon: const Icon(
                Icons.arrow_drop_down,
                size: 30,
              ),
              iconEnabledColor: Colors.white,
              // isExpanded: true,
              value: detailsController.selectedItem,
              hint: Text(detailsController.selectedItem.toString(),style: const TextStyle(color: Colors.white)),

              onChanged: (newValue) {
                setState(() {
                  detailsController.selectedItem = newValue!;
                  if (newValue == "Creation Date") {
                    createDateSort();
                  } else if (newValue == "Due Date") {
                    dueDateSort();
                  } else if (newValue == "Priority") {
                    priorityDateSort();
                  }
                });
                print(detailsController.selectedItem);
              },
              items: detailsController.itemSort.map((sort) {
                return DropdownMenuItem(
                  value: sort,
                  child: Text(sort,style:  const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500
                        ),),
                );
              }
              ).toList(),
            ),
          ),
        ],
        backgroundColor: const Color(0xff00384E),
      ),




      body: Obx(()=>
          Column(
            children: [
              Padding(
                padding:  const EdgeInsets.only(top: 8,right: 13,left: 13,bottom: 10),
                child: CupertinoSearchTextField(
                  controller: detailsController.search,
                  onChanged: (value){
                    detailsController.setSearchText(value);
                  },
                ),
              ),

              if (detailsController.filteredData.isEmpty) const Align(
                alignment: Alignment.center,
                child: Text("No Record Found",textAlign: TextAlign.center,),
              ) else Expanded(
                      child: ListView.builder(
                           scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: detailsController.filteredData.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: ()async{
                                  var response = await Get.to(()=>const DetailForm(), arguments: [
                                      {"TodoData": detailsController.filteredData[index]},
                                      ]);

                                  if(response != null) {
                                    setState(() {
                                     var response1 = response[0];
                                      int index = detailsController.filteredData.indexWhere((element) => element.id == response1.id);
                                      int indexMain = detailsController.mainToDoList.indexWhere((element) => element.id == response1.id);
                                      if (response[1] == true){
                                        detailsController.mainToDoList.removeAt(indexMain);
                                        detailsController.filteredData.removeAt(index);
                                      } else {
                                        detailsController.mainToDoList[indexMain] = response[0];
                                        detailsController.filteredData[index] = response[0];
                                      }
                                      // response.removeWhere((item) => item.id == response);
                                      detailsController.filteredData.sort((a, b) {
                                        return b.createdDate.compareTo(a.createdDate);
                                      });
                                    });
                                  }
                                },
                                child: Card(
                                  shape:  const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.horizontal()
                                  ),
                                  color:  const Color(0xffFFFFFF),

                                  child:
                                  ListTile(
                                    subtitle: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(detailsController.filteredData[index].description,style: const TextStyle(color: Colors.black),overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,),
                                    ),
                                      title: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:  const EdgeInsets.all(8.0),
                                                    child: Align(
                                                        alignment : Alignment.topLeft,
                                                        child: Text(detailsController.filteredData[index].title,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,textAlign: TextAlign.start,)),
                                                  ),
                                                ],
                                              ),


                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Row(

                                                  children: [
                                                    Text('Due - ' + DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(int.parse(detailsController.filteredData[index].dueDate)))),
                                                    (detailsController.filteredData[index].priority.toString() == 'High') ?
                                                    const Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Image(image: AssetImage("asset/image/highest.png"),),
                                                    )
                                                        :
                                                    (detailsController.filteredData[index].priority.toString() == 'Medium') ?
                                                    const Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Image(image: AssetImage("asset/image/medium.png"),),
                                                    ) :
                                                    const Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: Image(image: AssetImage("asset/image/low.png"),),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                    ),
                                ),
                              );
                            },
                          ),
                    ),
            ],
          )
      ),
    );
  }

  createDateSort() {
    setState(() {
      detailsController.mainToDoList.sort((a, b) {
        return b.createdDate.compareTo(a.createdDate);
      });
    });
  }

  dueDateSort() {
    setState(() {
      detailsController.mainToDoList.sort((a, b) {
        return b.dueDate.compareTo(a.dueDate);
      });
    });
  }

  priorityDateSort() {
    setState(() {
      detailsController.mainToDoList.sort((a, b) {
        return b.priority.compareTo(a.priority);
      });
    });
  }
}

