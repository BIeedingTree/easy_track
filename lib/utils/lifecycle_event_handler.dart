WidgetsBinding.instance.addObserver(
  LifecycleEventHandler(
    resumeCallBack: () async {
      final currentSession = SessionService.currentSession;
      if (currentSession != null && 
          DateTime.now().difference(currentSession.startTime) > Duration(hours: 24)) {
        await SessionService.endSession();
      }
    },
  ),
);

class LifecycleEventHandler extends WidgetsBindingObserver {
  final Function resumeCallBack;

  LifecycleEventHandler({required this.resumeCallBack});

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      await resumeCallBack();
    }
  }
}
