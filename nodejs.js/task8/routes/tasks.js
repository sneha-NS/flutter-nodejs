'use strict';

const express = require('express');
const TaskModel = require('../models/task');
const { createTaskSchema, updateTaskSchema } = require('../validation/taskSchema');

const router = express.Router();

const validate = (schema, data) => {
  const { error, value } = schema.validate(data, { abortEarly: false, stripUnknown: true });
  if (error) {
    const err = new Error(error.details.map((d) => d.message).join('; '));
    err.statusCode = 422;
    throw err;
  }
  return value;
};

const notFound = (id) => {
  const err = new Error(`Task with id '${id}' not found`);
  err.statusCode = 404;
  return err;
};

router.post('/', (req, res, next) => {
  try {
    const data = validate(createTaskSchema, req.body);
    const task = TaskModel.create(data);
    res.status(201).json({ status: 'success', data: task });
  } catch (err) {
    next(err);
  }
});

router.get('/', (req, res) => {
  const tasks = TaskModel.findAll();
  res.status(200).json({ status: 'success', count: tasks.length, data: tasks });
});

router.put('/:id', (req, res, next) => {
  try {
    const data = validate(updateTaskSchema, req.body);
    const task = TaskModel.update(req.params.id, data);
    if (!task) return next(notFound(req.params.id));
    res.status(200).json({ status: 'success', data: task });
  } catch (err) {
    next(err);
  }
});

router.delete('/:id', (req, res, next) => {
  const deleted = TaskModel.delete(req.params.id);
  if (!deleted) return next(notFound(req.params.id));
  res.status(200).json({ status: 'success', message: 'Task deleted successfully' });
});

module.exports = router;
