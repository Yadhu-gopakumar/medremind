
// import 'package:flutter/material.dart';

// class AddMedicinePage extends StatefulWidget {
//   const AddMedicinePage({super.key});

//   @override
//   State<AddMedicinePage> createState() => _AddMedicinePageState();
// }

// class _AddMedicinePageState extends State<AddMedicinePage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _dosageController = TextEditingController();
//   DateTime? _selectedDate;
//   int? _timesPerDay; // 1, 2, 3, or 4
//   List<TimeOfDay?> _doseTimes = [null, null, null, null];

//   // Helper to show date picker
//   Future<void> _pickDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Colors.green[700]!,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   // Helper to show time picker for each slot
//   Future<void> _pickTime(BuildContext context, int index) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: _doseTimes[index] ?? TimeOfDay.now(),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: ColorScheme.light(
//               primary: Colors.green[700]!,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );
//     if (picked != null) {
//       setState(() {
//         _doseTimes[index] = picked;
//       });
//     }
//   }

//   void _saveMedicine() {
//     bool allTimesSelected = _timesPerDay != null &&
//         List.generate(_timesPerDay!, (i) => _doseTimes[i])
//             .every((t) => t != null);

//     if (_formKey.currentState!.validate() &&
//         _selectedDate != null &&
//         _timesPerDay != null &&
//         allTimesSelected) {
//       // Save logic here
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Medicine Saved!')),
//       );
//       // You can clear the form or pop the page here
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields!')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Color mainGreen = const Color(0xFF166D5B);

//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           'New Medicine',
//           style: TextStyle(
//               fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.green[700],
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 // Medicine Name
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: InputDecoration(
//                     labelText: 'Medicine Name',
//                     prefixIcon: Icon(Icons.medical_services, color: mainGreen),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                   ),
//                   validator: (value) => value == null || value.trim().isEmpty
//                       ? 'Enter medicine name'
//                       : null,
//                 ),
//                 const SizedBox(height: 18),
//                 // Dosage
//                 TextFormField(
//                   controller: _dosageController,
//                   decoration: InputDecoration(
//                     labelText: 'Dosage (e.g. 500mg)',
//                     prefixIcon:
//                         Icon(Icons.format_list_numbered, color: mainGreen),
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12)),
//                   ),
//                   validator: (value) => value == null || value.trim().isEmpty
//                       ? 'Enter dosage'
//                       : null,
//                 ),
//                 const SizedBox(height: 18),
//                 // Number of times per day
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Times per day",
//                     style: TextStyle(
//                         color: mainGreen,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: List.generate(4, (index) {
//                     int value = index + 1;
//                     return ChoiceChip(
//                       label: Text("$value"),
//                       selected: _timesPerDay == value,
//                       onSelected: (selected) {
//                         setState(() {
//                           _timesPerDay = value;
//                         });
//                       },
//                       selectedColor: Colors.green[700],
//                       labelStyle: TextStyle(
//                         color: _timesPerDay == value
//                             ? Colors.white
//                             : mainGreen,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                       backgroundColor: Colors.green[50],
//                     );
//                   }),
//                 ),
//                 const SizedBox(height: 18),
//                 // Time pickers for each dose
//                 if (_timesPerDay != null)
//                   Column(
//                     children: List.generate(_timesPerDay!, (i) {
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 12.0),
//                         child: InkWell(
//                           onTap: () => _pickTime(context, i),
//                           borderRadius: BorderRadius.circular(12),
//                           child: InputDecorator(
//                             decoration: InputDecoration(
//                               labelText: 'Time for dose ${i + 1}',
//                               prefixIcon: Icon(Icons.access_time, color: mainGreen),
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(12)),
//                             ),
//                             child: Text(
//                               _doseTimes[i] == null
//                                   ? 'Select time'
//                                   : _doseTimes[i]!.format(context),
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: _doseTimes[i] == null
//                                     ? Colors.grey
//                                     : Colors.black,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//                   ),
//                 // Till Date
//                 InkWell(
//                   onTap: () => _pickDate(context),
//                   borderRadius: BorderRadius.circular(12),
//                   child: InputDecorator(
//                     decoration: InputDecoration(
//                       labelText: 'Till Date',
//                       prefixIcon: Icon(Icons.date_range, color: mainGreen),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                     child: Text(
//                       _selectedDate == null
//                           ? 'Select date'
//                           : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
//                       style: TextStyle(
//                         fontSize: 16,
//                         color:
//                             _selectedDate == null ? Colors.grey : Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 // Save Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _saveMedicine,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green[700],
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text(
//                       "Save",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                         letterSpacing: 1.1,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../constants/hive_keys.dart';
import '../../models/medicine.dart';
import '../../utils/date_utils.dart';


class AddMedicinePage extends StatefulWidget {
  const AddMedicinePage({super.key});

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _quantityController = TextEditingController();
  final _thresholdController = TextEditingController();

  DateTime? _selectedDate;
  int? _timesPerDay;
  List<TimeOfDay?> _doseTimes = [null, null, null, null];

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime(BuildContext context, int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _doseTimes[index] ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _doseTimes[index] = picked);
  }

  void _saveMedicine() {
    bool allTimesSelected = _timesPerDay != null &&
        List.generate(_timesPerDay!, (i) => _doseTimes[i]).every((t) => t != null);

    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _timesPerDay != null &&
        allTimesSelected) {
      final intakeTimes = List.generate(
        _timesPerDay!,
        (i) => timeOfDayToString(_doseTimes[i]!),
      );

      final medicine = Medicine(
        name: _nameController.text.trim(),
        dosage: _dosageController.text.trim(),
        expiryDate: _selectedDate!,
        dailyIntakeTimes: intakeTimes,
        totalQuantity: int.parse(_quantityController.text),
        quantityLeft: int.parse(_quantityController.text),
        refillThreshold: int.parse(_thresholdController.text),
      );

      Hive.box<Medicine>(medicinesBox).add(medicine);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medicine Saved!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mainGreen = const Color(0xFF166D5B);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Medicine', style: TextStyle(color: Colors.white)),
        backgroundColor: mainGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Medicine Name',
                  prefixIcon: Icon(Icons.medical_services, color: mainGreen),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Enter medicine name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dosageController,
                decoration: InputDecoration(
                  labelText: 'Dosage (e.g. 500mg)',
                  prefixIcon: Icon(Icons.format_list_numbered, color: mainGreen),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Enter dosage' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Total Quantity',
                  prefixIcon: Icon(Icons.numbers, color: mainGreen),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Enter total quantity' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _thresholdController,
                decoration: InputDecoration(
                  labelText: 'Refill Threshold',
                  prefixIcon: Icon(Icons.warning, color: mainGreen),
                ),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? 'Enter refill threshold' : null,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  final value = index + 1;
                  return ChoiceChip(
                    label: Text("$value"),
                    selected: _timesPerDay == value,
                    onSelected: (_) => setState(() => _timesPerDay = value),
                    selectedColor: mainGreen,
                  );
                }),
              ),
              const SizedBox(height: 16),
              if (_timesPerDay != null)
                Column(
                  children: List.generate(_timesPerDay!, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => _pickTime(context, i),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Time for dose ${i + 1}',
                            prefixIcon: Icon(Icons.access_time, color: mainGreen),
                          ),
                          child: Text(
                            _doseTimes[i] == null
                                ? 'Select time'
                                : _doseTimes[i]!.format(context),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _pickDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Expiry Date',
                    prefixIcon: Icon(Icons.date_range, color: mainGreen),
                  ),
                  child: Text(
                    _selectedDate == null
                        ? 'Select date'
                        : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveMedicine,
                style: ElevatedButton.styleFrom(backgroundColor: mainGreen),
                child: const Text("Save", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
