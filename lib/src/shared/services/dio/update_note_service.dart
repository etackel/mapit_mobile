// update_note_service.dart
import 'package:dio/dio.dart';
import '../../../domain/entities/note.dart';
import 'network_service.dart';

class UpdateNoteService {
  final NetworkService _networkService;

  UpdateNoteService(this._networkService);

  Future<Response> update(String noteId, Note note) {
    return _networkService.dio.put(
      '/notes/$noteId',
      data: note.toJson(),
    );
  }
}