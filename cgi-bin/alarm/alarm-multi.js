const clock = document.getElementById('clock');
const alarmTimeInput = document.getElementById('alarm-time');
const taskInput = document.getElementById('task');
const addAlarmBtn = document.getElementById('add-alarm');
const alarmsListDiv = document.getElementById('alarms-list');
const reminderDiv = document.getElementById('reminder');
const alarmSound = document.getElementById('alarm-sound');

let alarms = []; // Array to hold alarm objects
let activeAlarmId = null; // Track currently ringing alarm

// Update clock every second
function updateClock() {
  const now = new Date();
  clock.textContent = now.toLocaleTimeString();
}
setInterval(updateClock, 1000);
updateClock();

// Helper to format time string "HH:MM"
function formatTime(date) {
  return date.toTimeString().slice(0, 5);
}

// Add new alarm
addAlarmBtn.addEventListener('click', () => {
  const alarmTime = alarmTimeInput.value;
  const task = taskInput.value.trim();

  if (!alarmTime) {
    alert('Please set a valid alarm time.');
    return;
  }

  const now = new Date();
  const [hours, minutes] = alarmTime.split(':').map(Number);
  let alarmDate = new Date(now.getFullYear(), now.getMonth(), now.getDate(), hours, minutes, 0);

  // If alarm time is earlier than now, set for next day
  if (alarmDate <= now) {
    alarmDate.setDate(alarmDate.getDate() + 1);
  }

  const id = Date.now() + Math.random(); // unique id

  // Schedule alarm
  const timeToAlarm = alarmDate.getTime() - now.getTime();
  const timeoutId = setTimeout(() => triggerAlarm(id), timeToAlarm);

  // Store alarm info
  alarms.push({ id, alarmDate, task, timeoutId });
  renderAlarms();

  // Clear inputs
  alarmTimeInput.value = '';
  taskInput.value = '';
  alert('Alarm added!');
});

// Render alarms list
function renderAlarms() {
  alarmsListDiv.innerHTML = '';
  if (alarms.length === 0) {
    alarmsListDiv.textContent = 'No alarms set.';
    return;
  }

  alarms.forEach(({ id, alarmDate, task }) => {
    const alarmItem = document.createElement('div');
    alarmItem.className = 'alarm-item';

    const info = document.createElement('div');
    info.className = 'alarm-info';
    info.textContent = `${formatTime(alarmDate)} - ${task || '(No task)'}`;

    const deleteBtn = document.createElement('button');
    deleteBtn.className = 'delete-btn';
    deleteBtn.textContent = 'Delete';
    deleteBtn.onclick = () => deleteAlarm(id);

    alarmItem.appendChild(info);
    alarmItem.appendChild(deleteBtn);

    alarmsListDiv.appendChild(alarmItem);
  });
}

// Delete alarm
function deleteAlarm(id) {
  const alarmIndex = alarms.findIndex(a => a.id === id);
  if (alarmIndex === -1) return;

  // Clear timeout
  clearTimeout(alarms[alarmIndex].timeoutId);

  // If this alarm is currently ringing, stop sound
  if (activeAlarmId === id) {
    stopAlarmSound();
  }

  alarms.splice(alarmIndex, 1);
  renderAlarms();
}

// Trigger alarm
function triggerAlarm(id) {
  const alarm = alarms.find(a => a.id === id);
  if (!alarm) return;

  activeAlarmId = id;
  alarmSound.play();
  reminderDiv.textContent = alarm.task ? `Reminder: ${alarm.task}` : 'Alarm ringing!';
  alert(alarm.task ? `Alarm! Reminder: ${alarm.task}` : 'Alarm ringing!');

  // Remove alarm from list after it rings
  deleteAlarm(id);
}

// Stop alarm sound and clear reminder
function stopAlarmSound() {
  alarmSound.pause();
  alarmSound.currentTime = 0;
  reminderDiv.textContent = '';
  activeAlarmId = null;
}

// Optional: Stop alarm button (global)
document.body.insertAdjacentHTML('beforeend', `
  <button id="stop-alarm" style="margin-top:20px; padding: 10px 20px; font-size: 16px;">Stop Alarm</button>
`);

document.getElementById('stop-alarm').addEventListener('click', () => {
  if (activeAlarmId !== null) {
    stopAlarmSound();
    alert('Alarm stopped.');
  } else {
    alert('No alarm is ringing.');
  }
});

renderAlarms();
