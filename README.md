meteor:ace
===================

Easily include ace, receive reactive varibles for cursor position, editor contents, etc. Inspired by Madeye's reactive-ace project but updated for Meteor 0.9.1


## Quick Start

Add the package to your Meteor project
```
meteor add mandrill:ace
```

Include the template where ever you'd like the Ace Editor to appear
```
{{>mandrill_ace}}
```

Grab the running instance of the controlling object and have fun!
```
var editor = MandrillAce.getInstance();
editor.setValue("Sooper!");
```

## API

#### Properties
  - `editor.ace`: MandrillAce doesn't wrap all of Ace's logic, so sometimes you might want to get access to the real thing.
  - `editor.id`: The identifier that was most recently passed to `ace.edit(id)`

#### Static Methods
  - `getInstance()`: returns the instance of MandrillAce that was created when you embedded the template somewhere (`{{>mandrill_ace}}`)

#### Instance Methods
  - `detectMode(path)`: Compares the file extension of the `path` (a string object) given and attempts to set Ace's syntext highlighting mode to the correct type. Since this is for the Mandrill project, which deals almost entirely with XML files, it falls back to XML when the type can't be determined.
  - `value()`: a reactive way to obtain the current text within the Ace editor
  - `setValue(aString)`: shortcut to replacing the body of the current editor. A call to this method will set `hasChanges()` to `false`.
  - `hasChanges()`: reactive boolean indicating whether the user has modified the original text.
  - `theme()`: reactive string containing the current theme Ace is using.
  - `setTheme(someTheme)`: Tells Ace to use `someTheme`
  - `mode()`: reactive string indicating the current mode Ace is using for syntaxt checking and highlighting.
  - `setMode(someMode)`: Tells Ace to use `someMode` for syntax checking and highlighting
  - `readOnly()`: reactive bool; _is ace is read-only mode or no?_
  - `setReadOnly(aBool)`: _picking up on a pattern yet?_
  - `isFocused()`: a reactive boolean. There is no isBlurred method because the reactivity involved ends up making that  unneccessary.

## What Good Is Reactivity With Ace?

You could enable/disable a custom save button based on the output of `hasChanges()`. You could dim/brighten surrounding components dynamically by tying an appropriate css class to them based on the output of `isFocused()`. Maybe you want to use the `detectMode()` method to get syntax highlighting correct, but you'd also like to display the mode somewhere on the page; use the `mode()` method.

Here's a quick example using that last scenario with the modes.
```
<template name="myAwesomeTpl">
  <p>
    Looks like you're editing in {{mode}} mode.
  </p>
</template>
```

```
Template.myAwesomeTpl.mode = function() {
  return MandrillAce.getInstance().mode()
}
```

That's pretty much all there is to it as long as whatever mechanism you're using to load new content into the editor also has the ability to pass a filename or path to `detectMode()`, _or_, if the mode is changed by some other means.
