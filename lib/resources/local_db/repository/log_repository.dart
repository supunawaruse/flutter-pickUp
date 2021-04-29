import 'package:skype_clone/models/log.dart';
import 'package:skype_clone/resources/local_db/db/sqlite_methods.dart';

class LogRepository {
  static var dbObject;

  static init() {
    dbObject = SqliteMethods();
    dbObject.init();
  }

  static addLogs(Log log) => dbObject.addLogs(log);

  static deleteLogs(int logId) => dbObject.deleteLogs(logId);

  static getLogs() => dbObject.getLogs();

  static close() => dbObject.close();
}
