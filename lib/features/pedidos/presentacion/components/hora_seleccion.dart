import 'package:flutter/material.dart';

class HoraDialog extends StatefulWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay) onConfirm;

  HoraDialog({required this.initialTime, required this.onConfirm});

  @override
  _HoraDialogState createState() => _HoraDialogState();
}

class _HoraDialogState extends State<HoraDialog> {
  TimeOfDay selectedTime;

  _HoraDialogState() : selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Hour: ${selectedTime.hour}",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          Text(
            "Minute: ${selectedTime.minute}",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onConfirm(selectedTime);
            },
            child: Text("Confirm"),
          ),
        ],
      ),
    );
  }
}