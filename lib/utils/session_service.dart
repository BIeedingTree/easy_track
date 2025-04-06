import 'package:hive/hive.dart';
import '../models/session.dart';

class SessionService {
  static Session? _currentSession;

  static Session? get currentSession => _currentSession;

  static Future<void> startSession(double weightLb, String sex) async {
    _currentSession = Session.startNew(
      weightLb: weightLb,
      sex: sex,
    );
  }

  static void addDrink() {
    if (_currentSession == null) return;
    
    // Add drink to the current session
    _currentSession!.addDrink();
  }

  static Future<void> endSession() async {
    if (_currentSession == null) return;
    
    // Update end time
    _currentSession!.endTime = DateTime.now();
    
    // Save to Hive or other storage
    final sessionsBox = Hive.box<Session>('sessions');
    await sessionsBox.add(_currentSession!);
    
    _currentSession = null;
  }
}
