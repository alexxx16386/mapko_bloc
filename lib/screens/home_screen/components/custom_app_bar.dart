import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    required this.locationName,
  });

  final String locationName;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Card(
          margin: EdgeInsets.all(12),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            leading: Icon(Icons.room),
            trailing: IconButton(
              icon: Icon(Icons.filter_alt),
              onPressed: () {},
            ),
            title: Text(locationName),
          ),
        ),
      ),
    );
  }
}
