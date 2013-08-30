Todo     = require 'model'
TaskView = require 'view'

module.exports = class TodoCtrl extends Monocle.Controller
  events:
    "keypress #new-todo"      : "onCreate"
    "click #clear-completed"  : "onClearCompleted"
    "click #filters li a"     : "onFilter"

  elements:
    "#new-todo"               : "input"
    "#todo-count strong"      : "pending"
    "#todo-count span"        : "pluralize"
    "#clear-completed strong" : "completed"
    "#clear-completed"        : "clear"
    "ul#todo-list"            : "items"
    "#filters li a"           : "filters"

  constructor: ->
    super
    Todo.bind "create", @filterTodos
    Todo.bind "change", @bindChange
    Todo.bind "error", @bindError
    @bindChange()

  bindError: (todo, error) -> alert error

  bindChange: (todo) =>
    @pending.text Todo.active().length
    @pluralize.text (if Todo.active().length is 1 then "item" else "items")
    @completed.text Todo.completed().length
    if Todo.completed().length > 0 then @clear.show() else @clear.hide()

  onCreate: (event) ->
    if event.keyCode is 13
      Todo.create name: @input.val()
      @input.val ""

  onClearCompleted: (event) ->
      Todo.clearCompleted()
      @filterTodos()

  onFilter: (event) ->
    @filters.removeClass "selected"
    filter = @filterName Monocle.Dom(event.currentTarget).addClass "selected"
    @filterTodos filter

  filterTodos: () =>
    @items.html " "
    filter = @filterName @filters.filter(".selected")
    @appendTodo todo for todo in Todo[filter]()

  appendTodo: (todo) ->
    view = new TaskView model: todo
    view.append todo

  filterName: (el) ->
    el.html().toLowerCase()
