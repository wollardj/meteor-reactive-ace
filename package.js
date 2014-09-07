Package.describe({
    summary: "AceEditor with reactive goodies, designed for the Mandrill project.",
    version: "1.0.2",
    git: "https://github.com/wollardj/meteor-reactive-ace.git",
    name: "mandrill:ace"
});


path = Npm.require("path");
fs = Npm.require("fs");
packagePath = path.resolve(".")
if ( fs.existsSync(path.join(packagePath, 'packages')) ) {
    // We're live testing, not publishing, so we need to alter the path
    packagePath = path.join(packagePath, 'packages', 'mandrill:ace')
}



Package.onUse(function(api) {
    aceBuildPath = path.join('ace-builds', 'src-min')
    api.versionsFrom('METEOR@0.9.1');
    api.use("coffeescript");
    api.use("standard-app-packages");
    acePath = path.join(packagePath, 'ace-builds', 'src-min');
    fs.readdirSync(
        acePath
    ).forEach(function(file) {
        if (file !== "snippets") {
            api.addFiles(
                [path.join(aceBuildPath, file)],
                'client'
            );
        }
    });


    snippetPath = path.join(acePath, 'snippets');
    fs.readdirSync(
        snippetPath
    ).forEach(function(file) {
        api.addFiles([path.join(aceBuildPath, 'snippets', file)], 'client');
    });

    api.addFiles(
        [
            'mandrill:ace.coffee',
            'mandrill_ace.html',
            'mandrill_ace.coffee'
        ],
        'client'
    );
    api.export("MandrillAce", "client");
});
