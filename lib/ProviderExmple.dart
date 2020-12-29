import 'package:firstFlutter/ItemListener.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ItemListener())],
      child: MaterialApp(
        home: Home(),
      )));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("my app"),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (BuildContext context) => AddItem()));
                })
          ],
        ),
        body: Consumer<ItemListener>(
          builder:
              (BuildContext context, ItemListener itemListener, Widget child) {
            return Column(
              children: [
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    if (itemListener.items.length == 0) {
                      return Text('no products in cart');
                    } else {
                      final item = itemListener.items[index];
                      return ListTile(
                        title: Text(item.name),
                        trailing: Text(item.number.toString()),
                      );
                    }
                  },
                  itemCount: itemListener.items.length,
                )
              ],
            );
          },
          child: Text("hello"),
        ));
  }
}

class AddItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _cont1 = TextEditingController();
    final _cont2 = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("i am adding"),
      ),
      body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: _cont1,
                keyboardType: TextInputType.name,
                decoration: new InputDecoration(
                  hintText: "enter name",
                ),
              ),
              TextFormField(
                controller: _cont2,
                keyboardType: TextInputType.number,
                decoration: new InputDecoration(
                  hintText: "enter number",
                ),
              ),
              RaisedButton(
                  onPressed: () {
                    context
                        .read<ItemListener>()
                        .addItem(_cont1.text, int.parse(_cont2.text));
                    Navigator.pop(context);
                  },
                  child: Text("Add item"))
            ],
          )),
    );
  }
}
// Future<void> main() async {
//   // Ensure that plugin services are initialized so that `availableCameras()`
//   // can be called before `runApp()`
//   WidgetsFlutterBinding.ensureInitialized();

//   // Obtain a list of the available cameras on the device.
//   final cameras = await availableCameras();

//   // Get a specific camera from the list of available cameras.
//   final firstCamera = cameras.first;

//   runApp(
//     MaterialApp(
//       theme: ThemeData.dark(),
//       home: TakePictureScreen(
//         // Pass the appropriate camera to the TakePictureScreen widget.
//         camera: firstCamera,
//       ),
//     ),
//   );
// }

// // A screen that allows users to take a picture using a given camera.
// class TakePictureScreen extends StatefulWidget {
//   final CameraDescription camera;

//   const TakePictureScreen({
//     Key key,
//     @required this.camera,
//   }) : super(key: key);

//   @override
//   TakePictureScreenState createState() => TakePictureScreenState();
// }

// class TakePictureScreenState extends State<TakePictureScreen> {
//   CameraController _controller;
//   Future<void> _initializeControllerFuture;
//   int value = 0;
//   @override
//   void initState() {
//     super.initState();
//     // To display the current output from the Camera,
//     // create a CameraController.
//     _controller = CameraController(
//       // Get a specific camera from the list of available cameras.
//       widget.camera,
//       // Define the resolution to use.
//       ResolutionPreset.medium,
//     );

//     // Next, initialize the controller. This returns a Future.
//     _initializeControllerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     // Dispose of the controller when the widget is disposed.
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Take a picture')),
//       // Wait until the controller is initialized before displaying the
//       // camera preview. Use a FutureBuilder to display a loading spinner
//       // until the controller has finished initializing.
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             // If the Future is complete, display the preview.
//             return CameraPreview(_controller);
//           } else {
//             // Otherwise, display a loading indicator.
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.camera_alt),
//         // Provide an onPressed callback.
//         onPressed: () async {
//           _controller.startImageStream((image) => {value++});

//           Timer t = Timer(Duration(seconds: 1), () {
//             _controller.stopImageStream();
//             print("$value....................");
//           });
//         },
//       ),
//     );
//   }
// }

// // A widget that displays the picture taken by the user.
// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;

//   const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Display the Picture')),
//       // The image is stored as a file on the device. Use the `Image.file`
//       // constructor with the given path to display the image.
//       body: Image.file(File(imagePath)),
//     );
//   }
// }
