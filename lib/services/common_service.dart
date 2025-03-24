import 'package:flutter/material.dart';

class CommonService{
  static showCustomDialog(dynamic context, String title, String message){
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Ok"))
          ],
        ));
  }
}