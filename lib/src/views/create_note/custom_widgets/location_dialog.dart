import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mapit/src/views/add_location/add_location_view.dart';
import 'package:provider/provider.dart';
import '../../../models/note.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../provider/note_provider.dart';
import '../../../utils/save_note_options.dart';

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
    if(widget.note != null) {
      final LocalNote = noteProvider.notes.firstWhere((note) => note.noteId == widget.note?.noteId);
      widget.address = LocalNote.address;
      widget.note = LocalNote;
    }
    print('note label check............. ${widget.note!.label}'); // Debug log
    switch(widget.note?.label) {
      case 'low':
        _priorityValue = 0;
        break;
      case 'moderate':
        _priorityValue = 1;
        break;
      case 'high':
        _priorityValue = 2;
        break;
      default:
        _priorityValue = 1;
    }
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.note != null ? 'Note location' :  'Add new location',
            style: TextStyle(
              color: Color(0xFF156FEE),
              fontSize: 20,
              fontFamily: 'Gilroy-SemiBold',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                  ),
                  child: Icon(
                    Icons.place,
                    color: Color(0xFF156FEE),
                    size: 16,
                  ),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.address,
                        style: TextStyle(
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
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
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
                    SnackBar snackBar = SnackBar(
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
                  child: Icon(
                    Icons.delete_forever_outlined,
                    color: Color(0xFF156FEE),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
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
                    print('Priority value: ${widget.note?.label}'); // Debug log
                    NoteUtils.updateNotePriority(context, widget.note?.noteId ?? '', value.round());
                },
                min: 0,
                max: 2,
                divisions: 2,
                label: 'Priority',
              ),
              Text(
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
          SizedBox(height: 12),
          Text(
            'Remind within ${(1 * _priorityValue).round()} kms of the location',
            style: TextStyle(
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
