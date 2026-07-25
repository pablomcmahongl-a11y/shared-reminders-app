const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { v4: uuidv4 } = require('uuid');
const Database = require('./database');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Inicializar base de datos
const db = new Database('./reminders.db');

// ==================== ENDPOINTS ====================

// GET - Obtener todos los recordatorios de un usuario
app.get('/api/reminders/:userId', (req, res) => {
  const { userId } = req.params;
  
  try {
    const reminders = db.getReminders(userId);
    res.json({ success: true, data: reminders });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// POST - Crear un nuevo recordatorio
app.post('/api/reminders', (req, res) => {
  const { userId, title, description, dueDate } = req.body;
  
  if (!userId || !title || !dueDate) {
    return res.status(400).json({ 
      success: false, 
      error: 'userId, title y dueDate son requeridos' 
    });
  }
  
  try {
    const id = uuidv4();
    const reminder = {
      id,
      userId,
      title,
      description: description || '',
      dueDate,
      createdAt: new Date().toISOString(),
      completed: false
    };
    
    db.createReminder(reminder);
    res.status(201).json({ success: true, data: reminder });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// PUT - Actualizar un recordatorio
app.put('/api/reminders/:reminderId', (req, res) => {
  const { reminderId } = req.params;
  const updates = req.body;
  
  try {
    db.updateReminder(reminderId, updates);
    const reminder = db.getReminderById(reminderId);
    res.json({ success: true, data: reminder });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// DELETE - Eliminar un recordatorio
app.delete('/api/reminders/:reminderId', (req, res) => {
  const { reminderId } = req.params;
  
  try {
    db.deleteReminder(reminderId);
    res.json({ success: true, message: 'Recordatorio eliminado' });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// POST - Compartir recordatorio con otro usuario
app.post('/api/reminders/:reminderId/share', (req, res) => {
  const { reminderId } = req.params;
  const { sharedWithUserId } = req.body;
  
  if (!sharedWithUserId) {
    return res.status(400).json({ 
      success: false, 
      error: 'sharedWithUserId es requerido' 
    });
  }
  
  try {
    db.shareReminder(reminderId, sharedWithUserId);
    res.json({ success: true, message: 'Recordatorio compartido' });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// GET - Obtener recordatorios compartidos con un usuario
app.get('/api/reminders/shared/:userId', (req, res) => {
  const { userId } = req.params;
  
  try {
    const sharedReminders = db.getSharedReminders(userId);
    res.json({ success: true, data: sharedReminders });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`🚀 Servidor ejecutándose en http://localhost:${PORT}`);
  console.log(`📱 Base de datos: reminders.db`);
});
