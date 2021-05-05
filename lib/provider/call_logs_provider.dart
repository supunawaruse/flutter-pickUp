import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:skype_clone/enum/view_state.dart';
import 'package:skype_clone/models/log.dart';
import 'package:skype_clone/models/user.dart';
import 'package:skype_clone/resources/firebaseRepository.dart';
import 'package:skype_clone/resources/local_db/repository/log_repository.dart';

class CallLogsProvider with ChangeNotifier {
  List<Log> _logs;

  List<Log> get getLogs => _logs;

  Future<void> refreshLogs() async {
    List<Log> logs = await LogRepository.getLogs();
    _logs = logs;
    notifyListeners();
  }
}
