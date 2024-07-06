import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'dart:typed_data';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  bool loading = false;

  Future<void> compressAndUploadImage(File imageFile) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Compress the image using flutter_image_compress package
    final result = await FlutterImageCompress.compressWithFile(
      imageFile.absolute.path,
      minWidth: 2300,
      minHeight: 1500,
      quality: 50,
    );

    if (result != null && result.lengthInBytes > 0) {
      final compressedImageFile = File('$path/$fileName')
        ..writeAsBytesSync(result);

      final storage = FirebaseStorage.instance;
      final Reference storageReference =
          storage.ref().child('images/$fileName');

      final UploadTask uploadTask =
          storageReference.putFile(compressedImageFile);
      final TaskSnapshot snapshot = await uploadTask;

      if (snapshot.state == TaskState.success) {
        final url = await storageReference.getDownloadURL();
        print('Image uploaded to Firebase Storage. Download URL: $url');
      } else {
        print('Failed to upload image to Firebase Storage.');
      }
    } else {
      print('Image compression failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_imageFile != null)
              Image.file(File(_imageFile!.path))
            else
              Text('No image selected'),
            ElevatedButton(
              onPressed: pickImage,
              child: Text('Pick an Image'),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    _imageFile = null;
                  });
                },
                icon: Icon(Icons.close)),
            _imageFile != null
                ? Text(_imageFile!.name.toString())
                : Container(),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                await compressAndUploadImage(File(_imageFile!.path));
                setState(() {
                  loading = false;
                });
              },
              child: Text('upload'),
            ),
            loading ? CircularProgressIndicator() : Container(),
          ],
        ),
      ),
    );
  }
}
