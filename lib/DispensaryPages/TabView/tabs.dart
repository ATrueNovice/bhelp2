// import 'package:flutter/material.dart';


// typedef void FilterTabCallback(FilterTabs tab);

// class Tabs extends StatelessWidget implements PreferredSizeWidget {
//   final FilterTabCallback onTabChanged;
//   final FilterTabs filterTab;

//   const Tabs({Key key, @required this.onTabChanged, @required this.filterTab}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       scrollDirection: Axis.horizontal,
//       itemCount: FilterTabs.values.length,
//       itemBuilder: (context, index) {
//         return AspectRatio(
//           aspectRatio: 1,
//           child: GestureDetector(
//             child: Center(
//               child: Text(FilterTabs.values[index].toString().split(".")[1]),
//             ),
//             onTap: () {
//               onTabChanged(FilterTabs.values[index]);
//             },
//           ),
//         );
//       }
//     );
//   }

//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
// }