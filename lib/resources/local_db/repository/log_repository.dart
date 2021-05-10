import 'package:flutter/cupertino.dart';
import 'package:skype_clone/models/log.dart';
import 'package:skype_clone/resources/local_db/db/sqlite_methods.dart';

class LogRepository {
  static var dbObject;

  static init({@required String dbName}) {
    dbObject = SqliteMethods();
    dbObject.openDb(dbName);
    dbObject.init();
  }

  static addLogs(Log log) => dbObject.addLogs(log);

  static deleteLogs(int logId) => dbObject.deleteLogs(logId);

  static deleteAllLogs() => dbObject.deleteAllLogs();

  static getLogs() => dbObject.getLogs();

  static close() => dbObject.close();
}
