import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookAppointmentScreen extends StatefulWidget {
  final int doctorId;

  BookAppointmentScreen({required this.doctorId});

  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  List<String> availableTimes = [
    '09:00 AM', '09:30 AM', '10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM',
    '12:00 PM', '12:30 PM', '1:00 PM', '01:30 PM', '02:00 PM', '02:30 PM',
    '03:00 PM', '03:30 PM',
  ];
  Set<String> bookedTimes = {}; // Set of already booked time slots
  String? _selectedTime;
  bool _isBooking = false;
  String doctorDescription = ''; // To store the doctor's description

  // Function to pick a date
  Future<void> _pickDate() async {
    DateTime today = DateTime.now();
    DateTime initialDate = _selectedDate ?? today;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today,
      lastDate: DateTime(today.year + 1),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedTime = null; // Reset selected time
        _fetchBookedTimes(); // Fetch booked times when date is selected
      });
    }
  }

  // Function to fetch booked time slots for the selected date
  Future<void> _fetchBookedTimes() async {
    if (_selectedDate == null) return;

    final formattedDate = "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

    final response = await http.get(
      Uri.parse('http://192.168.1.121/doctor_appointment_api/get_booked_times.php?date=$formattedDate&doctor_id=${widget.doctorId}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        setState(() {
          bookedTimes = Set<String>.from(data['booked_times']);
        });
      } else {
        _showErrorDialog('Failed to fetch booked times.');
      }
    } else {
      _showErrorDialog('Failed to load booked times.');
    }
  }

  // Function to fetch doctor's description
  Future<void> _fetchDoctorDescription() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.121/doctor_appointment_api/get_doctor_description.php?doctor_id=${widget.doctorId}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        setState(() {
          doctorDescription = data['description'] ?? 'No description available.';
        });
      } else {
        _showErrorDialog('Failed to fetch doctor description.');
      }
    } else {
      _showErrorDialog('Failed to load doctor description.');
    }
  }

  // Function to book the appointment
  Future<void> _bookAppointment() async {
    if (_selectedDate == null || _selectedTime == null || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    setState(() {
      _isBooking = true;
    });

    final appointmentDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      int.parse(_selectedTime!.split(":")[0]),
      int.parse(_selectedTime!.split(":")[1].split(" ")[0]),
    );

    final response = await http.post(
      Uri.parse('http://192.168.1.121/doctor_appointment_api/book_appointment.php'),
      body: {
        'doctor_id': widget.doctorId.toString(),
        'description': _descriptionController.text,
        'appointment_datetime': appointmentDateTime.toIso8601String(),
      },
    );

    setState(() {
      _isBooking = false;
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appointment booked successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book appointment')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.statusCode}')),
      );
    }
  }

  // Show an error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchDoctorDescription(); // Fetch doctor description when screen loads
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              doctorDescription,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Appointment Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _pickDate,
                    child: Text(
                      _selectedDate == null
                          ? 'Select Date'
                          : '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _selectedDate == null
                ? Container()
                : Column(
              children: [
                Text('Select a Time:'),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 2,
                  ),
                  itemCount: availableTimes.length,
                  itemBuilder: (context, index) {
                    final time = availableTimes[index];
                    final isBooked = bookedTimes.contains(time);
                    return GestureDetector(
                      onTap: isBooked
                          ? null
                          : () {
                        setState(() {
                          _selectedTime = time;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: isBooked
                              ? Colors.grey
                              : (_selectedTime == time ? Colors.blue : Colors.white),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.blue),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          time,
                          style: TextStyle(
                            color: isBooked ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 32),
            _isBooking
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _bookAppointment,
              child: Text('Book Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
