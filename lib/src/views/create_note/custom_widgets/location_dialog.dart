import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mapit/src/views/add_location/add_location_view.dart';
import '../../../models/note.dart';

class LocationBottomSheet extends StatefulWidget {
  final String? address;
  final Note? note;

  LocationBottomSheet({this.address, this.note});

  @override
  _LocationBottomSheetState createState() => _LocationBottomSheetState();
}

class _LocationBottomSheetState extends State<LocationBottomSheet> {
  double _priorityValue = 0.5; // Default priority value

  @override
  Widget build(BuildContext context) {
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
              color: const Color(0xFFECFDF3),
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
                    color: const Color(0xFFECFDF3),
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
                        'Mid Priority',
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
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen()));
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
                  setState(() {
                    _priorityValue = value;
                  });
                },
                min: 0,
                max: 1,
                divisions: 100,
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
            'Remind within ${(5 * _priorityValue).round()} kms of the location',
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
}
