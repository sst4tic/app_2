import 'package:flutter/material.dart';

class DatePickerModel extends StatefulWidget {
  final TextEditingController dateController;
  const DatePickerModel({Key? key, required this.dateController}) : super(key: key);

  @override
  DatePickerModelState createState() => DatePickerModelState();
}

class DatePickerModelState extends State<DatePickerModel> {

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        widget.dateController.text = picked.toString().substring(0, 10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.dateController.text,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const Icon(Icons.calendar_today_outlined),
            ],
          ),
        ),
      ),
    );

  }
}