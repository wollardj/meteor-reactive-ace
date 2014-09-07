defaultParseOptions =
    loc: true
    range: false
    tokens: true
    tolerant: false
    comments: false




ACE_MODES = {
    abap:       ["ABAP"         , "abap"]
    asciidoc:   ["AsciiDoc"     , "asciidoc"]
    c9search:   ["C9Search"     , "c9search_results"]
    coffee:     ["CoffeeScript" , "Cakefile|coffee|cf|cson"]
    coldfusion: ["ColdFusion"   , "cfm"]
    csharp:     ["C#"           , "cs"]
    css:        ["CSS"          , "css"]
    curly:      ["Curly"        , "curly"]
    dart:       ["Dart"         , "dart"]
    diff:       ["Diff"         , "diff|patch"]
    dot:        ["Dot"          , "dot"]
    ftl:        ["FreeMarker"   , "ftl"]
    glsl:       ["Glsl"         , "glsl|frag|vert"]
    golang:     ["Go"           , "go"]
    groovy:     ["Groovy"       , "groovy"]
    haxe:       ["haXe"         , "hx"]
    haml:       ["HAML"         , "haml"]
    html:       ["HTML"         , "htm|html|xhtml"]
    c_cpp:      ["C/C++"        , "c|cc|cpp|cxx|h|hh|hpp"]
    clojure:    ["Clojure"      , "clj"]
    jade:       ["Jade"         , "jade"]
    java:       ["Java"         , "java"]
    jsp:        ["JSP"          , "jsp"]
    javascript: ["JavaScript"   , "js"]
    json:       ["JSON"         , "json"]
    jsx:        ["JSX"          , "jsx"]
    latex:      ["LaTeX"        , "latex|tex|ltx|bib"]
    less:       ["LESS"         , "less"]
    lisp:       ["Lisp"         , "lisp"]
    scheme:     ["Scheme"       , "scm|rkt"]
    liquid:     ["Liquid"       , "liquid"]
    livescript: ["LiveScript"   , "ls"]
    logiql:     ["LogiQL"       , "logic|lql"]
    lua:        ["Lua"          , "lua"]
    luapage:    ["LuaPage"      , "lp"]
    lucene:     ["Lucene"       , "lucene"]
    lsl:        ["LSL"          , "lsl"]
    makefile:   ["Makefile"     , "GNUmakefile|makefile|Makefile|OCamlMakefile|make"]
    markdown:   ["Markdown"     , "md|markdown"]
    mushcode:   ["TinyMUSH"     , "mc|mush"]
    objectivec: ["Objective-C"  , "m"]
    ocaml:      ["OCaml"        , "ml|mli"]
    pascal:     ["Pascal"       , "pas|p"]
    perl:       ["Perl"         , "pl|pm"]
    pgsql:      ["pgSQL"        , "pgsql"]
    php:        ["PHP"          , "php|phtml"]
    powershell: ["Powershell"   , "ps1"]
    python:     ["Python"       , "py"]
    r:          ["R"            , "r"]
    rdoc:       ["RDoc"         , "Rd"]
    rhtml:      ["RHTML"        , "Rhtml"]
    ruby:       ["Ruby"         , "ru|gemspec|rake|rb"]
    scad:       ["OpenSCAD"     , "scad"]
    scala:      ["Scala"        , "scala"]
    scss:       ["SCSS"         , "scss"]
    sass:       ["SASS"         , "sass"]
    sh:         ["SH"           , "sh|bash|bat"]
    sql:        ["SQL"          , "sql"]
    stylus:     ["Stylus"       , "styl|stylus"]
    svg:        ["SVG"          , "svg"]
    tcl:        ["Tcl"          , "tcl"]
    tex:        ["Tex"          , "tex"]
    text:       ["Text"         , "txt"]
    textile:    ["Textile"      , "textile"]
    tmsnippet:  ["tmSnippet"    , "tmSnippet"]
    toml:       ["toml"         , "toml"]
    typescript: ["Typescript"   , "typescript|ts|str"]
    vbscript:   ["VBScript"     , "vbs"]
    xml:        ["XML"          , "xml|rdf|rss|wsdl|xslt|atom|mathml|mml|xul|xbl|plist"]
    xquery:     ["XQuery"       , "xq"]
    yaml:       ["YAML"         , "yaml"]
}






# Write your package code here!
class @MandrillAce
    constructor: (editorId)->
        @id = editorId
        @_originalValue = ''
        @deps = {}
        @_attachAce()

    ensureDeps: (key)->
        @deps[key] ?= new Tracker.Dependency


    @__live_instance__: null

    _attachAce: ()->
        try
            @ace = ace.edit @id
            @setupEvents()

    @getInstance: ->
        @__live_instance__ ?= new MandrillAce("mandrill_ace")
        @__live_instance__


    # Attempts to detect and set the appropriate mode in ace given a file path.
    detectMode: (path)->
        extension = _.last _.last(path.split('/')).split('.')
        for mode,extensions of ACE_MODES
            patt = new RegExp('^\\\.(' + extensions[1] + ')$')
            if patt.test('.' + extension)
                @setMode 'ace/mode/' + mode
                return

        @setMode('ace/mode/xml')



    ###
    ACE-SPECIFIC STUFF BELOW
    ###




    setupEvents: ->
        self = @
        @ace?.on "change", ->
            self.ensureDeps "value"
            self.ensureDeps "hasChanges"
            self.deps["value"].changed()
            self.deps["hasChanges"].changed()
        @ace?.on "focus", ->
            self.ensureDeps "focus"
            self.deps["focus"].changed()
        @ace?.on "blur", ->
            self.ensureDeps "focus"
            self.deps["focus"].changed()
        @ace?.getSession().on "changeMode", ->
            self.ensureDeps "mode"
            self.deps['mode'].changed()



    value: ->
        @ensureDeps "value"
        @deps['value'].depend()
        @ace?.getValue()

    setValue: (newValue, cursorPos)->
        @ensureDeps "value"
        previousValue = @ace?.getValue()
        if previousValue isnt newValue
            @ace?.setValue newValue, cursorPos
            @_originalValue = newValue
            @deps["value"].changed()
            @deps["hasChanges"].changed()

    hasChanges: ->
        @ensureDeps 'hasChanges'
        @deps['hasChanges'].depend()
        @_originalValue != @ace?.getValue()

    theme: ->
        @ensureDeps 'theme'
        @deps['theme'].depend()
        @ace?.getTheme()

    # If you're going to set the theme and you expect it to be reactive,
    # use this method instead of calling setTheme on ace directly. Ace doesn't
    # appear to have an event that indicates the theme changed.
    setTheme: (aTheme)->
        @ensureDeps 'theme'
        previousValue = @ace?.getTheme()
        @ace?.setTheme aTheme
        if previousValue isnt aTheme
            @deps['theme'].changed()


    mode: ->
        @ensureDeps 'mode'
        @deps['mode'].depend()
        @ace?.getSession().getMode()

    setMode: (aMode)->
        @ensureDeps 'mode'
        previousValue = @ace?.getSession().getMode()
        @ace?.getSession().setMode aMode
        if previousValue isnt aMode
            @deps['mode'].changed()

    readOnly: ->
        @ensureDeps 'readOnly'
        @deps['readOnly'].depend()
        @ace?.getReadOnly()

    setReadOnly: (aBool)->
        @ensureDeps 'readOnly'
        previousValue = @ace?.getReadOnly()
        @ace?.setReadOnly aBool
        if previousValue isnt aBool
            @deps['readOnly'].changed()



    # r/o states
    isFocused: ->
        @ensureDeps('focus')
        @deps['focus'].depend()
        @ace?.isFocused()


MandrillAce = @MandrillAce
