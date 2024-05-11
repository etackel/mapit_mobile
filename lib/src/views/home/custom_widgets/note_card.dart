import 'package:flutter/material.dart';
import 'package:mapit/src/models/note.dart';

class NoteTile extends StatelessWidget {
  final Note? note;

  NoteTile({this.note});

  @override
  Widget build(BuildContext context) {
    print('address + ${note!.address}');
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: Color(0xFFE4E7EC)),
            boxShadow: [
              BoxShadow(
                color: Color(0x0C000000),
                blurRadius: 13.40,
                offset: Offset(0, 4),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 44,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          note?.title ?? 'Untitled',
                          style: TextStyle(
                            color: Color(0xFF156FEE),
                            fontSize: 20,
                            fontFamily: 'Gilroy-SemiBold',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Icon(
                          Icons.push_pin,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                      Container(
                        width: 16,
                        height: 16,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(),
                        child: Stack(
                          children: [

                            Icon(
                              Icons.add_location,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: Text(
                  note?.description ?? 'No description',
                  style: TextStyle(
                    color: Color(0xFF8F8F8F),
                    fontSize: 12,
                    fontFamily: 'Gilroy-SemiBold',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: Stack(
                            children: [
                              // Add your icon or widget here
                              // For example, you can use an Icon widget
                              Icon(
                                Icons.location_on,
                                color: Color(0xFF475467),
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: SizedBox(
                            child: Text(
                              note?.address ?? 'No address',
                              style: TextStyle(
                                color: Color(0xFF475467),
                                fontSize: 12,
                                fontFamily: 'Gilroy-SemiBold',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(0xFF12B669),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Mid Priority',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
