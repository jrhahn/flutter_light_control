import 'package:flutter/material.dart';
import 'package:flutter_light_control/screen/set_up_light.dart';

import 'constants.dart';
import 'screen/main.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const LightControlApp());
}

class LightControlApp extends StatefulWidget {
  const LightControlApp({super.key});

  @override
  State<LightControlApp> createState() {
    return _LightControlAppState();
  }
}

class _LightControlAppState extends State<LightControlApp> {
  // final TextEditingController _controller = TextEditingController();
  // final TextEditingController _controller2 = TextEditingController();
  // Future<String>? _futureString;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appTitle,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: Screen.main,
        routes: {
          Screen.main: (context) => const MainScreen(),
          Screen.lightSetup: (context) => const LightSetupScreen(),
        });
  }

// Center buildStartScreen() {
//   return Center(
//         child: ListView(
//           // alignment: Alignment.center,
//           padding: const EdgeInsets.all(8.0),
//           children:      <Widget>[
//     // mainAxisAlignment: MainAxisAlignment.center,
//     // children: <Widget>[
//     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//       Flexible(
//           child: TextField(
//         controller: _controller,
//         decoration:
//             const InputDecoration(hintText: 'Enter a brightness value between 0 and 1.0'),
//       )),
//       ElevatedButton(
//         // onPressed: !buttonEnabled ? null : () {
//         //   buttonEnabled = false;
//         //   setState(() {
//         //     dis
//             _futureString = setBrightness(double.parse(_controller.text));
//           // });
//         },
//         child: const Text('Set brightness'),
//       )
//     ])
//   ]
//   )
//   );
// }

// void _showToast(BuildContext context) {
//   final scaffold = ScaffoldMessenger.of(context);
//   scaffold.showSnackBar(
//     SnackBar(
//       content: const Text('Added to favorite'),
//       action: SnackBarAction(label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
//     ),
//   );
// }

// FutureBuilder<String> buildFutureBuilder() {
//   return FutureBuilder<String>(
//     future: _futureString,
//     builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         return Text(snapshot.data!.toString());
//       } else if (snapshot.hasError) {
//         return Text('${snapshot.error}');
//       }
//
//       return const CircularProgressIndicator();
//     }
//   );
// }
}
