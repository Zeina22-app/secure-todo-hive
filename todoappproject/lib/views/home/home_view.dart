import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todoappproject/extensions/space_exs.dart';
import 'package:todoappproject/main.dart';
import 'package:todoappproject/models/task.dart';
import 'package:todoappproject/utils/app_colors.dart';
import 'package:todoappproject/utils/app_str.dart';
import 'package:todoappproject/utils/constants.dart';
import 'package:todoappproject/views/home/widget/task_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:developer';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
// ignore: unused_import
import 'package:todoappproject/views/tasks/task_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> drawerkey = GlobalKey<SliderDrawerState>();

  //Check value of circle indicator
  dynamic valueOfIndicator(List<Task> task){
    if(task.isNotEmpty){
      return task.length;
    }else{
      return 3;
    }
  }

  //Check done tasks
  int checkDoneTask(List<Task> task){
    int i = 0;
    for(Task doneTask in task){
      if(doneTask.isCompleted){
        i++;
      }
    }
    return i;
  }
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final base = BaseWidget.of(context);
    return ValueListenableBuilder(
      valueListenable: base.dataStore.listenToTask(),
      builder: (ctx, Box<Task> box, Widget? child) {
        var tasks = box.values.toList();
        //for sorting list
        tasks.sort((a, b) => a.createdAtDate.compareTo(b.createdAtDate),);
        return Scaffold(
          backgroundColor: Colors.white,
          //FAB
          floatingActionButton: Fab(),

          ///Body
          body: SliderDrawer(
            key: drawerkey,
            isDraggable: false,
            animationDuration: 1000,

            ///Drawer
            slider: CustomDrawer(),
            //appBar:HomeAppBar(),
            ///Main Body
            appBar: const SizedBox.shrink(),
            child: Stack(
              children: [
                _buildHomeBody(textTheme, base, tasks),
                SafeArea(child: HomeAppBar(drawerkey: drawerkey)),
              ],
            ),
          ),
        );
      },
    );
  }

  ///Home Body
  Widget _buildHomeBody(TextTheme textTheme, BaseWidget base, List<Task> tasks) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          ///Custom App Bar
          Container(
            margin: const EdgeInsets.fromLTRB(55, 0, 0, 0),
            width: double.infinity,
            height: 130, 
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///Progress Indicator
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    value: checkDoneTask(tasks)/valueOfIndicator(tasks),
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
                  ),
                ),

                ///Space
                25.w,

                ///Top level Task info
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppStr.mainTitle, style: textTheme.displayLarge),
                    3.h,
                    Text("${checkDoneTask(tasks)} of ${tasks.length} task", style: textTheme.titleMedium),
                  ],
                ),
              ],
            ),
          ),

          ///Divider
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Divider(thickness: 2, indent: 100),
          ),

          ///Tasks
          Expanded(
            // width: double.infinity,
            // height: 745,
            child: tasks.isNotEmpty
                ///Task List is not empty
                ? ListView.builder(
                    itemCount: tasks.length,
                    physics: BouncingScrollPhysics(),
                    //scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      //Get a single task for showing in List
                      var task = tasks[index];
                      return Dismissible(
                        //key: ValueKey(item),
                        direction: DismissDirection.horizontal,
                        onDismissed: (_) {
                          base.dataStore.deleteTask(task: task);
                        },
                        background: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_outline, color: Colors.grey),
                            8.w,
                            Text(
                              AppStr.deletedTask,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        key: Key(task.id),
                        child: TaskWidget(
                          task: tasks[index],
                        ),
                      );
                    },
                  )
                ///Task List is empty
                : Builder(
                    builder: (context) {
                      print('🟢 EMPTY STATE BUILT');
                      print('List is empty: $tasks');

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ///Lottie Anime
                          FadeIn(
                            child: SizedBox(
                              width: 200,
                              height: 200,
                              child: Lottie.asset(
                                lottieURL,
                                animate: tasks.isNotEmpty ? false : true,
                              ),
                            ),
                          ),

                          ///sub Text
                          FadeInUp(from: 30, child: Text(AppStr.doneAllTask)),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

  ///Icons
  final List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill,
  ];

  ///text
  List<String> texts = ["Home", "Profile", "Settings", "Details"];

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 90),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradientColor,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              'https://avatars.githubusercontent.com/u/91388754?v=4',
            ),
          ),
          8.h,
          Text("Zeina", style: textTheme.displayMedium),
          Text("Flutter Dev", style: textTheme.displaySmall),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 30,horizontal: 10),
              child: ListView.builder(
                itemCount: icons.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: (){
                      log('${texts[index]} Item tapped');
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      child: ListTile(
                        leading: Icon(
                          icons[index],
                          color: Colors.white,
                          size: 30,
                        ),
                        title: Text(
                          texts[index],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key, required this.drawerkey});
  final GlobalKey<SliderDrawerState> drawerkey;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class _HomeAppBarState extends State<HomeAppBar>

    with SingleTickerProviderStateMixin {
  late AnimationController animateController;
  bool isDrawerOpen = false;

  @override
  void initState() {
    animateController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    super.initState();
  }

  @override
  void dispose() {
    animateController.dispose();
    super.dispose();
  }

  ///onToggle
  void onDrawerToggle() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if (isDrawerOpen) {
        animateController.forward();
        widget.drawerkey.currentState!.openSlider();
      } else {
        animateController.reverse();
        widget.drawerkey.currentState!.closeSlider();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var base = BaseWidget.of(context).dataStore.box;
    return SizedBox(
      width: double.infinity,
      height: 130,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ///Menu icon
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: IconButton(
                onPressed: onDrawerToggle,
                icon: AnimatedIcon(
                  icon: AnimatedIcons.menu_close,
                  progress: animateController,
                  size: 40,
                  color: Colors.black,
                ),
              ),
            ),

            ///Trash icon
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () {
                  ///We will remove all the task from the DB with this button onpressed activity
                  base.isEmpty
                      ? noTaskWarning(context)
                      : deleteAllTask(context);
                },
                icon: Icon(
                  CupertinoIcons.trash_fill,
                  size: 40,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Fab extends StatelessWidget {
  const Fab({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => TaskView(
              titleTaskController: TextEditingController(),
              descriptionTaskController: TextEditingController(),
              task: null,
            ),
          ),
        );
      },
      child: Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 10,
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(child: Icon(Icons.add, color: Colors.white)),
        ),
      ),
    );
  }
}
