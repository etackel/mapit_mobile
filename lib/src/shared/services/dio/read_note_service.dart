// read_note_service.dart
import 'package:dio/dio.dart';
import 'network_service.dart';

class ReadNoteService {
  final NetworkService _networkService;

  ReadNoteService(this._networkService);

  Future<Response> read(String noteId) {
    return _networkService.dio.get('/notes/$noteId');
  }

  Future<Response> readAll() {
    return _networkService.dio.get('/notes');
  }
}