// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import './common/error_dialog.dart';
// import '../providers/auth.dart';
// import '../screens/home_screen.dart';
// import '../screens/saved_recipes_screen.dart';
//
// class AppDrawer extends StatefulWidget {
//   const AppDrawer({Key? key}) : super(key: key);
//
//   @override
//   State<AppDrawer> createState() => _AppDrawerState();
// }
//
// class _AppDrawerState extends State<AppDrawer> {
//   var _darkMode = false;
//
//   void _logOut() {
//     try {
//       Provider.of<Auth>(context, listen: false).logout();
//       // Navigator.of(context).pop();
//       Navigator.of(context).pushNamed('/');
//     } catch (error) {
//       showDialog(
//         context: context,
//         builder: (ctx) =>
//             const ErrorDialog('Could not log you out. Please try again later.'),
//       );
//     }
//   }
//
//   Widget _getListTile(IconData iconData, String title, VoidCallback onTap) {
//     return ListTile(
//       tileColor: Colors.white,
//       leading: Icon(iconData),
//       title: Text(
//         title.toUpperCase(),
//         style: const TextStyle(fontWeight: FontWeight.bold),
//       ),
//       onTap: onTap,
//       textColor: Colors.black,
//       iconColor: Colors.black,
//     );
//   }
//
//   Widget _getDivider() {
//     return Container(
//       margin: const EdgeInsets.only(left: 60),
//       child: const Divider(height: 1),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final username = Provider.of<Auth>(context).username;
//     return Drawer(
//       backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
//       child: ListView(
//         children: [
//           Container(
//             color: Colors.white,
//             child: Column(
//               children: [
//                 AppBar(
//                   title: Text(
//                     'Hey, $username!',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   backgroundColor: Colors.black,
//                   automaticallyImplyLeading: false,
//                 ),
//                 const SizedBox(
//                   height: 5,
//                 ),
//                 _getListTile(Icons.home, 'Home', () {
//                   Navigator.of(context).pushNamed(HomeScreen.routeName);
//                 }),
//                 _getDivider(),
//                 _getListTile(Icons.favorite, 'Saved recipes', () {
//                   Navigator.of(context).pushNamed(SavedRecipesScreen.routeName);
//                 }),
//                 _getDivider(),
//                 _getListTile(Icons.settings, 'Settings', () {}),
//                 _getDivider(),
//                 _getListTile(Icons.info_outline, 'About', () {}),
//                 Container(
//                   height: 10,
//                   color: const Color.fromRGBO(245, 245, 245, 1),
//                 ),
//                 ListTile(
//                   tileColor: Colors.white,
//                   leading: const Icon(Icons.dark_mode_outlined),
//                   title: Text(
//                     'Dark mode'.toUpperCase(),
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   textColor: Colors.black,
//                   iconColor: Colors.black,
//                   trailing: Switch(
//                     onChanged: (val) {
//                       setState(() {
//                         _darkMode = !_darkMode;
//                       });
//                     },
//                     value: _darkMode,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           _getListTile(Icons.logout_outlined, 'Log out', _logOut),
//           const SizedBox(
//             height: 10,
//           ),
//         ],
//       ),
//     );
//   }
// }
