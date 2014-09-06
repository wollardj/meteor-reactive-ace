Package.describe({
    summary: "Easily include ace, receive reactive varibles for cursor position, editor contents, etc.",
    version: "1.0.0",
    git: "https://github.com/wollardj/meteor-reactive-ace.git",
    name: "wollardj:ace"
});


path = Npm.require("path");
fs = Npm.require("fs");
packagePath = path.resolve('.')

Package.onUse(function(api) {
    api.versionsFrom('METEOR@0.9.1');
    var files = fs.readdirSync(path.join(packagePath, 'ace-builds', 'src-min'))
    files.forEach(function(file) {
        if (file !== "snippets") {
            api.addFiles(
                [path.join(packagePath, 'ace-builds', 'src-min', file)],
                'client'
            )
        }
    })

    var snippets = fs.readdirSync(
        path.join(packagePath, 'ace-builds', 'src-min', 'snippets'));

    snippets.forEach(function(file) {
        snippetPath = path.join(
            packagePath, 'ace-builds', 'src-min', 'snippets', file)
        api.addFiles([snippetPath], 'client')
    })

    api.addFiles(['wollardj:ace.coffee'], 'client');
    api.export("ReactiveAce", "client");
});
