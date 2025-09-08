import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String? _fileName;
  String? _filePath;
  String? _csvContent;

  Future<void> _pickCsvFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        _fileName = result.files.single.name;
        _filePath = result.files.single.path;
      });
      final file = File(_filePath!);
      final content = await file.readAsString();
      setState(() {
        _csvContent = content;
      });
      // TODO: Parse CSV and upload to database
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin - Upload CSV')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _pickCsvFile,
              child: const Text('Select CSV File'),
            ),
            if (_fileName != null) ...[
              const SizedBox(height: 16),
              Text('Selected file: $_fileName'),
            ],
            if (_csvContent != null) ...[
              const SizedBox(height: 16),
              Text('CSV Preview:'),
              Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.grey[200],
                child: Text(_csvContent!,
                    maxLines: 10, overflow: TextOverflow.ellipsis),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
