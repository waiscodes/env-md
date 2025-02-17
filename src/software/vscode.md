# VSCode / Codium / Cursor / whatever IDE is hot these days

## Tips & Tricks

### Auto Import Missing Imports

This is going to be a life-saver. From the days in Eclipse where `ctrl+shift+o` would auto-import missing imports.
I introduce, the feature already built into VSCode but for some reason not a default keybind.

Open `ctrl+shift+p` and type `open keyboard shortcuts` and press enter.

Throw the following in your `keybindings.json` file:

```json
{
    "key": "ctrl+shift+i",
    "command": "editor.action.codeAction",
    "args": {
        "kind": "source.addMissingImports",
        "apply": "ifSingle"
    },
    "when": "editorHasCodeActionsProvider && editorTextFocus && !editorReadonly"
}
```

Now every time you press `ctrl+shift+i` it will auto-import missing imports.

PS you can trigger this by hand by clicking on the "Quick Fix" button next to the error and then selecting "Add All Missing Imports".
