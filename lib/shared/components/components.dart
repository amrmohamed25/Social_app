import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

Widget defaultButton(
    {bool isUpper = true,
    Color color = Colors.blue,
    double width = double.infinity,
    double radius = 0.0,
    required String text,
    required VoidCallback function}) {
  return Container(
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    ),
    height: 50,
    width: width,
    child: MaterialButton(
        child: Text(
          isUpper ? text.toUpperCase() : text,
          style: TextStyle(fontSize: 20),
        ),
        textColor: Colors.white,
        onPressed: function),
  );
}

Widget defaultFormField(
    {required controller,
    required label,
    required keyType,
    required validate,
    required prefix,
    isPassword = false,
    suffix,
    function,
    onsubmit,
    onchange,
    readOnly: false,
    onTap}) {
  return TextFormField(
    onTap: onTap,
    readOnly: readOnly,
    onFieldSubmitted: onsubmit,
    onChanged: onchange,
    keyboardType: keyType,
    controller: controller,
    decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(prefix),
        suffixIcon: suffix == null
            ? null
            : IconButton(
                onPressed: function,
                icon: Icon(suffix),
              )),
    validator: validate,
    obscureText: isPassword,
  );
}

void navigateTo(context, widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void navigateAndReplace(context, widget) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false);
}

void buildToast({required String? message, required ToastStates state}) {
  Fluttertoast.showToast(
      msg: "$message",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: getToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0);
}

enum ToastStates { SUCCESS, ERROR, WARNING }

Color getToastColor(ToastStates toastState) {
  Color color;
  switch (toastState) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.WARNING:
      color = Colors.yellow;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
  }
  return color;
}

PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  String title = '',
  List<Widget>? actions,
}) {
  return AppBar(
    title: Text(title),
    leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(IconBroken.Arrow___Left_2)),
    actions: actions,
    titleSpacing: 5,
  );
}
