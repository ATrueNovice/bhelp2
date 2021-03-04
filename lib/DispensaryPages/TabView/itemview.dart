// import 'package:flutter/material.dart';
// import 'package:Buddies/Model/objects.dart';

// class ItemView extends StatefulWidget {
//   final Product product;

//   const ItemView({Key key, this.product}) : super(key: key);

//   @override
//   _ItemViewState createState() => _ItemViewState();
// }

// class _ItemViewState extends State<ItemView> {
//   int selectedId;

//   @override
//   void initState() {
//     super.initState();
//     selectedId = widget.product.sizes[0].id;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.product.name)),
//       body: Column(
//         children: <Widget>[
//           ToggleButtons(
//             children: widget.product.sizes.map((size) => Text(size.size.toString())).toList(),
//             isSelected: widget.product.sizes.map((size) => size.id == selectedId).toList(),
//             onPressed: (i) => setState(() => selectedId = widget.product.sizes[i].id),
//           ),
//           FlatButton(
//             child: Text(widget.product.sizes.firstWhere((e) => e.id == selectedId, orElse: () => Sizes()).price.toString()),
//             onPressed: () {},
//           )
//         ],
//       ),
//     );
//   }
// }