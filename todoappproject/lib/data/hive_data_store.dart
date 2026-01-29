import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todoappproject/models/task.dart';

///All the [CRUD] opeartion methods
class HiveDataStore{
  ///Box Name - String
  static const boxName = 'taskBox';

  ///Our current Box with all the saved data inside - Box<Task>
  final Box<Task> box = Hive.box<Task>(boxName);

  ///Add new Task to Box 
  Future<void> addTask({required Task task})async{
    await box.put(task.id, task);
  }

  ///Show Task
  Future <Task?> getTask({required String id}) async{
    return box.get(id);
  }

  ///Update Task
  Future<void> updateTask({required Task task}) async{
    await task.save();
  }


  ///Delete Task
  Future<void> deleteTask({required Task task}) async{
    await task.delete();
  }
  

  ///Listen to box Changes
  //////using this method we will listen to box changes and update the
  ///UI accordingly
  ValueListenable<Box<Task>> listenToTask() => box.listenable();

} 