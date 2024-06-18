import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mapit/src/views/add_location/add_location_view.dart';
import 'package:provider/provider.dart';
import '../../../models/note.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../provider/note_provider.dart';
import '../../../provider/settings_provider.dart';
import '../../../utils/save_note_options.dart';
import '../../../models/priority.dart';

class LocationBottomSheet extends StatefulWidget {
  Note? note;
  String address = 'No Location Selected';

  LocationBottomSheet({this.note});

  @override
  _LocationBottomSheetState createState() => _LocationBottomSheetState();
}

class _LocationBottomSheetState extends State<LocationBottomSheet> {
  double _priorityValue = 1;
  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context, listen: true);
    final settingsProvider = Provider.of<AppSettingsProvider>(context, listen: false);
    double radius;

    if(widget.note != null) {
      final LocalNote = noteProvider.notes.firstWhere((note) => note.noteId == widget.note?.noteId);
      widget.address = LocalNote.address;
      widget.note = LocalNote;
    }
    switch(widget.note?.label) {
      case 'low':
        _priorityValue = 0;
        radius = settingsProvider.priorityDistances.firstWhere((pd) => pd.priority == Priority.low).distance;
        break;
      case 'moderate':
        _priorityValue = 1;
        radius = settingsProvider.priorityDistances.firstWhere((pd) => pd.priority == Priority.moderate).distance;
        break;
      case 'high':
        _priorityValue = 2;
        radius = settingsProvider.priorityDistances.firstWhere((pd) => pd.priority == Priority.high).distance;
        break;
      default:
        _priorityValue = 1;
        radius = 0; // Default radius if label doesn't match any case
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.note != null ? 'Note location' :  'Add new location',
            style: const TextStyle(
              color: Color(0xFF156FEE),
              fontSize: 20,
              fontFamily: 'Gilroy-SemiBold',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                  ),
                  child: const Icon(
                    Icons.place,
                    color: Color(0xFF156FEE),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.address,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Change Location',
                style: TextStyle(
                  color: Color(0xFF156FEE),
                  fontSize: 12,
                  fontFamily: 'Gilroy-SemiBold',
                  fontWeight: FontWeight.w400,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if(widget.note != null) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(
                          NoteId: widget.note?.noteId ??'', onLocationSelected: (LatLng ) {  },
                        ),
                      ),
                    );
                    setState(() {});
                  }
                  else {
                    Navigator.pop(context);
                    SnackBar snackBar = const SnackBar(
                      content: Text('Please create the note first'),
                    );
                    snackBar.showCloseIcon;
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Container(
                  width: 24,
                  height: 24,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Color(0xFF156FEE),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Low',
                style: TextStyle(
                  color: Color(0xFF156FEE),
                  fontSize: 8,
                  fontFamily: 'Gilroy-Medium',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Slider(
                value: _priorityValue,
                onChanged: (value) {
                    _priorityValue = value;
                    NoteUtils.updateNotePriority(context, widget.note?.noteId ?? '', value.round());
                },
                min: 0,
                max: 2,
                divisions: 2,
                label: 'Priority',
              ),
              const Text(
                'Urgent',
                style: TextStyle(
                  color: Color(0xFFF79009),
                  fontSize: 8,
                  fontFamily: 'Gilroy-Medium',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Remind within ${radius.round()} meters of the location',
            style: const TextStyle(
              color: Color(0xFF101828),
              fontSize: 10,
              fontFamily: 'Gilroy-Medium',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }



  Future<String> _getAddress(LatLng location) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(location.latitude, location.longitude);
    return placemarks[0].street.toString();
  }

}
