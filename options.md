# Customization Options

Configuring Geometry is just a matter of setting some variables. Below, you'll find a 
list of all possible options that you can set that will override Geometry appearance 
and functionality.

## Table of Contents

- [Customization Options](#customization-options)
  - [Table of Contents](#table-of-contents)
  - [`geometry_docker_machine.zsh`](#geometrydockermachinezsh)
      - [Options](#options)
  - [`geometry_exec_time.zsh`](#geometryexectimezsh)
      - [Options:](#options)
  - [`geometry_git.zsh`](#geometrygitzsh)
      - [Options:](#options-1)
        - [`geometry_git_stashes()`](#geometrygitstashes)
        - [`geometry_git_time()`](#geometrygittime)
        - [`geometry_git_branch()`](#geometrygitbranch)
        - [`geometry_git_status()`](#geometrygitstatus)
        - [`geometry_git_rebase()`](#geometrygitrebase)
        - [`geometry_git_remote() `](#geometrygitremote)
        - [`geometry_git_conflicts()`](#geometrygitconflicts)
        - [`geometry_git()`](#geometrygit)
        - [`geometry::git_wrapper`](#geometrygitwrapper)
  - [`geometry_hg.zsh`](#geometryhgzsh)
      - [Options:](#options-2)
  - [`geometry_hostname.zsh`](#geometryhostnamezsh)
      - [Options:](#options-3)
  - [`geometry_jobs.zsh`](#geometryjobszsh)
      - [Options:](#options-4)
  - [`geometry_kube.zsh`](#geometrykubezsh)
      - [Options:](#options-5)
  - [`geometry_node.zsh`](#geometrynodezsh)
      - [Options:](#options-6)
  - [`geometry_npm_package_version.zsh`](#geometrynpmpackageversionzsh)
      - [Options:](#options-7)
  - [`geometry_path.zsh`](#geometrypathzsh)
      - [Options:](#options-8)
  - [`geometry_ruby.zsh`](#geometryrubyzsh)
      - [Options:](#options-9)
  - [`geometry_rust_version.zsh`](#geometryrustversionzsh)
      - [Options:](#options-10)
  - [`geometry_rustup.zsh`](#geometryrustupzsh)
      - [Options:](#options-11)
  - [`geometry_status.zsh`](#geometrystatuszsh)
      - [Options:](#options-12)
  - [`geometry_virtualenv.zsh`](#geometryvirtualenvzsh)
      - [Options:](#options-13)


<br><br>

## `geometry_docker_machine.zsh`

Show the docker machine name. 

#### Options

| Variable | Description | Defaults |
| - | - | - |
| `GEOMETRY_DOCKER_MACHINE_SYMBOL` | Indicator. | `⚓` |
| `GEOMETRY_DOCKER_MACHINE_COLOR` | Text color of the machine name. | `blue` |

<br><br>
## `geometry_exec_time.zsh`

Show the elapsed time for long running commands.

#### Options:

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_EXEC_TIME_FILE` | Path to temp direcotry, where file is stored. |  |
|`GEOMETRY_EXEC_TIME_PATIENCE`| Seconds before the time is shown. | |

<br><br>
## `geometry_git.zsh`

Show git related information, such as branch name, status and time since last commit.

#### Options:

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_GIT_GREP` | Used to override our searching. | `rg` > `ag` > `grep` |

##### `geometry_git_stashes()`

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_GIT_SYMBOL_STASHES`| Indicator. | `●` |
|`GEOMETRY_GIT_COLOR_STASHES`| Color.| `144` |

##### `geometry_git_time()`
| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_COLOR_NO_TIME`| Text color. | `white` |
|`GEOMETRY_GIT_NO_COMMITS_MESSAGE`| Text message shown when there's no commits.| `no-commits` |
|`GEOMETRY_GIT_TIME_DETAILED`| Detailed timestamp instead of simple. | `false` |

##### `geometry_git_branch()`

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_GIT_COLOR_BRANCH`| Color for branch name. | `242` |

##### `geometry_git_status()`

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_GIT_COLOR_DIRTY`| Color for dirty indicator. | `red` |
|`GEOMETRY_GIT_SYMBOL_DIRTY`| Indicator when dirty. | `⬡` |
|`GEOMETRY_GIT_COLOR_CLEAN`| Color for clean indicator. | `green` |
|`GEOMETRY_GIT_SYMBOL_CLEAN`| Indicator when clean. | `⬢` |

##### `geometry_git_rebase()`

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_GIT_SYMBOL_REBASE`| Indicator. | `®` |

##### `geometry_git_remote() `

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_GIT_SYMBOL_UNPUSHED`| Unpushed indicator. | `⇡` |
|`GEOMETRY_GIT_SYMBOL_UNPULLED`| Unpulled indicator. | `⇣` |

##### `geometry_git_conflicts()`

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_GIT_COLOR_CONFLICTS_UNSOLVED`| Unsolved conflicts color. | `red` |
`GEOMETRY_GIT_COLOR_CONFLICTS_SOLVED`| Solved conflicts color. | `green` |
|`GEOMETRY_GIT_SYMBOL_CONFLICTS_SOLVED`| Solved conflicts indicator. | `◆` |
`GEOMETRY_GIT_SYMBOL_CONFLICTS_UNSOLVED`| Unsolved conflicts indicator. | `◈` |

##### `geometry_git()`

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_GIT_COLOR_BARE`| Color. | `blue` |
|`GEOMETRY_GIT_SYMBOL_BARE`| Indicator. | `⬢` |

##### `geometry::git_wrapper`

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_GIT_SEPARATOR`| Separator for the indicators. | `::` |

<br><br>
## `geometry_hg.zsh`

Show Mercurial related information, such as branch name, status and time since last commit.

#### Options:

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_HG_COLOR_BRANCH`| Color for branch name. | `242` |
|`GEOMETRY_HG_COLOR_DIRTY`| Color for dirty indicator. | `red` |
|`GEOMETRY_HG_SYMBOL_DIRTY`| Indicator for dirty repository. | `⬡` |
|`GEOMETRY_HG_COLOR_CLEAN`| Color for clean indicator. | `green` |
|`GEOMETRY_HG_SYMBOL_CLEAN`| Idicator for clean repository. | `⬢` |
|`GEOMETRY_HG_SYMBOL_SEPARATOR`| Separator for the indicators. | `::` |

<br><br>
## `geometry_hostname.zsh`

Shows user and hostname information, by default in the `enter` prompt.

#### Options:

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_HOSTNAME_HIDE_ON`| Don't show the username and hostname indicator when the hostname matches.| `localhost` |
|`GEOMETRY_HOSTNAME_SEPARATOR`| Separator between user and hostname. | `@` |

<br><br>
## `geometry_jobs.zsh`

Shows background jobs, by default in the `enter` prompt.

#### Options:

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_JOBS_SYMBOL`| Indicator. | `⚙` |
|`GEOMETRY_JOBS_COLOR`| Color for the indicator. | `blue` |

<br><br>
## `geometry_kube.zsh`

Show kubectl (Kubernetes) client version and current context/namespace.

#### Options:

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_KUBE_COLOR`| Color for the indicator. | `blue` |
|`GEOMETRY_KUBE_SYMBOL`| Indicator. | `⎈` |
|`GEOMETRY_KUBE_PIN`| Can be set to always show `geometry_kube`. | |

<br><br>
## `geometry_node.zsh`

Show node and npm/yarn version when in a node project context.

#### Options:

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_NODE_SYMBOL`| Indicator. | `⬡` |
|`GEOMETRY_NODE_COLOR`| Color for the indicator. | `green` |
|`GEOMETRY_NODE_PIN`| Can be setup to always show `geometry_node` outside of the context of a node project folder. | |

<br><br>
## `geometry_npm_package_version.zsh`

Display the current folder's npm package version from package.json (by @drager)

#### Options:

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_NPM_PACKAGE_VERSION_SYMBOL`| Indicator. | `📦` |
|`GEOMETRY_NPM_PACKAGE_VERSION_SYMBOL_COLOR`| Color for the indicator. | `red` |
|`GEOMETRY_NPM_PACKAGE_VERSION_COLOR`| Text color. | `red` |

<br><br>
## `geometry_path.zsh`

Show the current path.

#### Options:

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_PATH_SYMBOL_HOME`| Symbol representing the home directory. | `%3~` |
|`GEOMETRY_PATH_SHOW_BASENAME`| - | `false` |
|`GEOMETRY_PATH_COLOR`| Color for path. | `blue` |

<br><br>
## `geometry_ruby.zsh`

Display the current ruby version, rvm version, and gemset.

#### Options:

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_RUBY_SYMBOL`| Indicator. | `◆` |
|`GEOMETRY_RUBY_COLOR`| Indicator color. | `white` |
|`GEOMETRY_RUBY_RVM_SHOW_GEMSET`| Show RVM gemset. | `true` |

<br><br>
## `geometry_rust_version.zsh`

Display the current version of rust (by @drager).

#### Options:

| Variable | Description | Defaults |
| - | - | - |
`GEOMETRY_RUST_VERSION_COLOR`| Color for version. | `red` |

<br><br>
## `geometry_rustup.zsh`

Display a symbol colored with the currently selected rustup toolchain.

#### Options:

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_RUSTUP_SYMBOL`| Indicator. | `⚙` |
|`GEOMETRY_RUSTUP_STABLE_COLOR`| Stable color. | `green` |
|`GEOMETRY_RUSTUP_BETA_COLOR`| Beta color. | `yellow` |
|`GEOMETRY_RUSTUP_NIGHTLY_COLOR`| Nightly color. | `red` |
|`GEOMETRY_RUSTUP_PIN`| Can be setup to keep rustup rendering even out of context. | |

<br><br>
## `geometry_status.zsh`

Show a symbol with error/success and root/non-root information.

#### Options:

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_STATUS_SYMBOL`| Non-root indicator. | `▲` |
|`GEOMETRY_STATUS_SYMBOL_ERROR`| Non-root indicator on error. | `△` |
|`GEOMETRY_STATUS_SYMBOL_ROOT`| Root indicator. | `▼` |
|`GEOMETRY_STATUS_SYMBOL_ROOT_ERROR`| root indicator on error. | `▽` |
|`GEOMETRY_STATUS_COLOR`| Indicator color. | `white` |
|`GEOMETRY_STATUS_COLOR_ERROR`| Indicator color on error. | `red` |
|`GEOMETRY_STATUS_SYMBOL_COLOR_HASH`| Automatically pick a color based on the hostname hash. | `false` |

<br><br>
## `geometry_virtualenv.zsh`

Show the current `virtualenv` or `conda` environment.

#### Options:

| Variable | Description | Defaults |
| - | - | - |
|`GEOMETRY_VIRTUALENV_CONDA_SEPARATOR`| Text sdeparator. | `:` |
|`GEOMETRY_VIRTUALENV_COLOR`| Text color. | `green` |
|`GEOMETRY_VIRUALENV_CONDA_COLOR`| Text color. | `green` |
