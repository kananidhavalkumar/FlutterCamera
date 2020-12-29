// import 'package:flutter/material.dart';

// class RouteGenerator {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     final args = settings.arguments;
//     switch (settings.name) {
//       case '/':
//         return MaterialPageRoute(builder: (_) => Home());
//       case '/about':
//         if (args is String) {
//           return MaterialPageRoute(builder: (_) => About(data: args));
//         }
//         return MaterialPageRoute(
//             builder: (context) => Scaffold(
//                   appBar: AppBar(
//                     title: Text("error"),
//                   ),
//                 ));

//       default:
//         return MaterialPageRoute(
//             builder: (context) => Scaffold(
//                   appBar: AppBar(
//                     title: Text("error"),
//                   ),
//                 ));
//     }
//   }
// }
