Todo     = require 'model'
TaskView = require 'view'
Todos    = require 'controller'

$$ ->
  new Todos('section#todoapp')
