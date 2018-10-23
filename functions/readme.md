# Functions

With geometry, any function that prints to stdout can be put in the left or right prompt. We are always happy to add new functions to the collection. We currently ship:

* [Status](/functions/geometry_status.zsh)
* [Path](/functions/geometry_path.zsh)
* [Exec Time](/functions/geometry_exec_time.zsh)
* [Jobs](/functions/geometry_jobs.zsh)
* [Git](/functions/geometry_git.zsh)
* [Hg](/functions/geometry_hg.zsh)
* [Node](/functions/geometry_node.zsh)
* [Ruby](/functions/geometry_ruby.zsh)
* [Rustup](/functions/geometry_rustup.zsh)
* [Virtualenv](/functions/geometry_virtualenv.zsh)
* [Docker Machine](/functions/geometry_docker_machine.zsh)
* [Kube](/functions/geometry_kube.zsh)

## Defaults

By default, geometry uses `status` and `path` on the left prompt, and `exec_time`, `jobs`, `git` and `hg` for the right prompt.

You can configure a different setup by changing the `GEOMETRY_PROMPT` and `GEOMETRY_RPROMPT` variables in your own configuration files.

```sh
GEOMETRY_PROMPT=(geometry_status geometry_git)
GEOMETRY_RPROMPT=(geometry_virtualenv geometry_docker_machine geometry_exec_time geometry_hg geometry_rustup)
```

*Note: if you're not sure where to put geometry configs, just add them to your `.zshrc`*

## Custom functions

If you want to set up your own custom function, it's pretty straightforward to do
so. All you need is to make sure it echos whatever you want printed to the prompt.

Let's assume you want to add a plugin that prints `(☞ﾟ∀ﾟ)☞` when the git branch
is clean and `(ノಠ益ಠ)ノ彡┻━┻` when it's dirty. Let's call it `pre`my_pretty_git`.

```zsh
# my_pretty_git - show emoticons if in a git directory
```

After writing our description, we should check that it even makes sense to load the plugin at all:

```zsh
(( $+commands[git] )) || return # only load if `git` is in our PATH
```

It's good practice to check if it makes sense to display the plugin in the current context before echoing out anything.

```sh
function my_pretty_git {
  [ -d $PWD/.git ] || return # Do nothing if we're not in a repository
}
```

Now that we know we are in a useful context, let's setup some environment variables for customization:

```sh
function my_pretty_git {
  [ -d $PWD/.git ] || return # Do nothing if we're not in a repository

  : ${MY_PRETTY_GIT_CLEAN:="(☞ﾟ∀ﾟ)☞"}
  : ${MY_PRETTY_GIT_DIRTY:="(ノಠ益ಠ)ノ彡┻━┻"}
}
```

Finally we can check the branch status and print accordingly:

```sh
function my_pretty_git {
  [ -d $PWD/.git ] || return # Do nothing if we're not in a repository

  if [[ -z "$(git status --porcelain --ignore-submodules)" ]]; then
    echo $MY_PRETTY_GIT_CLEAN # make sure to use "-n" with your echo!
  else
    echo $MY_PRETTY_GIT_DIRTY
  fi
}
```

As a convention plugins should only be rendered when sitting on a valid context,
for example the `node` built-in plugin will only be displayed when sitting on a
npm/yarn-based project. This is done in order to have an uncluttered prompt, we
encourage you to have this in mind.

### Full working example

Save the following example as `my_pretty_git.zsh` somewhere in your `.dotfiles`
directory and source it _before_ sourcing geometry. Make sure to add it to `GEOMETRY_PROMPT` or `GEOMETRY_RPROMPT`, ex.:

```sh
# .zshrc
source /path/to/pretty_git.zsh
GEOMETRY_RPROMPT=(my_pretty_git)
source /path/to/geometry.zsh
```

```sh
# my_pretty_git - show emoticons if in a git directory

(( $+commands[git] )) || return # only load if `git` is in our PATH

function my_pretty_git {
  [[ -d $PWD/.git ]] || return

  : ${MY_PRETTY_GIT_CLEAN:-"(☞ﾟ∀ﾟ)☞"}
  : ${MY_PRETTY_GIT_DIRTY:-"(ノಠ益ಠ)ノ彡┻━┻"}

  if [[ -z "$(git status --porcelain --ignore-submodules)" ]]; then
    echo $MY_PRETTY_GIT_CLEAN
  else
    echo $MY_PRETTY_GIT_DIRTY
  fi
}
```
