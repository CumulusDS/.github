# .github


### Required software
- [commitizen]: Enforces the usage of the Commitizen commit message format for consistent and standardized commits
  - Installation
    - macOS - via [Homebrew][homebrew]: `brew install commitizen`
    - Windows: Install via [pipx], then [follow developer instructions][commitizen-dev-instructions]
- [pre-commit]: A framework for managing and maintaining multi-language pre-commit hooks.
  - Installation
    - Install via pip: `pip install pre-commit` 
- [shellcheck]: ShellCheck is a GPLv3 tool that gives warnings and suggestions for bash/sh shell scripts
  - Installation
    - macOS:
      - via [Homebrew][homebrew]: `brew install shellcheck`
      - via [MacPorts][macports]: `sudo port install shellcheck`
    - Windows:
      - via [Chocolatey][chocolatey]: `C:\> choco install shellcheck` 
      - via [Scoop][scoop]: `C:\> scoop install shellcheck`
      - via [winget]: `C:\> winget install --id koalaman.shellcheck`
    - Docker: `docker run --rm -v "$PWD:/mnt" koalaman/shellcheck:stable myscript`
      - Or replace `stable` with `:v0.4.7` for that version, or `:latest` for daily builds, etc. 

macOS users can install all software by executing the `macos` script under the `install` directory.
From the repository root: 

```zsh
./install/macos
```


[chocolatey]: https://community.chocolatey.org/
[commitizen]: https://github.com/commitizen-tools/commitizen
[commitizen-dev-instructions]: https://github.com/commitizen-tools/commitizen?tab=readme-ov-file#installation
[homebrew]: https://brew.sh/
[macports]: https://www.macports.org/
[pre-commit]: https://github.com/pre-commit/pre-commit
[pipx]: https://pipx.pypa.io/stable/
[shellcheck]: https://github.com/koalaman/shellcheck
[scoop]: https://scoop.sh/
[winget]: https://github.com/microsoft/winget-pkgs
