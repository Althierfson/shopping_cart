import 'package:flutter/material.dart';

class CIcons {

  // Icon add new user
  static Widget get addNewUser => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: 100,
              height: 100,
              alignment: Alignment.center,
              child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(180),
                      border: Border.all()),
                  child: const Icon(Icons.add))),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text("Add new user"),
          )
        ],
      );
}
