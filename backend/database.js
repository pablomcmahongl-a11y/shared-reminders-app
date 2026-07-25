const sqlite3 = require('sqlite3').verbose();

class Database {
  constructor(dbPath) {
    this.db = new sqlite3.Database(dbPath, (err) => {
      if (err) console.error('Error al conectar:', err.message);
      else console.log('✅ Conectado a la base de datos SQLite');
    });
    
    this.initTables();
  }

  initTables() {
    // Tabla de usuarios
    this.db.run(`
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE,
        name TEXT,
        createdAt TEXT
      )
    `);

    // Tabla de recordatorios
    this.db.run(`
      CREATE TABLE IF NOT EXISTS reminders (
        id TEXT PRIMARY KEY,
        userId TEXT,
        title TEXT NOT NULL,
        description TEXT,
        dueDate TEXT NOT NULL,
        createdAt TEXT,
        completed BOOLEAN DEFAULT 0,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    `);

    // Tabla de recordatorios compartidos
    this.db.run(`
      CREATE TABLE IF NOT EXISTS shared_reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        reminderId TEXT,
        sharedWithUserId TEXT,
        createdAt TEXT,
        FOREIGN KEY (reminderId) REFERENCES reminders(id),
        FOREIGN KEY (sharedWithUserId) REFERENCES users(id)
      )
    `);
  }

  // Métodos de recordatorios
  getReminders(userId) {
    return new Promise((resolve, reject) => {
      this.db.all(
        'SELECT * FROM reminders WHERE userId = ? ORDER BY dueDate ASC',
        [userId],
        (err, rows) => {
          if (err) reject(err);
          else resolve(rows || []);
        }
      );
    });
  }

  getReminderById(reminderId) {
    return new Promise((resolve, reject) => {
      this.db.get(
        'SELECT * FROM reminders WHERE id = ?',
        [reminderId],
        (err, row) => {
          if (err) reject(err);
          else resolve(row);
        }
      );
    });
  }

  createReminder(reminder) {
    return new Promise((resolve, reject) => {
      this.db.run(
        `INSERT INTO reminders (id, userId, title, description, dueDate, createdAt, completed)
         VALUES (?, ?, ?, ?, ?, ?, ?)`,
        [reminder.id, reminder.userId, reminder.title, reminder.description, 
         reminder.dueDate, reminder.createdAt, reminder.completed],
        (err) => {
          if (err) reject(err);
          else resolve(reminder);
        }
      );
    });
  }

  updateReminder(reminderId, updates) {
    return new Promise((resolve, reject) => {
      const fields = Object.keys(updates).map(key => `${key} = ?`).join(', ');
      const values = Object.values(updates);
      
      this.db.run(
        `UPDATE reminders SET ${fields} WHERE id = ?`,
        [...values, reminderId],
        (err) => {
          if (err) reject(err);
          else resolve();
        }
      );
    });
  }

  deleteReminder(reminderId) {
    return new Promise((resolve, reject) => {
      this.db.run(
        'DELETE FROM reminders WHERE id = ?',
        [reminderId],
        (err) => {
          if (err) reject(err);
          else resolve();
        }
      );
    });
  }

  // Métodos de compartición
  shareReminder(reminderId, sharedWithUserId) {
    return new Promise((resolve, reject) => {
      this.db.run(
        `INSERT INTO shared_reminders (reminderId, sharedWithUserId, createdAt)
         VALUES (?, ?, ?)`,
        [reminderId, sharedWithUserId, new Date().toISOString()],
        (err) => {
          if (err) reject(err);
          else resolve();
        }
      );
    });
  }

  getSharedReminders(userId) {
    return new Promise((resolve, reject) => {
      this.db.all(
        `SELECT r.* FROM reminders r
         JOIN shared_reminders sr ON r.id = sr.reminderId
         WHERE sr.sharedWithUserId = ?
         ORDER BY r.dueDate ASC`,
        [userId],
        (err, rows) => {
          if (err) reject(err);
          else resolve(rows || []);
        }
      );
    });
  }
}

module.exports = Database;
