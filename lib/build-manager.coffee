module.exports =
class BuildManager

  file:     null
  error:    null
  dslErrArray: null
  callback: null

  constructor: ->


  isError: ->
    if @getErrArray().length > 0
      true
    else
      false

  getFile:(file_log, callback) =>
    @callback = callback
    @dslErrArray = []
    @file = file_log
    require('fs').readFile @file, 'utf8', @process

  addErro: (arr) =>
    @dslErrArray.push arr

  getErrArray: =>
    @dslErrArray

  process: (err, data) =>
    if data.substring(0,7) != "SUCCESS"
      arrLog = data.split("\n")
      for d, i in arrLog
        console.log( d )
        if d.substring(0,5) == "ERROR"
          arrData =  {
            col: /Col:([0-9]+)/i.exec( d )[1],
            error: /Error:([0-9]+)\s/i.exec( d )[1],
            row: /Row:([0-9]+)\s/i.exec( d )[1],
            msg: /Message:(.+)[:|.|(]/i.exec( d )[1]
          }
          @addErro(arrData)
    @callback( @dslErrArray, data )
