# Customization Options

Configuring mnml is just a matter of setting some variables. Below, you'll find a
list of all possible options that you can set that will override mnml appearance
and functionality.

## Table of Contents

- [Customization Options](#customization-options)
  - [Table of Contents](#table-of-contents)
  - [`mnml_docker_machine.zsh`](#mnmldockermachinezsh)
  - [`mnml_exec_time.zsh`](#mnmlexectimezsh)
  - [`mnml_git.zsh`](#mnmlgitzsh)
        - [`mnml_git_stashes()`](#mnmlgitstashes)
        - [`mnml_git_time()`](#mnmlgittime)
        - [`mnml_git_branch()`](#mnmlgitbranch)
        - [`mnml_git_status()`](#mnmlgitstatus)
        - [`mnml_git_rebase()`](#mnmlgitrebase)
        - [`mnml_git_remote() `](#mnmlgitremote)
        - [`mnml_git_conflicts()`](#mnmlgitconflicts)
        - [`mnml_git()`](#mnmlgit)
        - [`mnml::git_wrapper`](#mnmlgitwrapper)
  - [`mnml_hg.zsh`](#mnmlhgzsh)
  - [`mnml_hostname.zsh`](#mnmlhostnamezsh)
  - [`mnml_jobs.zsh`](#mnmljobszsh)
  - [`mnml_kube.zsh`](#mnmlkubezsh)
  - [`mnml_node.zsh`](#mnmlnodezsh)
  - [`mnml_npm_package_version.zsh`](#mnmlnpmpackageversionzsh)
  - [`mnml_path.zsh`](#mnmlpathzsh)
  - [`mnml_ruby.zsh`](#mnmlrubyzsh)
  - [`mnml_rust_version.zsh`](#mnmlrustversionzsh)
  - [`mnml_rustup.zsh`](#mnmlrustupzsh)
  - [`mnml_status.zsh`](#mnmlstatuszsh)
  - [`mnml_virtualenv.zsh`](#mnmlvirtualenvzsh)



## `mnml_docker_machine.zsh`

Show the docker machine name.

| Variable                         | Description                     | Defaults |
| ---------------------------- | ------------------------------- | -------- |
| `MNML_DOCKER_MACHINE_SYMBOL` | Indicator.                      | `⚓`      |
| `MNML_DOCKER_MACHINE_COLOR`  | Text color of the machine name. | `blue`   |

## `mnml_exec_time.zsh`

Show the elapsed time for long running commands.

| Variable                      | Description                                   | Defaults |
| ------------------------- | --------------------------------------------- | -------- |
| `MNML_EXEC_TIME_FILE`     | Path to temp direcotry, where file is stored. |          |
| `MNML_EXEC_TIME_PATIENCE` | Seconds before the time is shown.             |          |

## `mnml_git.zsh`

Show git related information, such as branch name, status and time since last commit.

| Variable            | Description                     | Defaults             |
| --------------- | ------------------------------- | -------------------- |
| `MNML_GIT_GREP` | Used to override our searching. | `rg` > `ag` > `grep` |

##### `mnml_git_stashes()`

| Variable                      | Description | Defaults |
| ------------------------- | ----------- | -------- |
| `MNML_GIT_SYMBOL_STASHES` | Indicator.  | `●`      |
| `MNML_GIT_COLOR_STASHES`  | Color.      | `144`    |

##### `mnml_git_time()`
| Variable                          | Description                                 | Defaults     |
| ----------------------------- | ------------------------------------------- | ------------ |
| `MNML_COLOR_NO_TIME`          | Text color.                                 | `white`      |
| `MNML_GIT_NO_COMMITS_MESSAGE` | Text message shown when there's no commits. | `no-commits` |
| `MNML_GIT_TIME_DETAILED`      | Detailed timestamp instead of simple.       | `false`      |

##### `mnml_git_branch()`

| Variable                    | Description            | Defaults |
| ----------------------- | ---------------------- | -------- |
| `MNML_GIT_COLOR_BRANCH` | Color for branch name. | `242`    |

##### `mnml_git_status()`

| Variable                    | Description                | Defaults |
| ----------------------- | -------------------------- | -------- |
| `MNML_GIT_COLOR_DIRTY`  | Color for dirty indicator. | `red`    |
| `MNML_GIT_SYMBOL_DIRTY` | Indicator when dirty.      | `⬡`      |
| `MNML_GIT_COLOR_CLEAN`  | Color for clean indicator. | `green`  |
| `MNML_GIT_SYMBOL_CLEAN` | Indicator when clean.      | `⬢`      |

##### `mnml_git_rebase()`

| Variable                     | Description | Defaults |
| ------------------------ | ----------- | -------- |
| `MNML_GIT_SYMBOL_REBASE` | Indicator.  | `®`      |

##### `mnml_git_remote() `

| Variable                       | Description         | Defaults |
| -------------------------- | ------------------- | -------- |
| `MNML_GIT_SYMBOL_UNPUSHED` | Unpushed indicator. | `⇡`      |
| `MNML_GIT_SYMBOL_UNPULLED` | Unpulled indicator. | `⇣`      |

##### `mnml_git_conflicts()`

| Variable                                 | Description                   | Defaults |
| ------------------------------------ | ----------------------------- | -------- |
| `MNML_GIT_COLOR_CONFLICTS_UNSOLVED`  | Unsolved conflicts color.     | `red`    |
| `MNML_GIT_COLOR_CONFLICTS_SOLVED`    | Solved conflicts color.       | `green`  |
| `MNML_GIT_SYMBOL_CONFLICTS_SOLVED`   | Solved conflicts indicator.   | `◆`      |
| `MNML_GIT_SYMBOL_CONFLICTS_UNSOLVED` | Unsolved conflicts indicator. | `◈`      |

##### `mnml_git()`

| Variable                   | Description | Defaults |
| ---------------------- | ----------- | -------- |
| `MNML_GIT_COLOR_BARE`  | Color.      | `blue`   |
| `MNML_GIT_SYMBOL_BARE` | Indicator.  | `⬢`      |

##### `mnml::git_wrapper`

| Variable                 | Description                   | Defaults |
| -------------------- | ----------------------------- | -------- |
| `MNML_GIT_SEPARATOR` | Separator for the indicators. | `::`     |

## `mnml_hg.zsh`

Show Mercurial related information, such as branch name, status and time since last commit.

| Variable                       | Description                     | Defaults |
| -------------------------- | ------------------------------- | -------- |
| `MNML_HG_COLOR_BRANCH`     | Color for branch name.          | `242`    |
| `MNML_HG_COLOR_DIRTY`      | Color for dirty indicator.      | `red`    |
| `MNML_HG_SYMBOL_DIRTY`     | Indicator for dirty repository. | `⬡`      |
| `MNML_HG_COLOR_CLEAN`      | Color for clean indicator.      | `green`  |
| `MNML_HG_SYMBOL_CLEAN`     | Idicator for clean repository.  | `⬢`      |
| `MNML_HG_SYMBOL_SEPARATOR` | Separator for the indicators.   | `::`     |

## `mnml_hostname.zsh`

Shows user and hostname information, by default in the `enter` prompt.

| Variable                      | Description                                                               | Defaults    |
| ------------------------- | ------------------------------------------------------------------------- | ----------- |
| `MNML_HOSTNAME_HIDE_ON`   | Don't show the username and hostname indicator when the hostname matches. | `localhost` |
| `MNML_HOSTNAME_SEPARATOR` | Separator between user and hostname.                                      | `@`         |

## `mnml_jobs.zsh`

Shows background jobs, by default in the `enter` prompt.

| Variable               | Description              | Defaults |
| ------------------ | ------------------------ | -------- |
| `MNML_JOBS_SYMBOL` | Indicator.               | `⚙`      |
| `MNML_JOBS_COLOR`  | Color for the indicator. | `blue`   |

## `mnml_kube.zsh`

Show kubectl (Kubernetes) client version and current context/namespace.

| Variable               | Description                                | Defaults |
| ------------------ | ------------------------------------------ | -------- |
| `MNML_KUBE_COLOR`  | Color for the indicator.                   | `blue`   |
| `MNML_KUBE_SYMBOL` | Indicator.                                 | `⎈`      |
| `MNML_KUBE_PIN`    | Can be set to always show `mnml_kube`. |          |

## `mnml_node.zsh`

Show node and npm/yarn version when in a node project context.

| Variable               | Description                                                                                  | Defaults |
| ------------------ | -------------------------------------------------------------------------------------------- | -------- |
| `MNML_NODE_SYMBOL` | Indicator.                                                                                   | `⬡`      |
| `MNML_NODE_COLOR`  | Color for the indicator.                                                                     | `green`  |
| `MNML_NODE_PIN`    | Can be setup to always show `mnml_node` outside of the context of a node project folder. |          |

## `mnml_npm_package_version.zsh`

Display the current folder's npm package version from package.json (by @drager)

| Variable                                    | Description              | Defaults |
| --------------------------------------- | ------------------------ | -------- |
| `MNML_NPM_PACKAGE_VERSION_SYMBOL`       | Indicator.               | `📦`     |
| `MNML_NPM_PACKAGE_VERSION_SYMBOL_COLOR` | Color for the indicator. | `red`    |
| `MNML_NPM_PACKAGE_VERSION_COLOR`        | Text color.              | `red`    |

## `mnml_path.zsh`

Show the current path.

| Variable                      | Description                             | Defaults |
| ------------------------- | --------------------------------------- | -------- |
| `MNML_PATH_SYMBOL_HOME`   | Symbol representing the home directory. | `%3~`    |
| `MNML_PATH_SHOW_BASENAME` | -                                       | `false`  |
| `MNML_PATH_COLOR`         | Color for path.                         | `blue`   |

## `mnml_ruby.zsh`

Display the current ruby version, rvm version, and gemset.

| Variable                        | Description      | Defaults |
| --------------------------- | ---------------- | -------- |
| `MNML_RUBY_SYMBOL`          | Indicator.       | `◆`      |
| `MNML_RUBY_COLOR`           | Indicator color. | `white`  |
| `MNML_RUBY_RVM_SHOW_GEMSET` | Show RVM gemset. | `true`   |

## `mnml_rust_version.zsh`

Display the current version of rust (by @drager).

| Variable                      | Description        | Defaults |
| ------------------------- | ------------------ | -------- |
| `MNML_RUST_VERSION_COLOR` | Color for version. | `red`    |

## `mnml_rustup.zsh`

Display a symbol colored with the currently selected rustup toolchain.

| Variable                        | Description                                                | Defaults |
| --------------------------- | ---------------------------------------------------------- | -------- |
| `MNML_RUSTUP_SYMBOL`        | Indicator.                                                 | `⚙`      |
| `MNML_RUSTUP_STABLE_COLOR`  | Stable color.                                              | `green`  |
| `MNML_RUSTUP_BETA_COLOR`    | Beta color.                                                | `yellow` |
| `MNML_RUSTUP_NIGHTLY_COLOR` | Nightly color.                                             | `red`    |
| `MNML_RUSTUP_PIN`           | Can be setup to keep rustup rendering even out of context. |          |

## `mnml_status.zsh`

Show a symbol with error/success and root/non-root information.

| Variable                            | Description                                            | Defaults |
| ------------------------------- | ------------------------------------------------------ | -------- |
| `MNML_STATUS_SYMBOL`            | Non-root indicator.                                    | `▲`      |
| `MNML_STATUS_SYMBOL_ERROR`      | Non-root indicator on error.                           | `△`      |
| `MNML_STATUS_SYMBOL_ROOT`       | Root indicator.                                        | `▼`      |
| `MNML_STATUS_SYMBOL_ROOT_ERROR` | root indicator on error.                               | `▽`      |
| `MNML_STATUS_COLOR`             | Indicator color.                                       | `white`  |
| `MNML_STATUS_COLOR_ERROR`       | Indicator color on error.                              | `red`    |
| `MNML_STATUS_SYMBOL_COLOR_HASH` | Automatically pick a color based on the hostname hash. | `false`  |

## `mnml_virtualenv.zsh`

Show the current `virtualenv` or `conda` environment.

| Variable                              | Description     | Defaults |
| --------------------------------- | --------------- | -------- |
| `MNML_VIRTUALENV_CONDA_SEPARATOR` | Text separator. | `:`      |
| `MNML_VIRTUALENV_COLOR`           | Text color.     | `green`  |
| `MNML_VIRUALENV_CONDA_COLOR`      | Text color.     | `green`  |
