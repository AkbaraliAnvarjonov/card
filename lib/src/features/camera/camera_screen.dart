import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  File? _imageFile;
  final _picker = ImagePicker();
  String _mlResult = '<no result>';
  bool _isLoading = false;

  Future<void> requestPermissions() async {
    if (await Permission.camera.isDenied) {
      await Permission.camera.request();
    }
    if (await Permission.photos.isDenied) {
      await Permission.photos.request();
    }
  }

  Future<void> _captureImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      } else {
        debugPrint('No image selected.');
      }
    } catch (e) {
      debugPrint('Error while capturing image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<bool> _pickImage() async {
    setState(() => _imageFile = null);
    final File? imageFile = await showDialog<File>(
      context: context,
      builder: (ctx) => SimpleDialog(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take picture'),
            onTap: () async {
              await _captureImage();
              Navigator.pop(ctx);
            },
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Pick from gallery'),
            onTap: () async {
              try {
                final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                if (ctx.mounted && pickedFile != null) {
                  Navigator.pop(ctx, File(pickedFile.path));
                }
              } catch (e) {
                print(e);
                if (ctx.mounted) Navigator.pop(ctx, null);
              }
            },
          ),
        ],
      ),
    );
    if (mounted && imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please pick one image first.')),
      );
      return false;
    }
    setState(() => _imageFile = imageFile);
    return true;
  }

  Future<void> _textOcr() async {
    setState(() {
      _mlResult = '<no result>';
      _isLoading = true;
    });

    if (await _pickImage() == false) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final inputImage = InputImage.fromFile(_imageFile!);
      final textDetector = GoogleMlKit.vision.textRecognizer();
      final recognizedText = await textDetector.processImage(inputImage);
      String result = 'Detected ${recognizedText.blocks.length} text blocks.\n';

      for (final block in recognizedText.blocks) {
        final text = block.text;
        final boundingBox = block.boundingBox;
        result += '\n# Text block:\n bbox=$boundingBox\n text=$text\n';
      }

      setState(() => _mlResult = result);
    } catch (e) {
      setState(() {
        _mlResult = 'Error occurred: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (_imageFile == null)
            const Placeholder(fallbackHeight: 200.0)
          else
            Image.file(_imageFile!, height: 200, fit: BoxFit.contain),
          const SizedBox(height: 20),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _textOcr,
                  child: const Text('Text OCR'),
                ),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                _mlResult,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
