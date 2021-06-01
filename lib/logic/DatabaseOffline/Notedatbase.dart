import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String table = 'Notes';

class NoteFileds {
  static final List<String> values = [
    id,
    title,
    discription,
    videoLink,
    status
  ];
  static final String id = 'id';
  static final String title = 'title';
  static final String discription = 'discription';
  static final String videoLink = 'videoLink';
  static final String status = 'status';
}

class Note {
  final int id;
  final String title;
  final String discription;
  final String videoLink;
  final int status;
  Note({
    this.id,
    this.title,
    this.discription,
    this.videoLink,
    this.status,
  });
  Map<String, Object> toJson() => {
        NoteFileds.id: id,
        NoteFileds.title: title,
        NoteFileds.discription: discription,
        NoteFileds.status: status,
      };
  Note copy({
    int id,
    String title,
    String discription,
    String videoLink,
    String status,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        discription: discription ?? this.discription,
        videoLink: videoLink ?? this.videoLink,
        status: status ?? this.status,
      );

  static Note fromJson(Map<String, Object> json) => Note(
        id: json[NoteFileds.id] as int,
        discription: json[NoteFileds.discription] as String,
        title: json[NoteFileds.title] as String,
        videoLink: json[NoteFileds.videoLink] as String,
        status: json[NoteFileds.status] as int,
      );
}

class NoteDB {
  static final NoteDB instance = NoteDB._init();
  static Database _database;
  NoteDB._init();
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDB('test.db');
    return _database;
  }

  Future<Database> _initDB(String fpath) async {
    // final dbpath = await getApplicationSupportDirectory();
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, fpath);
    return await openDatabase(path, version: 2, onCreate: _createDb);
  }

  Future _createDb(Database db, int version) async {
    final idtype = 'INTEGER PRIMARY KEY';
    final inttype = 'INTEGER NOT NULL';
    final texttype = 'TEXT ';
    await db.execute(
        '''CREATE TABLE $table(${NoteFileds.id} $idtype,${NoteFileds.title} $texttype,${NoteFileds.discription} $texttype,${NoteFileds.videoLink} $texttype,${NoteFileds.status} $inttype)''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert(table, note.toJson());
    return note.copy(id: id);
  }

  Future<List<Note>> readallNote(int status) async {
    final db = await instance.database;
    final where = '${NoteFileds.status} == $status';
    final result = await db.query(table, where: where);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<int> update({Note note, int sta}) async {
    final db = await instance.database;
    return await db.rawUpdate(
        'UPDATE $table SET ${NoteFileds.status}=$sta WHERE ${NoteFileds.id}=?',
        [note.id]);
  }

  Future<int> delete(Note note) async {
    final db = await instance.database;
    return await db
        .rawDelete('DELETE FROM $table WHERE ${NoteFileds.id}=?', [note.id]);
  }
}
