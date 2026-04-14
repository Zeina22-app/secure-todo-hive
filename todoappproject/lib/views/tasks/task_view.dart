import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:todoappproject/extensions/space_exs.dart';
import 'package:todoappproject/main.dart';
import 'package:todoappproject/models/task.dart';
import 'package:todoappproject/utils/app_colors.dart';
import 'package:todoappproject/utils/app_str.dart';
import 'package:todoappproject/utils/constants.dart';



class TaskView extends StatefulWidget {
  const TaskView({
    super.key,
    required this.titleTaskController,
    required this.descriptionTaskController,
    required this.task,
  });

  final TextEditingController? titleTaskController;
  final TextEditingController? descriptionTaskController;
  final Task? task;
  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subTitle;
  DateTime? time;
  DateTime? date;
  //Show selected time as a string format
  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat(
        'hh:mm a',
      ).format(widget.task!.createdAtTime).toString();
    }
  }

  //Show selected time as a string format
  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  //Show selected Date as a Dateformat for init Time
  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }
  bool isEditing() {
  return widget.task != null;
 }
  //if any Task already exist return true otherwise False
  // bool isTaskAlreadyExist() {
  //   if (widget.titleTaskController?.text == null &&
  //       widget.descriptionTaskController?.text == null) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
  void saveTask() {
    if (title == null || subTitle == null) {
      emptyFieldsWarning(context);
      return;
    }

    if (widget.task != null) {
      widget.task!.title = title;
      widget.task!.subTitle = subTitle;
      widget.task!.createdAtDate = date ?? widget.task!.createdAtDate;
      widget.task!.createdAtTime = time ?? widget.task!.createdAtTime;

      widget.task!.save();
      Navigator.pop(context);
    } else {
      final task = Task.create(
        title: title,
        subTitle: subTitle,
        createdAtDate: date,
        createdAtTime: time,
      );

      BaseWidget.of(context).dataStore.addTask(task: task);
      Navigator.pop(context);
    }
  }
  //Main function for creating or updating tasks
  // dynamic isTaskAlreadyExistUpdateOtherWiseCreate() {
  //   ///here we update the current task
  //   if (widget.titleTaskController?.text != null &&
  //       widget.descriptionTaskController?.text != null) {
  //     try {
  //       widget.titleTaskController?.text = title;
  //       widget.descriptionTaskController?.text = subTitle;
  //       widget.task?.save();
  //       Navigator.pop(context);
  //     } catch (e) {
  //       ///if user want to update  task but entered nothing we will show this warning
  //       updateTaskWarning(context);
  //     }

  //     ///here we create a new task
  //   } else {
  //     if (title != null && subTitle != null) {
  //       var task = Task.create(
  //         title: title,
  //         subTitle: subTitle,
  //         createdAtDate: date,
  //         createdAtTime: time,
  //       );

  //       ///we are adding this new task to hive db usig inherited widget
  //       BaseWidget.of(context).dataStore.addTask(task: task);
  //       Navigator.pop(context);
  //     } else {
  //       ///warning
  //       emptyFieldsWarning(context);
  //     }
  //   }
  // }

  ///Delete Task
  dynamic deleteTask(){
    return widget.task?.delete();
  }



  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        ///AppBar
        appBar: TaskViewAppBar(),

        ///Body
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ///Top Side Texts
                  _buildTopSideTexts(textTheme),
                  _buildMainTaskViewActivity(textTheme, context),
            
                  ///Bottom Side Buttons
                  _BuildBottomSideButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///Bottom Side Buttons
  Widget _BuildBottomSideButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: isEditing()
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          isEditing()
              ? Container()
              :
                ///Delete Current Task Button
                Container(
                  width: 150,
                  height: 55,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryColor, width: 2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      deleteTask();
                      Navigator.pop(context);
                    },
                    minWidth: 150,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: 55,
                    child: Row(
                      children: [
                        Icon(Icons.close, color: AppColors.primaryColor),
                        5.w,
                        Text(
                          AppStr.deleteTask,
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),

          ///Add or Update Task
          MaterialButton(
            onPressed: () {
              ///Add or Update Task Activity
              saveTask();
            },
            minWidth: 150,
            color: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            height: 55,
            child: Text(
              isEditing()
              ? AppStr.addTaskString
              : AppStr.updateTaskString,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  ///Main Task View Activity
  Widget _buildMainTaskViewActivity(TextTheme textTheme, BuildContext context) {
    return SizedBox(
      // width: double.infinity,
      // height: ,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text(
              AppStr.titleOfTitleTextField,
              style: textTheme.headlineMedium,
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal:16),
            child: ListTile(
              title: TextFormField(
                controller: widget.titleTaskController,
                maxLines: 6,
                cursorHeight: 60,
                style: TextStyle(
                  color: Colors.black
                ),
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
                onFieldSubmitted: (value){
                  title = value;
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: (value){
                  title = value;
                },
              ),
            ),
          ),

          SizedBox(
            height: 10,
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal:16),
            child: ListTile(
              title: TextFormField(
                controller: widget.descriptionTaskController,
                style: TextStyle(
                  color: Colors.black
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.bookmark_border,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  counter: Container(),
                  hintText: AppStr.addNote,
                ),
                onFieldSubmitted: (value){
                  subTitle = value;
                },
                onChanged: (value){
                  subTitle = value;
                },
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
              DatePicker.showTimePicker(context,
              showTitleActions: true,
              showSecondsColumn: false,
              onChanged: (_){},
              onConfirm: (selectedTime){
                setState(() {
                  if(widget.task?.createdAtTime == null){
                    time = selectedTime;
                  }
                  else{
                    widget.task?.createdAtTime = selectedTime;
                  }
                });
                FocusManager.instance.primaryFocus?.unfocus();
              },
              currentTime: showDateAsDateTime(time),
            );
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 10),
                    child: Text(
                      AppStr.timeString,
                      style: textTheme.headlineSmall,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 80,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100,
                    ),
                    child: Center(
                      child: Text(
                        showTime(time),
                        style: textTheme.titleSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),


          ///Date Picker
          GestureDetector(
            onTap: (){
              DatePicker.showDatePicker(context,
              showTitleActions: true,
              minTime: DateTime.now(),
              maxTime: DateTime(2030,3,5),
              onChanged: (_){},
              onConfirm: (selectedDate){
                setState(() {
                  if(widget.task?.createdAtDate == null){
                    date = selectedDate;
                  }
                  else{
                    widget.task!.createdAtDate = selectedDate;
                  }
                });
                FocusManager.instance.primaryFocus?.unfocus();
              },
              currentTime: showDateAsDateTime(date),
            );
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 10),
                    child: Text(
                      AppStr.dateString,
                      style: textTheme.headlineSmall,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 140,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade100,
                    ),
                    child: Center(
                      child: Text(
                        showDate(date),
                        style: textTheme.titleSmall,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ///Task Title
          // RepTextField(
          //   controller: widget.titleTaskController,
          //   onFieldSubmitted: (String inputTitle) {
          //     title = inputTitle;
          //   },
          //   onChanged: (String inputTitle) {
          //     title = inputTitle;
          //   },
          // ),
          // 10.h,
          // RepTextField(
          //   controller: widget.descriptionTaskController,
          //   isForDescription: true,
          //   onFieldSubmitted: (String inputSubTitle) {
          //     subTitle = inputSubTitle;
          //   },
          //   onChanged: (String inputSubTitle) {
          //     subTitle = inputSubTitle;
          //   },
          // ),

          ///Time Selection
          // DateTimeSelectionWidget(
          //   onTap: () {
          //     showModalBottomSheet(
          //       context: context,
          //       builder: (_) => SizedBox(
          //         height: 280,
          //         child: TimePickerWidget(
          //           initDateTime: showDateAsDateTime(time),
          //           onChange: (_, __) {},
          //           dateFormat: 'HH:mm',
          //           onConfirm: (dateTime, _) {
          //             setState(() {
          //               if (widget.task?.createdAtTime == null) {
          //                 time = dateTime;
          //               } else {
          //                 widget.task!.createdAtTime = dateTime;
          //               }
          //             });
          //           },
          //         ),
          //       ),
          //     );
          //   },
          //   title: AppStr.timeString,

          //   ///For testing
          //   time: showTime(time),
          // ),
          ///Date Selection
          // DateTimeSelectionWidget(
          //   onTap: () {
          //     DatePicker.showDatePicker(
          //       context,
          //       maxDateTime: DateTime(2030, 4, 5),
          //       minDateTime: DateTime.now(),
          //       initialDateTime: showDateAsDateTime(date),
          //       onConfirm: (dateTime, _) {
          //         setState(() {
          //           if (widget.task?.createdAtDate == null) {
          //             date = dateTime;
          //           } else {
          //             widget.task!.createdAtDate = dateTime;
          //           }
          //         });
          //       },
          //     );
          //   },
          //   title: AppStr.dateString,
          //   isTime: true,

          //   ///for testing
          //   time: showDate(date),
          // ),
        ],
      ),
    );
  }

  ///Top Side Text
  Widget _buildTopSideTexts(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ///Divider - grey
          SizedBox(width: 70, child: Divider(thickness: 2)),

          ///Later on according to the tasks condition we
          ///will decide to add new task "Add New Task" or "Update Current"
          ///tasks
          RichText(
            text: TextSpan(
              text: isEditing()
                  ? AppStr.addNewTask
                  : AppStr.updateCurrentTask,
              style: textTheme.titleLarge,
              children: [
                TextSpan(
                  text: AppStr.taskString,
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          SizedBox(width: 70, child: Divider(thickness: 2)),
        ],
      ),
    );
  }
}

class TaskViewAppBar extends StatelessWidget implements PreferredSizeWidget{
  const TaskViewAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios_new_rounded,size: 50,),
              ),
            ),
          ],
        ),
      ),
    );   
  }
  
  @override
  Size get preferredSize => Size.fromHeight(100);
}