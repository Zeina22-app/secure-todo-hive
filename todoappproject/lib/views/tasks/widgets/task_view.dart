import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:todoappproject/extensions/space_exs.dart';
import 'package:todoappproject/utils/app_colors.dart';
import 'package:todoappproject/utils/app_str.dart';
import 'package:todoappproject/views/tasks/components/date_time_selection.dart';
import 'package:todoappproject/views/tasks/components/rep_textfield.dart';
import 'package:todoappproject/views/tasks/widgets/task_view_app_bar.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final TextEditingController titleTaskController = TextEditingController();
  final TextEditingController descriptionTaskController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        ///AppBar
        appBar: TaskViewAppBar(),

        ///Body
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
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
    );
  }
  ///Bottom Side Buttons
  Widget _BuildBottomSideButtons() {
    return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ///Delete Current Task Button
                    MaterialButton(
                      onPressed: (){
                        log("current Task has been deleted!");
                      },
                      minWidth: 150,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 55,
                      child: Row(
                        children: [
                          Icon(
                            Icons.close,
                            color: AppColors.primaryColor,
                          ),
                          5.w,
                          Text(
                            AppStr.deleteTask,
                            style: TextStyle(
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ///Add or Update Task
                      MaterialButton(
                      onPressed: (){
                         ///Add or Update Task Activity
                         print("New Task has been added!");
                      },
                      minWidth: 150,
                      color: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 55,
                      child: Text(
                        AppStr.addTaskString,
                        style: TextStyle(
                          color: Colors.white,
                        ),
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

                    ///Task Title
                    RepTextField(controller: titleTaskController),
                    10.h,
                    RepTextField(
                      controller: descriptionTaskController,
                      isForDescription: true,
                    ),

                    ///Time Selection
                    DateTimeSelectionWidget(
                      onTap: () {
                        () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => SizedBox(
                              height: 280,
                              child: TimePickerWidget(
                                //initDateTime: ,
                                onChange: (_, __) {},
                                dateFormat: 'HH:mm',
                                onConfirm: (dateTime, _) {
                                  ///This part will be completed next.
                                },
                              ),
                            ),
                          );
                        };
                      },
                      title: AppStr.timeString,
                    ),

                    ///Time Selection
                    DateTimeSelectionWidget(
                      onTap: () {
                        DatePicker.showDatePicker(
                          context,
                          maxDateTime: DateTime(2030,4,5),
                          minDateTime: DateTime.now(),
                          ///Initial DateTime:
                          onConfirm: (dateTime,_){
                            ///will be completed later
                          },
                        );
                      },
                      title: AppStr.dateString,
                    ),

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
              text: AppStr.addNewTask,
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

