import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../models/session.dart';

class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch all sessions from the 'sessionsBox'
    final sessionsBox = Hive.box<Session>('sessionsBox');
    final pastSessions = sessionsBox.values.toList().reversed;

    return Scaffold(
      appBar: AppBar(title: const Text('Sessions')),
      body: ListView.builder(
        itemCount: pastSessions.length,
        itemBuilder: (context, index) {
          final session = pastSessions.elementAt(index);
          return _buildSessionTile(session);
        },
      ),
    );
  }

  Widget _buildSessionTile(Session session) {
    return ListTile(
      title: const Text('Session'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Start: ${DateFormat.yMd().add_jm().format(session.startTime)}'),
          Text('End: ${DateFormat.yMd().add_jm().format(session.endTime)}'),
          Text('Max BAC: ${session.maxBAC.toStringAsFixed(3)}'),
        ],
      ),
    );
  }
}