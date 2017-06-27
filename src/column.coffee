class GridEdit.Column
  constructor: (@attributes, @table) ->
    @id = @index = @table.cols.length
    @defaultValue = @attributes.defaultValue
    @cellClass = @attributes.cellClass
    @cells = []

    format = @attributes.format
    @format = (v) -> if format then format(v) else v
    for key, value of @attributes
      @[key] = value

    if @attributes.label
      @element = document.createElement 'th'
      @textNode = document.createTextNode(@attributes.label)
      @element.appendChild(@textNode)
      @applyStyle()
      do @events


    delete @attributes


  applyStyle: ->
    if @headerStyle
      for styleName of @headerStyle
        @element.style[styleName] = @headerStyle[styleName]
    else
      for styleName of @style
        @element.style[styleName] = @style[styleName]

  next: -> @table.cols[@index + 1]

  previous: -> @table.cols[@index - 1]

  makeActive: ->
    @element.classList.add('active')
    @table.selectedCol = @

  makeInactive: ->
    @element.classList.remove('active')
    @table.selectedCol = null

  events: ->
    col = @
    table = col.table
    @element.onclick = (e) ->
      GridEdit.Utilities::clearActiveCells table
      col.makeActive()
      for cell in col.cells
        cell.addToSelection()
    @element.onmousedown = (e) ->
      if e.which is 3
        table.contextMenu.show(e.x, e.y, col.cells[0])
        return
      false
