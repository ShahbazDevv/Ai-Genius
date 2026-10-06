import '../local/app_database.dart';
import '../models/models.dart';

abstract class HistoryRepository {
  Future<List<SearchHistoryItem>> getAllHistory();
  Future<SearchHistoryItem?> getHistoryById(String id);
  Future<void> addHistoryItem(SearchHistoryItem item);
  Future<void> deleteHistoryItem(String id);
  Future<void> clearHistory();
}

class SqliteHistoryRepository implements HistoryRepository {
  final AppDatabase _database;

  SqliteHistoryRepository(this._database);

  @override
  Future<List<SearchHistoryItem>> getAllHistory() {
    return _database.getAllHistory();
  }

  @override
  Future<SearchHistoryItem?> getHistoryById(String id) {
    return _database.getHistoryById(id);
  }

  @override
  Future<void> addHistoryItem(SearchHistoryItem item) {
    return _database.insertHistory(item);
  }

  @override
  Future<void> deleteHistoryItem(String id) {
    return _database.deleteHistory(id);
  }

  @override
  Future<void> clearHistory() {
    return _database.clearAllHistory();
  }
}
