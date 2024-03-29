// import 'package:flutter/material.dart';
// import 'package:flutter_view_controller/constants.dart';
// import 'package:flutter_view_controller/screens/shopping_cart_page.dart';

// class CartButton extends StatelessWidget {
//   const CartButton({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const ShoppingCartPage(),
//           ),
//         );
//       },
//       child: SizedBox(
//         width: 100.0,
//         height: 40.0,
//         child: Stack(
//           children: [
//             Align(
//               alignment: Alignment.center,
//               child: Container(
//                 height: 30.0,
//                 width: 90.0,
//                 decoration: BoxDecoration(
//                   color: kPrimaryColor,
//                   borderRadius: BorderRadius.circular(50.0),
//                 ),
//               ),
//             ),
//             const Align(
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding: EdgeInsets.only(
//                   left: 20,
//                 ),
//                 child: Text(
//                   'Cart',
//                   style: TextStyle(
//                     color: kWhite,
//                     fontSize: 14.0,
//                   ),
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.centerRight,
//               child: Container(
//                 width: 40.0,
//                 height: 40.0,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(25.0),
//                   color: kWhite,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.12),
//                       offset: const Offset(0, 1),
//                       blurRadius: 10,
//                     )
//                   ],
//                 ),
//                 child: const Text(
//                   '+',
//                   style: TextStyle(
//                     color: kPrimaryColor,
//                     fontSize: 26.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
