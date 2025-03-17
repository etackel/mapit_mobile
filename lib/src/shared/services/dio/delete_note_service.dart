// delete_note_service.dart
import 'package:dio/dio.dart';
import 'network_service.dart';

class DeleteNoteService {
  final NetworkService _networkService;

  DeleteNoteService(this._networkService);

  Future<Response> delete(String noteId) {
    return _networkService.dio.delete('/notes/$noteId');
  }
}