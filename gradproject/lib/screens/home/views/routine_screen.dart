import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../services/firestore.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  final TextEditingController textController = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();
  final Map<DateTime, List<dynamic>> _selectedEvents = {};
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, int> _completedStepsPerDay = {};

  @override
  void initState() {
    super.initState();

    firestoreService.getDailyStatusStream().listen((snapshot) {
      Map<DateTime, int> completedSteps = {};
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        DateTime date = DateTime.parse(data['date']);
        int steps = data['completedSteps'];
        completedSteps[DateTime(date.year, date.month, date.day)] = steps;
      }
      setState(() {
        _completedStepsPerDay = completedSteps;
      });
      if (kDebugMode) {
        print('Completed steps per day: $_completedStepsPerDay');
      }
    });
  }

  void openNoteBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter your routine step:',
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                firestoreService.addRoutine(textController.text);
              } else {
                firestoreService.updateRoutine(docID, textController.text);
              }
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  void _toggleCompletion(String docID, bool isChecked) {
    firestoreService.updateRoutineStatus(docID, isChecked).then((_) {
      if (kDebugMode) {
        print('Routine step updated for $docID');
      }
      firestoreService.getRoutinesStream().first.then((snapshot) {
        int completedSteps = snapshot.docs
            .where((doc) => (doc.data() as Map<String, dynamic>)['isChecked'])
            .length;
        if (kDebugMode) {
          print('Completed steps: $completedSteps');
        }
        firestoreService
            .updateDailyStatus(DateTime.now(), completedSteps)
            .then((_) {
          if (kDebugMode) {
            print(
                'Daily status updated for ${DateTime.now()} with $completedSteps steps');
          }
          firestoreService.getDailyStatusStream().first.then((dailySnapshot) {
            Map<DateTime, int> updatedSteps = {};
            for (var doc in dailySnapshot.docs) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              DateTime date = DateTime.parse(data['date']);
              int steps = data['completedSteps'];
              updatedSteps[DateTime(date.year, date.month, date.day)] = steps;
            }
            setState(() {
              _completedStepsPerDay = updatedSteps;
            });
            if (kDebugMode) {
              print('Updated steps per day: $_completedStepsPerDay');
            }
          });
        });
      });
    }).catchError((error) {
      if (kDebugMode) {
        print('Failed to update routine status: $error');
      }
    });
  }

  Color _getColorForCompletedSteps(int steps) {
    if (steps == 0) {
      return Colors.white;
    } else if (steps == 1) {
      return Colors.deepPurple.shade100;
    } else if (steps == 2) {
      return Colors.deepPurple.shade300;
    } else if (steps == 3) {
      return Colors.deepPurple.shade600;
    } else {
      return Colors.deepPurple.shade900;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFEDE7F6),
            ],
          ),
        ),
        child: Column(
          children: [
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              selectedDayPredicate: (day) {
                return isSameDay(_focusedDay, day);
              },
              eventLoader: (day) {
                return _selectedEvents[day] ?? [];
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  int completedSteps = _completedStepsPerDay[
                          DateTime(day.year, day.month, day.day)] ??
                      0;
                  Color cellColor = _getColorForCompletedSteps(completedSteps);
                  if (kDebugMode) {
                    print(
                        'Day: ${day.toIso8601String()} - Steps: $completedSteps - Color: $cellColor');
                  }
                  return Container(
                    margin: const EdgeInsets.all(2.0),
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: cellColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestoreService.getRoutinesStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List routinesList = snapshot.data!.docs;
                    return ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: routinesList.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = routinesList[index];
                        String docID = document.id;

                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        String routineText = data['routine'];
                        bool isChecked = data['isChecked'] ?? false;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ListTile(
                            title: Text(routineText),
                            leading: Checkbox(
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _toggleCompletion(docID, value!);
                                });
                              },
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () => openNoteBox(docID: docID),
                                  icon: const Icon(Icons.edit,
                                      color: Colors.deepPurple),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      firestoreService.deleteRoutine(docID),
                                  icon: const Icon(Icons.delete,
                                      color: Colors.deepPurple),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "Add your routine steps",
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
