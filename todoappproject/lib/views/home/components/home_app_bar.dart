import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key, required this.drawerkey});
  final GlobalKey<SliderDrawerState> drawerkey;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> with SingleTickerProviderStateMixin {
  late AnimationController animateController;
  bool isDrawerOpen =  false;

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
  void onDrawerToggle(){
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if (isDrawerOpen){
        animateController.forward();
        widget.drawerkey.currentState!.openSlider();
      }
      else{
        animateController.reverse();
        widget.drawerkey.currentState!.closeSlider();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 130,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                onPressed: (){
                  ///We will remove all the task from the DB with this button onpressed activity
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