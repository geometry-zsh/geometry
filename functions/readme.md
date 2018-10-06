# Functions

geometry works with functions. Any function that prints to stdout can be put in the left or right prompt. We are always happy to add new functions to the default collection.

Available functions:

* [Status](/functions/geometry_status.zsh)
* [Path](/functions/geometry_path.zsh)
* [Git](/functions/geometry_git.zsh)
* [Docker Machine](/functions/geometry_docker_machine.zsh)
* [Exec Time](/functions/geometry_exec_time.zsh)
* [Hg](/functions/geometry_hg.zsh)
* [Kube](/functions/geometry_kube.zsh)
* [Node](/functions/geometry_node.zsh)
* [Ruby](/functions/geometry_ruby.zsh)
* [Rustup](/functions/geometry_rustup.zsh)
* [Virtualenv](/functions/geometry_virtualenv.zsh)
* [Background jobs](/functions/geometry_jobs.zsh)

## Default functions

By default, geometry uses `status` and `path` on the left prompt, and `exec_time`, `jobs`, `git` and `hg` for the right prompt.

You can configure a different setup by changing the `GEOMETRY_PROMPT` and `GEOMETRY_RPROMPT` variables in your own configuration files.

```sh
GEOMETRY_PROMPT=(status git)
GEOMETRY_RPROMPT=(geometry_virtualenv docker_machine exec_time hg rustup)
```

*Note: if you're not sure where to put geometry configs, just add them to your `.zshrc`*

## Custom functions

If you want to set up your own custom function, it's pretty straightforward to do
so. All you need is to make sure it echos whatever you want printed to the prompt.

Let's assume you want to add a plugin that prints `(☞ﾟ∀ﾟ)☞` when the git branch
is clean and `(ノಠ益ಠ)ノ彡┻━┻` when it's dirty. Let's call it `pretty_git`.

By convention we set up configuration variables at the top:

```sh
: ${MY_PRETTY_GIT_CLEAN:="(☞ﾟ∀ﾟ)☞"}
: ${MY_PRETTY_GIT_DIRTY:="(ノಠ益ಠ)ノ彡┻━┻"}
```

As a best practice, you should allow settings through environment variables.
Now, the user is able to change the output simply by setting an environment
variable in their `.zshrc` file:

```sh
# Overwrite default GEOMETRY_PRETTY_GIT_CLEAN
MY_PRETTY_GIT_CLEAN="(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧"
```

It's good practice to check if it makes sense to display the plugin in the current context before echoing out anything.

```sh
function my_pretty_git {
  [ -d $PWD/.git ] || return # Do nothing if we're not in a repository
}
```

Now, rendering. Let's simply check the branch status and print accordingly:

```sh
function my_pretty_git {
  [ -d $PWD/.git ] || return # Do nothing if we're not in a repository

  if test -z "$(git status --porcelain --ignore-submodules)"; then
    echo -n $MY_PRETTY_GIT_CLEAN # make sure to use "-n" with your echo!
  else
    echo -n $MY_PRETTY_GIT_DIRTY
  fi
}
```

As a convention plugins should only be rendered when sitting on a valid context,
for example the `node` built-in plugin will only be displayed when sitting on a
npm/yarn-based project. This is done in order to have an uncluttered prompt, we
encourage you to have this in mind.

### Full working example

Save the following example as `pretty_git.zsh` somewhere in your `.dotfiles`
directory and source it _before_ sourcing geometry. Make sure to add it to `GEOMETRY_PROMPT` or `GEOMETRY_RPROMPT`, ex.:

```sh
# .zshrc
source /path/to/pretty_git.zsh
GEOMETRY_RPROMPT=(my_pretty_git)
source /path/to/geometry.zsh
```

```sh
# pretty_git.zsh
: ${MY_PRETTY_GIT_CLEAN:-"(☞ﾟ∀ﾟ)☞"}
: ${MY_PRETTY_GIT_DIRTY:-"(ノಠ益ಠ)ノ彡┻━┻"}

function my_pretty_git {
  [ -d $PWD/.git ] || return
  if test -z "$(git status --porcelain --ignore-submodules)"; then
    echo $MY_PRETTY_GIT_CLEAN
  else
    echo $MY_PRETTY_GIT_DIRTY
  fi
}
```