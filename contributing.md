# Contributing

We are happy to accept new contributions. The earlier you share your ideas, the quicker we can collaborate.
Don't worry if you are stuck, or your pull request is incomplete or broken. We are here to help!

## Creating a new function

Details about creating a new function are listed [in the readme][].

You can visit [the functions wiki page][] for inspiration and examples.

See below for a common template that can be followed while creating a new function.

We love it when new functions:

* are prefixed with `geometry_`
* are located in [geometry/functions/](/functions)
* document their customization options [in the readme][]
* share screenshots or screencasts in the pull request

## A sample function template

``` zsh
# Define defaults for relevant environment variables
: ${GEOMETRY_<PLUGIN_NAME>_VAR1:="VALUE1"}
: ${GEOMETRY_<PLUGIN_NAME>_VAR2:="VALUE2"}

# Define the function
geometry_<function_name>() {

  # check if command exists for function to be useful
  (( $+commands[command_i_need_to_work] )) || return

  # Test that it makes sense to render this function
  test -n "$SOME_ENV_THING_FOR_MY_PLUGIN" || return

  # Print something
  command_i_need_to_work --version
}
```

## New function tutorial

If you want to set up your own custom function, it's pretty straightforward to do
so. All you need is to make sure it echos whatever you want printed to the prompt.

Let's assume you want to add a plugin that prints `(☞ﾟ∀ﾟ)☞` when the git branch
is clean and `(ノಠ益ಠ)ノ彡┻━┻` when it's dirty.
Let's call it `my_pretty_git`.

```zsh
# my_pretty_git - show emoticons if in a git directory
```

It's good practice to check if it makes sense to display the plugin in the current context before echoing out anything.

```sh
my_pretty_git() {
  (( $+commands[git] )) || return # return if `git` doesn't exist
  [ -d $PWD/.git ] || return      # return if we are not in a git repository
}
```

Now that we know we are in a useful context, let's setup some environment variables for customization:

```sh
my_pretty_git() {
  (( $+commands[git] )) || return # return if `git` doesn't exist
  [ -d $PWD/.git ] || return      # return if we are not in a git repository

  : ${MY_PRETTY_GIT_CLEAN:="(☞ﾟ∀ﾟ)☞"}
  : ${MY_PRETTY_GIT_DIRTY:="(ノಠ益ಠ)ノ彡┻━┻"}
}
```

Finally we can check the branch status and print accordingly:

```sh
my_pretty_git() {
  (( $+commands[git] )) || return # return if `git` doesn't exist
  [ -d $PWD/.git ] || return      # return if we are not in a git repository

  if [[ -z "$(git status --porcelain --ignore-submodules)" ]]; then
    echo -n $MY_PRETTY_GIT_CLEAN # make sure to use "-n" with your echo!
  else
    echo -n $MY_PRETTY_GIT_DIRTY
  fi
}
```

To help maintain an uncluttered prompt, functions should only render when in a
context where it makes sense. For example, the `geometry_node` function
will only be display when in a npm or yarn-based project.

### Full working example

Save the following example as `my_pretty_git.zsh` anywhere.
Then just source the function and add it to `GEOMETRY_PROMPT` or `GEOMETRY_RPROMPT`.

```zsh
cat <<EOF > my_pretty_git.zsh
# my_pretty_git - show emoticons if in a git directory

my_pretty_git() {
  (( $+commands[git] )) || return
  [ -d $PWD/.git ] || return

  : ${MY_PRETTY_GIT_CLEAN:-"(☞ﾟ∀ﾟ)☞"}
  : ${MY_PRETTY_GIT_DIRTY:-"(ノಠ益ಠ)ノ彡┻━┻"}

  if [[ -z "$(git status --porcelain --ignore-submodules)" ]]; then
    echo $MY_PRETTY_GIT_CLEAN
  else
    echo $MY_PRETTY_GIT_DIRTY
  fi
}
EOF

source my_pretty_git.zsh
GEOMETRY_RPROMPT+=(my_pretty_git)
```

[in the readme]: https://github.com/geometry-zsh/geometry/blob/master/readme.md
[the functions wiki page]: https://github.com/geometry-zsh/geometry/wiki/functions
