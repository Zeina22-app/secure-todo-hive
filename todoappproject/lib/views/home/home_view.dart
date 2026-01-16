import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:todoappproject/extensions/space_exs.dart';
import 'package:todoappproject/utils/app_colors.dart';
import 'package:todoappproject/utils/app_str.dart';
import 'package:todoappproject/utils/constants.dart';
import 'package:todoappproject/views/home/components/fab.dart';
import 'package:todoappproject/views/home/components/home_app_bar.dart';
import 'package:todoappproject/views/home/widget/task_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';

import 'components/slider_drawer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> drawerkey = GlobalKey<SliderDrawerState>();
  final List<int> testing = [];
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
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
            _buildHomeBody(textTheme),
            SafeArea(child: HomeAppBar(drawerkey: drawerkey)),
          ],
        ),
      ),
    );
  }

  ///Home Body
  Widget _buildHomeBody(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          ///Custom App Bar
          SizedBox(
            //margin: EdgeInsets.only(top: 60),
            width: double.infinity,
            height: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ///Progress Indicator
                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    value: 1 / 3,
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
                    Text("1 of 3 task", style: textTheme.titleMedium),
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
            child: testing.isNotEmpty
                ///Task List is not empty
                ? ListView.builder(
                    itemCount: testing.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final item = testing[index];
                      return Dismissible(
                        key: ValueKey(item),
                        direction: DismissDirection.horizontal,
                        onDismissed: (_) {
                          ///we will remove current task from DB.
                          setState(() {
                            testing.remove(item);
                          });
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
                        //key: Key(index.toString()),
                        child: TaskWidget(),
                      );
                    },
                  )
                ///Task List is empty
                : Builder(
                    builder: (context) {
                      print('🟢 EMPTY STATE BUILT');
                      print('List is empty: $testing');

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
                                animate: testing.isNotEmpty ? false : true,
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
