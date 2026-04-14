import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoappproject/models/task.dart';
import 'package:todoappproject/utils/app_colors.dart';
import 'package:todoappproject/views/tasks/task_view.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({super.key, required this.task});
  final Task task;
  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  TextEditingController textEditingControllerForTitle = TextEditingController();
  TextEditingController textEditingControllerForSubTitle =
      TextEditingController();

  @override
  void initState() {
    textEditingControllerForTitle.text = widget.task.title;
    textEditingControllerForSubTitle.text = widget.task.subTitle;
    super.initState();
  }

  @override
  void dispose() {
    textEditingControllerForTitle.dispose();
    textEditingControllerForSubTitle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Here 
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (ctx) => TaskView(
              titleTaskController: textEditingControllerForTitle,
              descriptionTaskController: textEditingControllerForSubTitle,
              task: widget.task,
            ),
          ),
        );
      },

      ///Main Card
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          //color: AppColors.primaryColor.withOpacity(0.1),
          color: widget.task.isCompleted
              ? const Color.fromARGB(154, 119, 144, 229)
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: ListTile(
          ///Check icon
          leading: GestureDetector(
            onTap: () {
              ///Check or uncheck the task
              widget.task.isCompleted = !widget.task.isCompleted;
              widget.task.save();
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 600),
              // height: 24,
              // width: 24,
              decoration: BoxDecoration(
                color: widget.task.isCompleted
                    ? AppColors.primaryColor
                    : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 0.8),
              ),
              child: Icon(Icons.check, color: Colors.white),
            ),
          ),

          ///Task Title
          title: Padding(
            padding: const EdgeInsets.only(bottom: 5.0, top: 3),
            child: Text(
              textEditingControllerForTitle.text,
              style: TextStyle(
                color: widget.task.isCompleted
                    ? AppColors.primaryColor
                    : Colors.black,
                fontWeight: FontWeight.w500,
                decoration: widget.task.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
          ),

          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Task Description
              Text(
                textEditingControllerForSubTitle.text,
                style: TextStyle(
                  color: widget.task.isCompleted
                      ? AppColors.primaryColor
                      : Colors.black,
                  fontWeight: FontWeight.w300,
                  decoration: widget.task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),

              ///Date and Time of Task
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('hh:mm a').format(widget.task.createdAtTime),
                        style: TextStyle(
                          fontSize: 14,
                          color: widget.task.isCompleted
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                      Text(
                        DateFormat.yMMMEd().format(widget.task.createdAtDate),
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.task.isCompleted
                              ? Colors.white
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
