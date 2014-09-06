defaultParseOptions =
    loc: true
    range: false
    tokens: true
    tolerant: false
    comments: false



# Write your package code here!
class @ReactiveAce
    constructor: (editorId)->
        @id = editorId
        @ace = ace.edit @id
        @_originalValue = ''
        @deps = {}
        @setupEvents()

    ensureDeps: (key)->
        @deps[key] ?= new Tracker.Dependency


    ###
        Returns an object representing the supported themes
    ###
    listThemes: ()->
        [
            {
                group: "Bright"
                themes: [
                    {name: "Chrome", path: "ace/theme/chrome"}
                    {name: "Clouds", path: "ace/theme/clouds"}
                    {name: "Crimson Editor", path: "ace/theme/crimson_editor"}
                    {name: "Dawn", path: "ace/theme/dawn"}
                    {name: "Dreamweaver", path: "ace/theme/dreamweaver"}
                    {name: "Eclipse", path: "ace/theme/eclipse"}
                    {name: "GitHub", path: "ace/theme/github"}
                    {name: "Solarized Light", path: "ace/theme/solarized_light"}
                    {name: "TextMate", path: "ace/theme/textmate"}
                    {name: "Tomorrow", path: "ace/theme/tomorrow"}
                    {name: "XCode", path: "ace/theme/xcode"}
                    {name: "Kuroir", path: "ace/theme/kuroir"}
                    {name: "KatzenMilch", path: "ace/theme/katzenmilch"}
                ]
            }
            {
                group: "Dark"
                themes: [
                    {name: "Ambiance", path: "ace/theme/ambiance"}
                    {name: "Chaos", path: "ace/theme/chaos"}
                    {name: "Clouds Midnight", path: "ace/theme/clouds_midnight"}
                    {name: "Cobalt", path: "ace/theme/cobalt"}
                    {name: "idle Fingers", path: "ace/theme/idle_fingers"}
                    {name: "krTheme", path: "ace/theme/kr_theme"}
                    {name: "Merbivore", path: "ace/theme/merbivore"}
                    {name: "Merbivore Soft", path: "ace/theme/merbivore_soft"}
                    {name: "Mono Industrial", path: "ace/theme/mono_industrial"}
                    {name: "Monokai", path: "ace/theme/monokai"}
                    {name: "Pastel on dark", path: "ace/theme/pastel_on_dark"}
                    {name: "Solarized Dark", path: "ace/theme/solarized_dark"}
                    {name: "Terminal", path: "ace/theme/terminal"}
                    {name: "Tomorrow Night", path: "ace/theme/tomorrow_night"}
                    {name: "Tomorrow Night Blue", path: "ace/theme/tomorrow_night_blue"}
                    {name: "Tomorrow Night Bright", path: "ace/theme/tomorrow_night_bright"}
                    {name: "Tomorrow Night 80s", path: "ace/theme/tomorrow_night_eighties"}
                    {name: "Twilight", path: "ace/theme/twilight"}
                    {name: "Vibrant Ink", path: "ace/theme/vibrant_ink"}
                ]
            }
        ]




    ###
    ACE-SPECIFIC STUFF BELOW
    ###




    setupEvents: ->
        self = @
        @ace.on "change", ->
            self.ensureDeps "value"
            self.ensureDeps "hasChanges"
            self.deps["value"].changed()
            self.deps["hasChanges"].changed()
        @ace.on "focus", ->
            self.ensureDeps "focus"
            self.deps["focus"].changed()
        @ace.on "blur", ->
            self.ensureDeps "focus"
            self.deps["focus"].changed()
        @ace.getSession().on "changeMode", ->
            self.ensureDeps "mode"
            self.deps['mode'].changed()



    value: ->
        @ensureDeps "value"
        @deps['value'].depend()
        @ace.getValue()

    setValue: (newValue, cursorPos)->
        @ensureDeps "value"
        previousValue = @ace.getValue()
        if previousValue isnt newValue
            @ace.setValue newValue, cursorPos
            @_originalValue = newValue
            @deps["value"].changed()
            @deps["hasChanges"].changed()

    hasChanges: ->
        @ensureDeps 'hasChanges'
        @deps['hasChanges'].depend()
        @_originalValue != @ace.getValue()

    theme: ->
        @ensureDeps 'theme'
        @deps['theme'].depend()
        @ace.getTheme()

    # If you're going to set the theme and you expect it to be reactive,
    # use this method instead of calling setTheme on ace directly. Ace doesn't
    # appear to have an event that indicates the theme changed.
    setTheme: (aTheme)->
        @ensureDeps 'theme'
        previousValue = @ace.getTheme()
        @ace.setTheme aTheme
        if previousValue isnt aTheme
            @deps['theme'].changed()


    mode: ->
        @ensureDeps 'mode'
        @deps['mode'].depend()
        @ace.getSession().getMode()

    setMode: (aMode)->
        @ensureDeps 'mode'
        previousValue = @ace.getSession().getMode()
        @ace.getSession().setMode aMode
        if previousValue isnt aMode
            @deps['mode'].changed()

    readOnly: ->
        @ensureDeps 'readOnly'
        @deps['readOnly'].depend()
        @ace.getReadOnly()

    setReadOnly: (aBool)->
        @ensureDeps 'readOnly'
        previousValue = @ace.getReadOnly()
        @ace.setReadOnly aBool
        if previousValue isnt aBool
            @deps['readOnly'].changed()



    # r/o states
    isFocused: ->
        @ensureDeps('focus')
        @deps['focus'].depend()
        @ace.isFocused()


ReactiveAce = @ReactiveAce
