'use strict';

const { v4: uuidv4 } = require('uuid');

const tasks = [];

const TaskModel = {
  findAll() {
    return [...tasks];
  },

  findById(id) {
    return tasks.find((t) => t.id === id) || null;
  },

  create(data) {
    const now = new Date().toISOString();
    const task = {
      id: uuidv4(),
      title: data.title,
      description: data.description || '',
      isCompleted: data.isCompleted ?? false,
      priority: data.priority || 'medium',
      dueDate: data.dueDate || null,
      createdAt: now,
      updatedAt: now,
    };
    tasks.push(task);
    return task;
  },

  update(id, data) {
    const index = tasks.findIndex((t) => t.id === id);
    if (index === -1) return null;

    tasks[index] = {
      ...tasks[index],
      ...data,
      id: tasks[index].id,
      createdAt: tasks[index].createdAt,
      updatedAt: new Date().toISOString(),
    };
    return tasks[index];
  },

  delete(id) {
    const index = tasks.findIndex((t) => t.id === id);
    if (index === -1) return false;
    tasks.splice(index, 1);
    return true;
  },
};

module.exports = TaskModel;
