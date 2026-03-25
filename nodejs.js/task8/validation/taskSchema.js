'use strict';

const Joi = require('joi');

const PRIORITIES = ['low', 'medium', 'high'];

const createTaskSchema = Joi.object({
  title: Joi.string().trim().min(1).max(200).required()
    .messages({
      'string.empty': 'Title cannot be empty',
      'any.required': 'Title is required',
    }),
  description: Joi.string().trim().max(1000).optional().allow(''),
  isCompleted: Joi.boolean().optional(),
  priority: Joi.string().valid(...PRIORITIES).optional()
    .messages({ 'any.only': `Priority must be one of: ${PRIORITIES.join(', ')}` }),
  dueDate: Joi.string().isoDate().optional().allow(null, ''),
});

const updateTaskSchema = Joi.object({
  title: Joi.string().trim().min(1).max(200).optional()
    .messages({ 'string.empty': 'Title cannot be empty' }),
  description: Joi.string().trim().max(1000).optional().allow(''),
  isCompleted: Joi.boolean().optional(),
  priority: Joi.string().valid(...PRIORITIES).optional()
    .messages({ 'any.only': `Priority must be one of: ${PRIORITIES.join(', ')}` }),
  dueDate: Joi.string().isoDate().optional().allow(null, ''),
}).min(1).messages({ 'object.min': 'At least one field must be provided for update' });

module.exports = { createTaskSchema, updateTaskSchema };
