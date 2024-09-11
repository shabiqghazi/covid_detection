import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http_parser/http_parser.dart';

class Riwayat extends StatefulWidget {
  const Riwayat({super.key});

  @override
  State<Riwayat> createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
  bool _isRecording = false;
  bool _showTimer = false;
  Timer? _timer;
  int _secondsElapsed = 0;
  Color _buttonColor = Colors.teal;
  late final AudioRecorder _record;
  String? _audioPath;

  @override
  void initState() {
    _record = AudioRecorder();
    super.initState();
  }

  // Memulai perekaman suara
  Future<void> _startRecording() async {
    try {
      final directory = await getTemporaryDirectory();
      String path = directory.path;
      await _record.start(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 48000,
          numChannels: 1,
        ),
        path: '$path/audio.pcm',
      );

      print('Perekaman dimulai');
    } catch (e) {
      print('Gagal memulai perekaman: $e');
    }
  }

  // Menghentikan perekaman dan mengirim file
  Future<void> _stopRecording() async {
    try {
      _audioPath = await _record.stop();

      await _uploadRecording(_audioPath);

      print('Perekaman dihentikan dan dikirim');
    } catch (e) {
      print('Gagal menghentikan perekaman: $e');
    }
  }

  // Mengirim file hasil rekaman
  Future<void> _uploadRecording(String? _audioPath) async {
    var url = Uri.parse('http://192.168.1.23:8080/file');
    var request = http.MultipartRequest('POST', url);
    final file = File(_audioPath!);

    // Menambahkan file audio langsung dari memory (stream)
    request.files.add(
      http.MultipartFile(
        'audio',
        file.openRead(),
        await file.length(),
        filename: 'audio.pcm',
        contentType: MediaType('audio', 'pcm'),
      ),
    );

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        print('File berhasil diunggah');
      } else {
        print('Gagal mengunggah file: ${response.statusCode}');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _secondsElapsed++;
        if (_secondsElapsed > 5) {
          _toggleRecording();
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _secondsElapsed = 0;
    });
  }

  void _toggleRecording() async {
    setState(() {
      _isRecording = !_isRecording;
      _buttonColor = _isRecording ? Colors.red : Colors.teal;
      _isRecording ? _startRecording() : _stopRecording();

      if (_isRecording) {
        _startTimer();
      } else {
        _stopTimer();
      }
    });
  }

  @override
  void dispose() {
    _record.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yy').format(now);

    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Audio 1'),
            subtitle: const Text('Anda terdeteksi Negatif'),
            trailing: Text(formattedDate),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          _toggleRecording();
        },
        child: AnimatedContainer(
          height: 50.0,
          width: _isRecording ? screenWidth * 0.5 : 50.0,
          duration: const Duration(milliseconds: 250),
          onEnd: () {
            setState(() {
              _showTimer = _isRecording;
            });
          },
          child: _isRecording
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: _buttonColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: Row(
                      spacing: 4,
                      mainAxisAlignment: _showTimer
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.end,
                      children: [
                        if (_showTimer)
                          Text(
                            '${_secondsElapsed.toString()}\t\t Recording',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        const Flexible(
                          child: Icon(
                            Icons.stop_circle,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: _buttonColor,
                  ),
                  child: const Icon(
                    Icons.mic,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
