import 'dart:async';

import 'package:core/utils/encrypt.dart';

import '../../models/series_table.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

class DatabaseSeriesHelper {
  static DatabaseSeriesHelper? _databaseSeriesHelper;
  DatabaseSeriesHelper._instance() {
    _databaseSeriesHelper = this;
  }

  factory DatabaseSeriesHelper() =>
      _databaseSeriesHelper ?? DatabaseSeriesHelper._instance();

  static Database? _databaseSeries;

  Future<Database?> get databaseSeries async {
    if (_databaseSeries == null) {
      _databaseSeries = await _initDb();
    }
    return _databaseSeries;
  }

  static const String _tblWatchlistSeries = 'watchlistSeries';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditontonSeries.db';

    var db = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _onCreate,
      password: encrypt('akusukakucing'),
    );
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblWatchlistSeries (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  }

  Future<int> insertWatchlistSeries(SeriesTable series) async {
    final db = await databaseSeries;
    return await db!.insert(_tblWatchlistSeries, series.toJson());
  }

  Future<int> removeWatchlistSeries(SeriesTable series) async {
    final db = await databaseSeries;
    return await db!.delete(
      _tblWatchlistSeries,
      where: 'id = ?',
      whereArgs: [series.id],
    );
  }

  Future<Map<String, dynamic>?> getSeriesById(int id) async {
    final db = await databaseSeries;
    final results = await db!.query(
      _tblWatchlistSeries,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistSeries() async {
    final db = await databaseSeries;
    final List<Map<String, dynamic>> results = await db!.query(_tblWatchlistSeries);

    return results;
  }
}
