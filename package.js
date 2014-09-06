Package.describe({
    summary: "Easily include ace, receive reactive varibles for cursor position, editor contents, etc.",
    version: "1.0.1",
    git: "https://github.com/wollardj/meteor-reactive-ace.git",
    name: "wollardj:ace"
});


path = Npm.require("path");
fs = Npm.require("fs");
packagePath = path.resolve('.')
aceBuildPath = path.join('ace-builds', 'src-min')

Package.onUse(function(api) {
    api.versionsFrom('METEOR@0.9.1');
    api.use("coffeescript")
    acePath = path.join(packagePath, 'ace-builds', 'src-min')
    fs.readdirSync(
        acePath
    ).forEach(function(file) {
        if (file !== "snippets") {
            api.addFiles(
                [path.join(aceBuildPath, file)],
                'client'
            )
        }
    })

    snippetPath = path.join(acePath, 'snippets')
    fs.readdirSync(
        snippetPath
    ).forEach(function(file) {
        api.addFiles([path.join(aceBuildPath, 'snippets', file)], 'client')
    })

    api.addFiles(['wollardj:ace.coffee'], 'client');
    api.export("ReactiveAce", "client");
});
