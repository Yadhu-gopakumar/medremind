import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calenderpg extends StatefulWidget {
  const Calenderpg({super.key});

  @override
  State<Calenderpg> createState() => _CalenderpgState();
}

class _CalenderpgState extends State<Calenderpg> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> medicineSchedule = {
    DateTime.utc(2025, 7, 2): ['Paracetamol 500mg', 'Vitamin D'],
    DateTime.utc(2025, 7, 3): ['Ibuprofen'],
  };

  List<String> _getMedicinesForDay(DateTime day) {
    return medicineSchedule[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final selectedMeds = _selectedDay != null
        ? _getMedicinesForDay(_selectedDay!)
        : _getMedicinesForDay(_focusedDay);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),

        title: const Text('Calendar View',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green[700],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020),
              lastDay: DateTime.utc(2030),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green[700],
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Medicines on ${_selectedDay?.toLocal().toString().split(' ')[0] ?? 'Today'}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...selectedMeds.map(
              (med) => Card(
                child: ListTile(
                  leading: const Icon(Icons.medication),
                  title: Text(med),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement edit action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[800],
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Edit'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}