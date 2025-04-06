import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'package:hive/hive.dart';

class SessionScreen extends StatelessWidget {
  const SessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessions'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: [
          if (SessionService.currentSession != null)
            _buildCurrentSession(),
          
          _buildPastSessions(),
        ],
      ),
    );
  }

  Widget _buildCurrentSession() {
    final session = SessionService.currentSession!;
    return ExpansionTile(
      title: const Text('Current Session'),
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: session.drinks.length,
          itemBuilder: (context, i) => ListTile(
            title: Text('Drink ${i + 1}'),
            subtitle: Text(DateFormat.jm().format(session.drinks[i].time)),
          ),
        ),
      ],
    );
  }

  Widget _buildPastSessions() {
    final sessions = Hive.box<Session>('sessionsBox').values.toList().reversed;
    return Column(
      children: sessions.map((session) => _buildSessionTile(session)).toList(),
    );
  }

  Widget _buildSessionTile(Session session) {
    return ListTile(
      title: Text('Session ${DateFormat.yMd().format(session.startTime)}'),
      subtitle: Text('${session.drinks.length} drinks - Max BAC: ${session.maxBAC.toStringAsFixed(3)}'),
      trailing: Text(DateFormat.jm().format(session.endTime)),
    );
  }
}
