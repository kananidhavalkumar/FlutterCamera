import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtills {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

  //  void manipulatet() async {
  //   final path = await _localPath;

  //   img.Image image = img.decodeJpg(File('$path/1.jpg').readAsBytesSync());
  //   img.Image out = img.Image(image.width, image.height);
  //   final int xLength = (image.width).round();
  //   final int yLength = (image.height / 30).round();
  //   //var x = 100, y = 600;
  //   // File('$path/mypng3.jpg').writeAsBytesSync(
  //   //     img.encodeJpg(img.copyCrop(image, x, y, x * xLength, y * yLength)));

  //   for (int y = 0; y < (image.height).round(); y += yLength * 2) {
  //     img.Image temp = img.copyCrop(image, 0, y, image.height, yLength);
  //     img.drawImage(
  //       out,
  //       temp,
  //       blend: false,
  //       dstX: 0,
  //       dstY: y,
  //     );
  //   }

  //   File('$path/output.jpg').writeAsBytesSync(img.encodeJpg(out));
  //   //  img.Image temp = img.copyCrop(image, x, y, x , y +yLength);

  //   print(".................................................");
  // }

  // static Future<File> get _localFile(dynamic) async {
  //   final path = await _localPath;
  //   return File('$path/$name');
  // }

  // static Future<File> writeCounter(String ) async {
  //   final file = await _localFile;

  //   // Write the file.
  //   return file.writeAsString('$counter');
  // }

  // static Future<int> readCounter() async {
  //   try {
  //     final file = await _localFile;

  //     // Read the file
  //     String contents = await file.readAsString();

  //     return int.parse(contents);
  //   } catch (e) {
  //     // If encountering an error, return 0
  //     return 0;
  //   }
  // }
}
