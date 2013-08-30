class Monocle.Controller extends Monocle.Module

    @include Monocle.Events

    eventSplitter: /^(\S+)\s*(.*)$/
    tag: 'div'

    ###
    Constructor of Monocle.Controller based on Monocle.Module
    @method constructor
    @param  {options} Create properties within the controller or an element selector if the type is string.
    ###
    constructor: (options) ->
        if typeof options is "string"
            @el = Monocle.Dom options
        else
            @[key] = value for key, value of options

        @el = Monocle.Dom(document.createElement(@tag)) unless @el
        # if @el.length
        @events = @constructor.events unless @events
        @elements = @constructor.elements unless @elements

        do @delegateEvents if @events
        do @refreshElements if @elements
        super
        # else
        #   undefined

    delegateEvents: ->
        for key, method of @events
            unless typeof(method) is 'function'
                method = @proxy(@[method])

            match      = key.match(@eventSplitter)
            eventName  = match[1]
            selector   = match[2]

            if selector is ''
                @el.bind(eventName, method)
            else
                @el.delegate(selector, eventName, method)

    refreshElements: ->
        for key, value of @elements
            @[value] = @el.find(key)

    destroy: =>
        @trigger 'release'
        @el.remove()
        @unbind()
