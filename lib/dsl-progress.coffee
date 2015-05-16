DlsProgressView   = require './dsl-progress-view'
#BuildView         = require './build-view'
BuildProgress     = require './build-progress'
#buildView         = null
buildProgress     = null
{CompositeDisposable} = require 'atom'

module.exports =  DlsProgress =
  dlsProgressView: null
  modalPanel: null
  subscriptions: null
  provider: null

  #Menu Config
  config:
    someSetting:
      type: 'object'
      properties:
        myChildIntOption:
          type: 'integer'
          minimum: 1.5
          maximum: 11.5
    iniPath:
      type: 'string'
      default: ''
      title:'Endereço INI'
      description: 'Informe o endereço do INI'
    pfPath:
      type: 'string'
      default: ''
      title:'Endereço do PF'
      description: 'Informe o endereço do PF'
    prowinPath:
      type: 'string'
      default: ''
      title:'Endereço prowin32'
      description: 'Informe o endereço do prowin32.exe'

  activate: (state) ->
    @dlsProgressView = new DlsProgressView(state.dlsProgressViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @dlsProgressView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    #buildView = new BuildView()
    buildProgress = new BuildProgress()

    # Register commands
    @subscriptions.add atom.commands.add '.editor', 'dsl-progress:syntax_check': => @syntax_check()
    @subscriptions.add atom.commands.add '.editor', 'dsl-progress:code_compile': => @code_compile()
    @subscriptions.add atom.commands.add '.editor', 'dsl-progress:code_run':     => @code_run()
    @subscriptions.add atom.commands.add '.editor', 'dsl-progress:run_edit':     => @run_edit()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @dlsProgressView.destroy()

  serialize: ->
    dlsProgressViewState: @dlsProgressView.serialize()

  snipper_provider: ->
    unless @provider?
      SnippetsProvider = require('./snippets-provider')
      @provider = new SnippetsProvider()

    @provider

  run_edit: ->
    buildProgress.compiler(exec: false, edit: true)

  syntax_check: ->
    #buildView.buildStarted( "Checking Syntax" )
    #@command_code(type: 'check', debug: true, msg: true)

  code_compile: ->
    buildProgress.compiler(exec: false)
    #buildView.buildStarted( "Compiling" )
    #@command_code(type: 'comp', debug: true, msg: true)

  code_run: ->
    buildProgress.compiler(exec: true)
    #buildView.buildStarted( "Running" )
    #@command_code(type: 'comp', debug: true, msg: true, run: true, frun: @command_code)
