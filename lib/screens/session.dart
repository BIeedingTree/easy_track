import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/session.dart';

class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentSession = SessionService.currentSession;
    final pastSessions = Hive.box<Session>('sessions').values.toList().reversed;

    return Scaffold(
      appBar: AppBar(title: const Text('Sessions')),
      body: ListView(
        children: [
          if (currentSession != null)
            _buildSessionTile(currentSession, isCurrent: true),
          for (final session in pastSessions)
            _buildSessionTile(session),
        ],
      ),
    );
  }

  Widget _buildSessionTile(Session session, {bool isCurrent = false}) {
    return ListTile(
      title: Text(isCurrent ? 'Current Session' : 'Session'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Start: ${DateFormat.yMd().add_jm().format(session.startTime)}'),
          Text('End: ${DateFormat.yMd().add_jm().format(session.endTime)}'),
          Text('Drinks: ${session.drinks.length}'),
          Text('Max BAC: ${session.maxBAC.toStringAsFixed(3)}'),
        ],
      ),
    );
  }
}
