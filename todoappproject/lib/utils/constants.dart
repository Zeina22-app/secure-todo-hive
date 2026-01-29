import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
//import 'package:todoappproject/main.dart';
import 'package:todoappproject/utils/app_str.dart';


String lottieURL = 'assets/lottie/1.json';


///Empty title or subtitle textfield warning
dynamic emptyWarning(BuildContext context){
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: 'You must fill all fields!',
    corner: 20.0,
    duration: 2000,
    padding: EdgeInsets.all(20),
  );
}


///Nothing entered when user try to edit or update the current task
dynamic updateTaskWarning(BuildContext context){
  return FToast.toast(
    context,
    msg: AppStr.oopsMsg,
    subMsg: 'You must edit the tasks then try to update it!',
    corner: 20.0,
    duration: 5000,
    padding: EdgeInsets.all(20),
  );
}

///No task warning for dialog for deleting
dynamic noTaskWarning(BuildContext context){
  return PanaraInfoDialog.showAnimatedGrow(
    context,
    title: AppStr.oopsMsg,
    message: "There is no task for delete!\n Try adding some and the try to delete it",
    buttonText: "Okay",
    onTapDismiss: (){
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.warning,
  );
}

///Delete all tasks from DB Dialog
dynamic deleteAllTask(BuildContext context){
  return PanaraConfirmDialog.show(
    context,
    title: AppStr.areYouSure,
    message: "Do you really want to delete all Tasks? You will not be able to undo this action!",
    confirmButtonText: 'Yes',
    cancelButtonText: 'No', 
    onTapConfirm: (){
      ///We will clear all the box data using this command later on
      //BaseWidget.of(context).dataStore.box.clear();
      Navigator.pop(context);
    }, 
    onTapCancel: (){
      Navigator.pop(context);
    }, 
    panaraDialogType: PanaraDialogType.error,
    barrierDismissible: false,
  );
}