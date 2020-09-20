# `vscode-settings`

![GitHub Workflows vscode-settings](https://github.com/banaio/vscode-settings/workflows/vscode-settings/badge.svg)

---

![WORK-IN-PROGRESS](https://img.shields.io/badge/vscode--settings-WORK--IN--PROGRESS-red?style=for-the-badge&logo=visual-studio-code&maxAge=604800&cacheSeconds=604800)

`vscode-settings`: Useful Visual Studio Code settings and snippets when working with Golang, Rust Lang, Shell, and Markdown.

## Snippets

* [`.vscode/golang.code-snippets`](.vscode/golang.code-snippets).
* [`.vscode/makefile.code-snippets`](.vscode/makefile.code-snippets).
* [`.vscode/markdown.code-snippets`](.vscode/markdown.code-snippets).
* [`.vscode/rustlang.code-snippets`](.vscode/rustlang.code-snippets).
* [`.vscode/shell.code-snippets`](.vscode/shell.code-snippets).

```sh
$ ls -1 .vscode/* | sort | grep '.code-snippets'
.vscode/golang.code-snippets
.vscode/makefile.code-snippets
.vscode/markdown.code-snippets
.vscode/rustlang.code-snippets
.vscode/shell.code-snippets
```

### Snippets Available

```sh
$ ./scripts/print_all_snippets.sh
...
---------------------------------------------------------------------------------------------------------------------------------------------------------------
SNIPPET_FILE=.vscode/markdown.code-snippets

name=markdown-link-code, prefix=["markdown-link-code"]
name=markdown-link-title, prefix=["markdown-link-title"]
---------------------------------------------------------------------------------------------------------------------------------------------------------------
SNIPPET_FILE=.vscode/rustlang.code-snippets

name=rustlang-func, prefix=rustlang-func
---------------------------------------------------------------------------------------------------------------------------------------------------------------
SNIPPET_FILE=.vscode/shell.code-snippets

name=shell-dir-and-file-exists, prefix=shell-dir-and-file-exists
name=shell-dir-exists, prefix=shell-dir-exists
name=shell-file-exists, prefix=shell-file-exists
name=shell-binary-exists, prefix=shell-binary-exists
---------------------------------------------------------------------------------------------------------------------------------------------------------------
SNIPPET_FILE=.vscode/golang.code-snippets

name=add-package-name-and-init-method, prefix=["go","go-add-package-name-and-init-method","go-apbaim"]
name=if-err-not-nil-with-else-if-value-not-nil, prefix=["go","go-if-err-not-nil-with-else-if-value-not-nil","go-giennweivnn"]
name=new-constructor, prefix=["go","go-new-constructor","go-nc"]
name=struct-field, prefix=["go","go-struct-field","go-sf"]
name=struct-field-with-json-tag, prefix=["go","go-struct-field-with-json-tag","go-sfj"]
name=struct-field-with-yaml-tag, prefix=["go","go-struct-field-with-yaml-tag","go-sfy"]
name=struct-field-tag, prefix=["go","go-struct-field-tag","go-tagj"]
name=new-test-function-with-stretchr-testify-require, prefix=["go","go-new-test-function-with-stretchr-testify-require"]
name=stretchr-testify-require-equal, prefix=["go","go-testify-require-equal"]
name=stretchr-testify-require-noerror, prefix=["go","go-testify-require-noerror"]
name=stretchr-testify-require-notnil, prefix=["go","go-stretchr-testify-require-notnil"]
name=stretchr-testify-require-notnilf, prefix=["go","go-stretchr-testify-require-notnilf"]
name=stretchr-testify-require-equalerror, prefix=["go","go-stretchr-testify-require-equalerror"]
name=stretchr-testify-require-noerror-and-stretchr-testify-require-notnil, prefix=["go","go-stretchr-testify-require-noerror-and-stretchr-testify-require-notnil"]
name=new-test-function-with-stretchr-testify-assert, prefix=["go","go-new-test-function-with-stretchr-testify-assert"]
name=stretchr-testify-assert-equal, prefix=["go","go-testify-assert-equal"]
name=stretchr-testify-assert-noerror, prefix=["go","go-testify-assert-noerror"]
name=stretchr-testify-assert-notnil, prefix=["go","go-stretchr-testify-assert-notnil"]
name=stretchr-testify-assert-notnilf, prefix=["go","go-stretchr-testify-assert-notnilf"]
name=stretchr-testify-assert-equalerror, prefix=["go","go-stretchr-testify-assert-equalerror"]
name=stretchr-testify-assert-noerror-and-stretchr-testify-assert-notnil, prefix=["go","go-stretchr-testify-assert-noerror-and-stretchr-testify-assert-notnil"]
name=testing.skipf, prefix=["go","go-testing.skipf"]
---------------------------------------------------------------------------------------------------------------------------------------------------------------
SNIPPET_FILE=.vscode/makefile.code-snippets

name=makefile-target, prefix=["makefile","makefile-target",".PHONY"]
````

## Docs

* [`./docs/VSCODE.md`](./docs/VSCODE.md).
* [`./docs/GITHUB-CLI.md`](./docs/GITHUB-CLI.md): Also see [`./scripts/install_github-cli.sh`](./scripts/install_github-cli.sh).
* [`./docs/USAGE.md`](./docs/USAGE.md).
* [`./docs/TESTS.md`](./docs/TESTS.md).
* [`./docs/DEBUG.md`](./docs/DEBUG.md).
* [`./docs/TODO.md`](./docs/TODO.md).

## References or Links

See [`./docs/VSCODE.md`](./docs/VSCODE.md):

* [Snippets in Visual Studio Code](https://code.visualstudio.com/docs/editor/userdefinedsnippets).
* [How to create per workspace snippets in VSCode?](https://stackoverflow.com/questions/44312494/how-to-create-per-workspace-snippets-in-vscode).
