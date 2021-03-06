// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';

// List<CameraDescription> cameras;

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   cameras = await availableCameras();
//   runApp(CameraApp());
// }

// class CameraApp extends StatefulWidget {
//   @override
//   _CameraAppState createState() => _CameraAppState();
// }

// class _CameraAppState extends State<CameraApp> {
//   CameraController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = CameraController(cameras[0], ResolutionPreset.medium);
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return Container();
//     }
//     return AspectRatio(
//         aspectRatio: controller.value.aspectRatio,
//         child: CameraPreview(controller));
//   }
// }

import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as imglib;
import 'package:permission_handler/permission_handler.dart';

typedef convert_func = Pointer<Uint32> Function(
    Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>, Int32, Int32, Int32, Int32);
typedef Convert = Pointer<Uint32> Function(
    Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>, int, int, int, int);

Future<void> main() async {
  Permission.camera.request();

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: MyHomePage(
        title: 'my title',
      ),
    ),
  );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CameraController _camera;
  bool _cameraInitialized = false;
  CameraImage _savedImage;

  final DynamicLibrary convertImageLib = Platform.isAndroid
      ? DynamicLibrary.open("libconvertImage.so")
      : DynamicLibrary.process();
  Convert conv;
  static imglib.Image im;
  @override
  void initState() {
    im = imglib.Image(500, 500);
    super.initState();
    _initializeCamera();

    // Load the convertImage() function from the library
    conv = convertImageLib
        .lookup<NativeFunction<convert_func>>('convertImage')
        .asFunction<Convert>();
  }

  void _initializeCamera() async {
    // Get list of cameras of the device
    List<CameraDescription> cameras = await availableCameras();

    // Create the CameraController
    _camera = new CameraController(cameras[0], ResolutionPreset.veryHigh);
    _camera.initialize().then((_) async {
      // Start ImageStream
      await _camera
          .startImageStream((CameraImage image) => _processCameraImage(image));
      setState(() {
        _cameraInitialized = true;
      });
    });
  }

  void _processCameraImage(CameraImage image) async {
    setState(() {
      _savedImage = image;
    });
  }

  static int y = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(children: [
        Center(
            child: (_cameraInitialized)
                ? AspectRatio(
                    aspectRatio: _camera.value.aspectRatio,
                    child: CameraPreview(_camera),
                  )
                : CircularProgressIndicator()),
        Center(
          child: ImagePreview(
            img: im,
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Allocate memory for the 3 planes of the image
          Pointer<Uint8> p =
              allocate(count: _savedImage.planes[0].bytes.length);
          Pointer<Uint8> p1 =
              allocate(count: _savedImage.planes[1].bytes.length);
          Pointer<Uint8> p2 =
              allocate(count: _savedImage.planes[2].bytes.length);

          // Assign the planes data to the pointers of the image
          Uint8List pointerList =
              p.asTypedList(_savedImage.planes[0].bytes.length);
          Uint8List pointerList1 =
              p1.asTypedList(_savedImage.planes[1].bytes.length);
          Uint8List pointerList2 =
              p2.asTypedList(_savedImage.planes[2].bytes.length);
          pointerList.setRange(0, _savedImage.planes[0].bytes.length,
              _savedImage.planes[0].bytes);
          pointerList1.setRange(0, _savedImage.planes[1].bytes.length,
              _savedImage.planes[1].bytes);
          pointerList2.setRange(0, _savedImage.planes[2].bytes.length,
              _savedImage.planes[2].bytes);

          // Call the convertImage function and convert the YUV to RGB
          Pointer<Uint32> imgP = conv(
              p,
              p1,
              p2,
              _savedImage.planes[1].bytesPerRow,
              _savedImage.planes[1].bytesPerPixel,
              _savedImage.width,
              _savedImage.height);
          // Get the pointer of the data returned from the function to a List
          List imgData =
              imgP.asTypedList((_savedImage.width * _savedImage.height));
          imglib.Image temp = imglib.Image.fromBytes(
              _savedImage.height, _savedImage.width, imgData);
          print('$y');
          print(im.width);

          imglib.copyInto(im, temp,
              blend: false,
              dstX: 0,
              dstY: y,
              srcX: 0,
              srcY: y,
              srcH: y + 10,
              srcW: _savedImage.width);
          y = y + 10;

          // Generate image from the converted data
          // imglib.Image img =

          // Free the memory space allocated
          // from the planes and the converted data
          free(p);
          free(p1);
          free(p2);
          free(imgP);

          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => new ImagePreview(img: im)));
        },
        tooltip: 'Increment',
        child: Icon(Icons.camera_alt),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class ImagePreview extends StatelessWidget {
  final imglib.Image img;

  const ImagePreview({Key key, this.img}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(child: Image.memory(imglib.encodeJpg(img)));
  }
}
