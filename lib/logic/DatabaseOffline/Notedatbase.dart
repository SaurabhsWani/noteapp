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
  static final String id = '_id';
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
    _database = await _initDB('note.db');
    return _database;
  }

  Future<Database> _initDB(String fpath) async {
    // final dbpath = await getApplicationSupportDirectory();
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, fpath);
    return await openDatabase(path, version: 2, onCreate: _createDb);
  }

  Future _createDb(Database db, int version) async {
    final idtype = 'INTERGER PRIMARY KEY';
    final inttype = 'INTEGER NOT NULL';
    final texttype = 'TEXT ';
    await db.execute(
        '''CREATE TABLE $table(${NoteFileds.id} $idtype,${NoteFileds.title} $texttype,${NoteFileds.discription} $texttype,${NoteFileds.videoLink} $texttype,${NoteFileds.status} $inttype,)''');
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    // final json=note.toJson();
    // final columns='${NoteFileds.title},${NoteFileds.discription},${NoteFileds.videoLink},${NoteFileds.status}';
    // final values='${json[NoteFileds.title]},${json[NoteFileds.discription]},${json[NoteFileds.videoLink]},${json[NoteFileds.status}]';
    // final id=await db.rawInsert('INSERT INTO ');
    final id = await db.insert(table, note.toJson());
    return note.copy(id: id);
  }

  Future<Note> readNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      table,
      columns: NoteFileds.values,
      where: '${NoteFileds.id}=?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Note.fromJson(maps.first);
    } else {
      throw Exception('ID $id Not found');
    }
  }

  Future<List<Note>> readallNote() async {
    final db = await instance.database;
    final result = await db.query(table);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
