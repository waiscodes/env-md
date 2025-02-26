# Configuration

## TOML

## Rust Crates

Rust has a few crates that allow for ridiculously powerful configuration management.
The most notable ones are `config` and `figment`.
They are capable of partial loading from env, config files, and more.

### Validation

Although at the time of writing this (2025-02-26), TOML does not yet have a standard for validation.
However, the [Taplo project](https://taplo.tamasfe.dev/) has an implementation called [directives](https://taplo.tamasfe.dev/configuration/directives.html#the-schema-directive) that can be used to validate the configuration.

You can unlock validation support in VSCode by installing the [Even Better TOML](https://marketplace.visualstudio.com/items?itemName=tamasfe.even-better-toml) extension.

#### Adding validation to your configuration

To add validation to your configuration, you need to add the `#:schema ./schema.json` directive to the root of your configuration file.

```toml
#:schema https://json.schemastore.org/github-action.json
```

This also has additional support for URLs, allowing you to easily validate your own configurations against a schema.
