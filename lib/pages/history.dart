import 'dart:async';
import 'dart:io';
import 'package:covid_detection/models/history_model.dart';
import 'package:covid_detection/services/history_services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:http_parser/http_parser.dart';

class Riwayat extends StatefulWidget {
  final String userId;
  const Riwayat({super.key, required this.userId});

  @override
  State<Riwayat> createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
  final HistoryServices historyServices = HistoryServices();
  List<HistoryModel> histories = [];
  bool uploading = false;
  bool _isRecording = false;
  bool _showTimer = false;
  Timer? _timer;
  int _secondsElapsed = 0;
  Color _buttonColor = Colors.teal;
  late final AudioRecorder _record;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _record = AudioRecorder();
    fetchData();
  }

  Future<void> fetchData() async {
    List<HistoryModel> fetchHistories =
        await historyServices.getHistories(widget.userId);

    setState(() {
      histories = fetchHistories;
    });
  }

  // Memulai perekaman suara
  Future<void> _startRecording() async {
    try {
      final directory = await getTemporaryDirectory();
      String path = directory.path;
      await _record.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 48000,
          numChannels: 1,
        ),
        path: '$path/audio.wav',
      );
    } catch (e) {
      print('Gagal memulai perekaman: $e');
    }
  }

  // Menghentikan perekaman dan mengirim file
  Future<void> _stopRecording() async {
    try {
      setState(() {
        uploading = true;
      });

      _audioPath = await _record.stop();

      await _uploadRecording(_audioPath);
    } catch (e) {
      print('Gagal menghentikan perekaman: $e');
    }
  }

  // Mengirim file hasil rekaman
  Future<void> _uploadRecording(String? audioPath) async {
    var url = Uri.parse('http://192.168.1.2:5000/get_signal');
    var request = http.MultipartRequest('POST', url);
    final file = File(audioPath!);

    // Menambahkan file audio langsung dari memory (stream)
    request.files.add(
      http.MultipartFile(
        'file',
        file.openRead(),
        await file.length(),
        filename: 'audio.wav',
        contentType: MediaType('audio', 'wav'),
      ),
    );

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        historyServices.createHistory(responseBody, widget.userId).then((_) {
          fetchData();
        });

        setState(() {
          uploading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text('Gagal mengunggah file! (Internal Server Error)'),
            backgroundColor: Colors.red[800],
          ),
        );

        setState(() {
          uploading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Gagal mengunggah file! (Internal Server Error)'),
          backgroundColor: Colors.red[800],
        ),
      );

      setState(() {
        uploading = false;
      });
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
      _buttonColor = _isRecording ? Colors.red[600]! : Colors.teal;
      _isRecording ? _startRecording() : _stopRecording();

      if (_isRecording) {
        _startTimer();
      } else {
        _stopTimer();
      }
    });
  }

  Future<void> _confirmDelete(BuildContext context, documentId) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah anda yakin ingin menghapus data ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (!context.mounted) return;
      await historyServices.deleteHistory(documentId);
      fetchData();
    }
  }

  @override
  void dispose() {
    _record.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: histories.isNotEmpty
          ? ListView.builder(
              itemCount: histories.length,
              itemBuilder: (context, index) {
                DateTime createdAt = histories[index].createdAt;
                String formattedDate = DateFormat('dd/MM/yy').format(createdAt);
                String formattedTime =
                    '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.multitrack_audio,
                        size: 30,
                      ),
                      title: Text(
                        formattedTime,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status: ${histories[index].status}'),
                          Text(
                            'dim: ${double.parse(histories[index].dimension).toStringAsFixed(2)}  size: ${double.parse(histories[index].size).toStringAsFixed(2)}  dispersi: ${double.parse(histories[index].dispersi).toStringAsFixed(2)}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          )
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () async {
                              _confirmDelete(
                                  context, histories[index].documentId);
                            },
                            child: const Icon(
                              Icons.delete,
                              size: 25,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            )
          : const Center(
              child: Text(
                'Riwayat anda kosong.',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
      floatingActionButton: GestureDetector(
        onTap: () {
          if (!uploading) {
            _toggleRecording();
          }
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
              : !uploading
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: _buttonColor,
                      ),
                      child: const Icon(
                        Icons.mic,
                        size: 30,
                        color: Colors.white,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey,
                      ),
                      child: const Icon(
                        Icons.mic_off,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
        ),
      ),
    );
  }
}
