// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_libserialport/flutter_libserialport.dart';

// class ManagePort {
//   late SerialPort port;

//   String? portName;

//   ManagePort.fromName(String this.portName) {
//     port = SerialPort(portName!);
//   }

//   open() {}
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,

//         scaffoldBackgroundColor: Colors.grey[300],
//         // splashColor: Colors.bl,
//         primaryColor: const Color(0xFF12181b),
//         appBarTheme: const AppBarTheme(
//           color: Color(0xFF12181b),
//         ),
//         // scaffoldBackgroundColor: Colors.black,
//       ),
//       title: 'Flutter Serial App',
//       home: const PortsPage(),
//     );
//   }
// }

// class PortsPage extends StatefulWidget {
//   const PortsPage({super.key});

//   @override
//   State<PortsPage> createState() => _PortsPageState();
// }

// class _PortsPageState extends State<PortsPage> {
//   List<String> availablePorts = [];

//   @override
//   void initState() {
//     super.initState();
//     initPorts();
//   }

//   void initPorts() {
//     // debugPrint(SerialPort.availablePorts);
//     setState(
//       () {
//         availablePorts.addAll(SerialPort.availablePorts);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           color: const Color.fromARGB(247, 13, 16, 20),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         margin: const EdgeInsets.all(20),
//         constraints: const BoxConstraints(),
//         child: Scrollbar(
//             child: ListView(
//           children: [
//             const Padding(
//               padding: EdgeInsets.all(16),
//               child: Center(
//                 child: Text(
//                   "Available Ports",
//                   style: TextStyle(
//                     fontSize: 21,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//             for (final port in availablePorts)
//               Builder(
//                 builder: (context) {
//                   return Container(
//                     margin: const EdgeInsets.fromLTRB(20, 3, 10, 3),
//                     decoration: BoxDecoration(
//                         border: Border.all(width: 2, color: Colors.white),
//                         borderRadius: BorderRadius.circular(10)),
//                     child: ListTile(
//                       textColor: Colors.white,
//                       title: Text(port),
//                       leading: const Icon(Icons.settings),
//                       iconColor: Colors.green[500],
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => IOPortPage(
//                               portName: port,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//           ],
//         )),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(const MyApp());
// }

// class IOPortPage extends StatefulWidget {
//   const IOPortPage({super.key, required this.portName});

//   final String portName;

//   @override
//   State<IOPortPage> createState() => _IOPortPageState(portName);
// }

// class _IOPortPageState extends State<IOPortPage> {
//   final String portName;
//   late SerialPort port;
//   late SerialPortReader reader;

//   FocusNode keepFocus = FocusNode();

//   List<String> io_Buffer = <String>[];

//   TextEditingController inputData = TextEditingController();

//   String outputData = "";

//   _IOPortPageState(this.portName);
//   startListening() {
//     if (port.isOpen == true) {
//       debugPrint("selection was open. ");
//     }

//     if (port.open(mode: 1) != true) {
//       debugPrint(
//           "=============> Something went wrong ${SerialPort.lastError?.message}");
//       // ignore: unnecessary_null_comparison
//       // debugPrint();
//     } else {
//       port.config = SerialPortConfig()
//         ..baudRate = 9600
//         // ..xonXoff = 1
//         ..parity = 0
//         ..setFlowControl(SerialPortFlowControl.none)
//         ..bits = 8
//         ..stopBits = 1;

//       // ..xonXoff = 1;
//       // final data = await _selected?.read(128, timeout: 200);
//       // debugPrint("=======> data");
//       // debugPrint(String.fromCharCodes(data!));
//       // _selected?.close();
//       debugPrint("=============> port.open(mode: 1)");

//       reader = SerialPortReader(port);
//       reader.stream.listen(
//         (event) {
//           debugPrint("============> onData: ${port.name}");
//           debugPrint("$event => ${String.fromCharCodes(event)}");
//         },
//         onError: (error, stackTrace) {
//           debugPrint(
//               "error: ${error.toString()}\nstackTrace: ${stackTrace.toString()} ");
//           // debugPrint("stackTrace: ${stackTrace.toString()}");
//         },
//         onDone: () {
//           port.close();
//         },
//       );
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     port.close();
//     port.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     try {
//       port = SerialPort(portName);
//       // port.openReadWrite();
//     } catch (e, _) {
//       debugPrint("----------  There is no port ---------\n $portName");
//       Navigator.of(context).pop();
//     }
//     startListening();
//     // reader = SerialPortReader(port, timeout: 10);
//     // reader.port.openRead();

//     // var s = SerialPortConfig.fromAddress(reader.port.address);
//     // s.baudRate = 9600;
//     // s.stopBits = 1;
//     // s.parity = 0;
//     // s.rts = 1;
//     // s.cts = 0;
//     // s.dtr = 1;
//     // s.dsr = 0;
//     // s.xonXoff = 3;
//     // reader.port.config = s;
//     // debugPrint(reader);
//     // debugPrint();
//     String stringData;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.portName),
//         backgroundColor: const Color.fromARGB(247, 13, 16, 20),
//       ),
//       body: Column(
//         mainAxisSize: MainAxisSize.max,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Expanded(
//             flex: 5,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: const Color.fromARGB(255, 1, 9, 22),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               margin: const EdgeInsets.all(20),
//               padding: const EdgeInsets.all(10),
//               child: NestedScrollView(
//                 headerSliverBuilder:
//                     (BuildContext context, bool innerBoxIsScrolled) {
//                   // These are the slivers that show up in the "outer" scroll view.
//                   return <Widget>[
//                     SliverOverlapAbsorber(
//                       handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
//                           context),
//                       // sliver: const SliverAppBar(
//                       //   centerTitle: true,

//                       //   title:
//                       //       Text('OutPut'), // This is the title in the app bar.
//                       //   automaticallyImplyLeading: false,
//                       //   pinned: false,
//                       // ),
//                     ),
//                   ];
//                 },
//                 body: const RawScrollbar(
//                   thumbColor: Colors.amber,
//                   radius: Radius.circular(20),
//                   thickness: 5,
//                   child: Scrollbar(child: Text("SDASD)")
//                       // StreamBuilder(
//                       //   stream: reader.stream.map((data) {
//                       //     debugPrint("read: $data");
//                       //     stringData = String.fromCharCodes(data);
//                       //     stringData.replaceAll('\r', "");
//                       //     stringData.replaceAll('\n', "");
//                       //     debugPrint("read: $stringData");
//                       //     io_Buffer.add("# $stringData");
//                       //   }),
//                       //   builder: ((context, snapshot) {
//                       //     return ListView.builder(
//                       //       reverse: true,
//                       //       itemCount: io_Buffer.length,
//                       //       itemBuilder: (BuildContext context, int index) {
//                       //         int reversedIndex = io_Buffer.length - 1 - index;
//                       //         // int reversedIndex = index;
//                       //         return Container(
//                       //           constraints: const BoxConstraints(maxHeight: 50),
//                       //           child: SelectableText(
//                       //             ' ${io_Buffer[reversedIndex]}',
//                       //             style: const TextStyle(
//                       //               fontSize: 18,
//                       //               color: Colors.white,
//                       //             ),
//                       //           ),
//                       //         );
//                       //       },
//                       //     );
//                       //   }),
//                       // ),

//                       ),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: const Color.fromARGB(255, 236, 238, 242),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               margin: const EdgeInsets.all(20),
//               padding: const EdgeInsets.all(10),
//               child: Row(
//                 children: [
//                   Expanded(
//                     flex: 7,
//                     child: TextField(
//                       autofocus: true,
//                       focusNode: keepFocus,
//                       style: const TextStyle(color: Colors.blue),
//                       decoration: InputDecoration(
//                         border: const OutlineInputBorder(),
//                         labelText: 'Type commande',
//                         suffixIcon: IconButton(
//                           onPressed: () {
//                             inputData.clear();
//                           },
//                           icon: const Icon(Icons.clear),
//                         ),
//                       ),
//                       controller: inputData,
//                       onSubmitted: (str) {
//                         if (inputData.text.isEmpty) {
//                           setState(() => Null);
//                         } else {
//                           setState(
//                             () async {
//                               io_Buffer.add(inputData.text);
//                               Uint8List data =
//                                   Uint8List.fromList(inputData.text.codeUnits);
//                               port.write(data);
//                               debugPrint("write : $inputData");
//                               // port.write(Uint8List.fromList(" ".codeUnits));
//                               // port.write(inputData.text);
//                               // port.write(" ");
//                               // inputBuffer.add(inputData.text);

//                               inputData.clear();
//                             },
//                           );
//                           inputData.clear();
//                           keepFocus.requestFocus();
//                         }
//                       },
//                     ),
//                   ),
//                   Expanded(
//                     flex: 2,
//                     child: Container(
//                       width: 50,
//                       margin: const EdgeInsets.only(left: 20, right: 20),
//                       child: MaterialButton(
//                         child: const Icon(Icons.send),
//                         onPressed: () {
//                           if (inputData.text.isEmpty) {
//                             setState(() {
//                               Null;
//                             });
//                           } else {
//                             setState(() {
//                               io_Buffer.add(inputData.text);
//                               // port.write(inputData.text);
//                               // port.write(" ");
//                               inputData.clear();
//                             });
//                             keepFocus.requestFocus();
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
