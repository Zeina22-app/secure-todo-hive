import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoappproject/data/hive_data_store.dart';
import 'package:todoappproject/models/task.dart';
import 'package:todoappproject/views/home/home_view.dart';

Future<void> main() async {
  ///Init Hive DB before runApp

  await Hive.initFlutter();

  ///Register Hive Adapter
  Hive.registerAdapter<Task>(TaskAdapter());

  ///Open a box
  var box = await Hive.openBox<Task>("tasksBox");

  ///Delete data from previous day
  // ignore: avoid_function_literals_in_foreach_calls
  box.values.forEach(
    (task) {
      if(task.createdAtTime.day != DateTime.now().day) {
      task.delete();
    }
    else{
      ///do nothing
    }
  });
  runApp(BaseWidget(child: MyApp()));
}
///The inherited widget provides us with a convenient way 
///to pass data between widgets. While developing an app
///you will need some data from your parent's widget or
///grant parent widgets or beyond that.
class BaseWidget extends InheritedWidget{
  BaseWidget({Key? key, required this.child}):super(key: key, child: child);
  final HiveDataStore dataStore = HiveDataStore();
  final Widget child;

  static BaseWidget of(BuildContext context){
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if(base!=null){
      return base;
    }
    else{
      throw StateError('Could not find ancestor widget of type basewidget.');
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Hive Todo App',
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.black,
            fontSize: 45,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
          displayMedium: TextStyle(color: Colors.white, fontSize: 21),
          displaySmall: TextStyle(
            color: Color.fromARGB(255, 234, 234, 234),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          headlineMedium: TextStyle(color: Colors.grey, fontSize: 17),
          headlineSmall: TextStyle(color: Colors.grey, fontSize: 16),
          titleSmall: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          titleLarge: TextStyle(
            fontSize: 40,
            color: Colors.black,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      home: const HomeView(),
      //home: const TaskView(),
    );
  }
}


