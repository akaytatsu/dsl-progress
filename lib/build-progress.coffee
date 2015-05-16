dslAtom       = require('atom')
exec          = require('child_process').exec
command       = null
command_comp  = null
command_run   = null
BuildView     = require './build-view'
buildView     = null
BuildManager  = require('./build-manager')
buildManager  = null

module.exports =
class BuildProgress
  ini       = null
  pf        = null
  prowin    = null
  pro       = null
  comFile   = null
  runFile   = null
  tempFol   = null
  editor    = null
  fPath     = null
  ft        = null

  constructor: ->
    ini       = atom.config.get('dsl-progress.iniPath')
    pf        = atom.config.get('dsl-progress.pfPath')
    prowin    = atom.config.get('dsl-progress.prowinPath')
    pro       = prowin.replace("prowin32", "_progres")
    comFile   = __dirname + "/progress/compile.p"
    runFile   = __dirname + "/progress/run.p"
    tempFol   = require('os').tmpdir() + "\\dsl_build.txt"
    buildView = new BuildView()
    buildManager = new BuildManager()

  validate_file: ->
    (ft in ["p", "w"])

  compiler: (params) ->
    editor    = atom.workspace.getActiveTextEditor()
    fPath     = editor.getPath()
    ft        = fPath.split( "." ).pop(-1)

    if @validate_file()
      buildView.buildStarted( "Compiling" )
      #command       = "#{pro} -1 -b -basekey \"ini\" -ininame \"#{ini}\" -pf \"#{pf}\" -p \"#{comFile}\" -param \"#{fPath}\""
      command_comp  = "#{prowin} -1 -b -basekey \"ini\" -ininame \"#{ini}\" -pf \"#{pf}\" -p \"#{comFile}\" -param \"#{fPath}\" > \"#{tempFol}\""
      command_run   = "#{prowin} -basekey \"ini\" -ininame \"#{ini}\" -pf \"#{pf}\" -p \"#{runFile}\" -param \"#{fPath}\""
      command_edit  = "#{prowin} -basekey \"ini\" -ininame \"#{ini}\" -pf \"#{pf}\" -p \"#{runFile}\" -param \"_dict.r\""

      if params['edit'] == true
        buildView.append("data dictionary...")
        exec(command_edit, (error, stdout, stderr) ->
          buildView.buildFinished("Success!", true)
          atom.workspaceView.getActiveView().focus()
        )
      else
        buildView.append("checking syntax... ")
        console.log(command_comp)
        exec( command_comp, (error, stdout, stderr) ->
          buildManager.getFile tempFol, (arrErro, fullMsg)->
            if arrErro.length > 0
              buildView.append("-------------------------------------")
              buildView.append(fullMsg)
              buildView.append("-------------------------------------")
              buildView.buildFinished("Syntax error!",false)

              currentRow = editor.getCursorBufferPosition().row
              row = arrErro[0].row - 1
              col = arrErro[0].col - 1
              position = new dslAtom.Point(row, col)
              editor.scrollToBufferPosition(position, center: true)
              editor.setCursorBufferPosition(position)
              if col < 0
                editor.moveToFirstCharacterOfLine()
            else
              if params['exec'] == true

                buildView.append("compiling...")
                console.log(command_comp)
                exec(command_comp, (error, stdout, stderr) ->

                  buildView.append("running...")
                  exec(command_run, (error, stdout, stderr) ->
                    buildView.buildFinished("Success!", true)
                  )
                )
              else
                buildView.buildFinished("Success!", true)

            atom.workspaceView.getActiveView().focus()
          ###
          if stdout.substring(0, 5) == "ERROR"
            buildView.append("-------------------------------------")
            buildView.append(stdout)
            buildView.append("-------------------------------------")
            buildView.buildFinished("Syntax error!",false)
          else
            if params['exec'] == true

              buildView.append("compiling...")
              exec(command_comp, (error, stdout, stderr) ->

                buildView.append("running...")
                exec(command_run, (error, stdout, stderr) ->
                  buildView.buildFinished("Success!", true)
                )
              )
            else
              buildView.buildFinished("Success!", true)
          ###
        )
