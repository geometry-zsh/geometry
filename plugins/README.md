# Plugins

geometry works with its own plugin architecture. It's very easy to enable and
disable plugins. You can also create your own plugins (and even submit them in a
PR).

Available plugins:

* [Docker Machine](/plugins/docker_machine)
* [Exec Time](/plugins/exec_time)
* [Git](/plugins/git)
* [Hg](/plugins/hg)
* [Kube](/plugins/kube)
* [Node](/plugins/node)
* [Ruby](/plugins/ruby)
* [Rustup](/plugins/rustup)
* [Virtualenv](/plugins/virtualenv)
* [Background jobs](/plugins/jobs)

## Default plugins

By default, geometry uses `exec_time`, `jobs`, `git` and `hg`. You can configure
a different setup by changing the `GEOMETRY_PROMPT_PLUGINS` variable in your own
configuration files.


```sh
GEOMETRY_PROMPT_PLUGINS=(virtualenv docker_machine exec_time git hg +rustup)
```

*Note: if you're not sure where to put geometry configs, just add them to your `.zshrc`*

*Note: the `+` before rustup means the plugin is [pinned](#Pinning), and will always render, regardless of context*

## Custom plugins

If you want to set up your own custom plugin, it's pretty straightforward to do
so. All you need is a `setup`, `check`, and a `render` function, with the plugin name on
them.

Let's assume you want to add a plugin that prints `(☞ﾟ∀ﾟ)☞` when the git branch
is clean and `(ノಠ益ಠ)ノ彡┻━┻` when it's dirty. Let's call it `pretty_git`.

By convention we set up configuration variables at the top:

```sh
GEOMETRY_PRETTY_GIT_CLEAN=${GEOMETRY_PRETTY_GIT_CLEAN:-"(☞ﾟ∀ﾟ)☞"}
GEOMETRY_PRETTY_GIT_DIRTY=${GEOMETRY_PRETTY_GIT_DIRTY:-"(ノಠ益ಠ)ノ彡┻━┻"}

```

As a best practice, you should allow settings through environment variables.
Now, the user is able to change the output simply by setting an environment
variable in their `.zshrc` file:

```sh
# Overwrite default GEOMETRY_PRETTY_GIT_CLEAN
GEOMETRY_PRETTY_GIT_CLEAN="(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧"
```

Next up, the `setup` function. It's the first thing that gets called when the
plugin is loaded, so you might want to use for configuration. We won't need it
for now, so let's leave it blank.

```sh
geometry_prompt_pretty_git_setup() {}
```

Note that the `setup`, `check` and `render` functions must obey the naming convention of
`geometry_prompt_<plugin_name>_setup/render`.

Now, checking. The `check` function is called before `render`, and should check if
it makes sense to display the plugin in the current context, returning non-zero if
we should skip rendering.

```sh
geometry_prompt_pretty_git_check() {
  # Do nothing if we're not in a repository
  [ -d $PWD/.git ] || return 1
}
```

Now, rendering. The `render` function is the one that gets called to print to
the `RPROMPT`. Let's simply check the branch status and print accordingly:

```sh
geometry_prompt_pretty_git_render() {
  if test -z "$(git status --porcelain --ignore-submodules)"; then
    echo $GEOMETRY_PRETTY_GIT_CLEAN
  else
    echo $GEOMETRY_PRETTY_GIT_DIRTY
  fi
}
```

As a convention plugins should only be rendered when sitting on a valid context,
for example the `node` built-in plugin will only be displayed when sitting on a
npm/yarn-based project. This is done in order to have an uncluttered prompt, we
encourage you to have this in mind.

Finally you'll need to "register" the plugin with geometry in order to set it up
and render it on each render cycle.

```sh
geometry_plugin_register pretty_git
```

### Full working example

Save the following example as `pretty_git.zsh` somewhere in your `.dotfiles` 
directory and source it _after_ sourcing geometry, ex.:

```sh
# .zshrc
source /path/to/geometry.zsh
source /path/to/pretty_git.zsh

```

```sh
# pretty_git.zsh
GEOMETRY_PRETTY_GIT_CLEAN=${GEOMETRY_PRETTY_GIT_CLEAN:-"(☞ﾟ∀ﾟ)☞"}
GEOMETRY_PRETTY_GIT_DIRTY=${GEOMETRY_PRETTY_GIT_DIRTY:-"(ノಠ益ಠ)ノ彡┻━┻"}

geometry_prompt_pretty_git_setup() {}

geometry_prompt_pretty_git_check() {
  # Do nothing if we're not in a repository
  [ -d $PWD/.git ] || return 1
}


geometry_prompt_pretty_git_render() {
  if test -z "$(git status --porcelain --ignore-submodules)"; then
    echo $GEOMETRY_PRETTY_GIT_CLEAN
  else
    echo $GEOMETRY_PRETTY_GIT_DIRTY
  fi
}

geometry_plugin_register pretty_git

```

## Pinning

A user may decide to pin a plugin by prepending a `+` before the plugin name.
This means geometry will skip the `geometry_prompt_${plugin}_check()` function, and always run the `render` function.
