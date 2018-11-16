# Contributing

We are happy to accept new contributions. The earlier you share your ideas, the quicker we can collaborate.
Don't worry if you are stuck, or your pull request is incomplete or broken. We are here to help!

## Creating a new function

Details about creating a new function are listed [in the readme][].

You can visit [the functions wiki page][] for inspiration and examples.

See below for a common template that can be followed while creating a new function.

We love it when new functions:

* are prefixed with `geometry_`
* are located in [geometry/functions/](geometry/functions)
* document their customization options [in the readme][]
* share screenshots or screencasts in the pull request

## A sample function template

``` zsh
# Step 1: Define defaults for all environment variables
: ${GEOMETRY_<PLUGIN_NAME>_VAR1:="VALUE1"}
: ${GEOMETRY_<PLUGIN_NAME>_VAR2:="VALUE2"}

# Step 2: Do any load-time setup
(( $+commands[command_i_need_to_work] )) || return

# Step 3: Define the function
geometry_<plugin_name>() {
  # Test that it makes sense to render this function
  test -n "$SOME_ENV_THING_FOR_MY_PLUGIN" || return
  # Rendering code here
  command_i_need_to_work --version
}

```

## New function tutorial

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
my_pretty_git() {
  [ -d $PWD/.git ] || return # Do nothing if we're not in a repository
}
```

Now that we know we are in a useful context, let's setup some environment variables for customization:

```sh
my_pretty_git() {
  [ -d $PWD/.git ] || return # Do nothing if we're not in a repository

  : ${MY_PRETTY_GIT_CLEAN:="(☞ﾟ∀ﾟ)☞"}
  : ${MY_PRETTY_GIT_DIRTY:="(ノಠ益ಠ)ノ彡┻━┻"}
}
```

Finally we can check the branch status and print accordingly:

```sh
my_pretty_git() {
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
GEOMETRY_RPROMPT+=(my_pretty_git)
source /path/to/geometry.zsh
```

```sh
# my_pretty_git - show emoticons if in a git directory

(( $+commands[git] )) || return # only load if `git` is in our PATH

my_pretty_git() {
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

[in the readme]: https://github.com/geometry-zsh/geometry/blob/master/plugins/readme.md
[the functions wiki page]: https://github.com/geometry-zsh/geometry/wiki/functions
