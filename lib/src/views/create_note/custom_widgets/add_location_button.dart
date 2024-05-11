import 'package:flutter/material.dart';
import '../../../models/note.dart';

class LocationButton extends StatelessWidget {
  final String? address;
  final Note? note;

  LocationButton({this.address, this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: address == null || address!.isEmpty ? 56 : 64,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFECFDF3),
            ),
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF156FEE),
              size: 16,
            ),
          ),
          const SizedBox(width: 4),
          if (address == '' || address!.isEmpty)
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Location',
                    style: TextStyle(
                      color: Color(0xFF156FEE),
                      fontSize: 16,
                      fontFamily: 'Gilroy-SemiBold',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address!,
                      style: const TextStyle(
                        color: Color(0xFF101828),
                        fontSize: 10,
                        fontFamily: 'Gilroy-Medium',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(width: 4),
          note != null
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF12B669),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                  child: Text(
                    note!.label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
