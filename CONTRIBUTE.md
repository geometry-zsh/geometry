# Contributing

When contributing to this repository, please first discuss the change you wish to make/new feature you want to add via issue, or any other method with the owners of this repository.


## Pull Request Process

1. It is advised to create a PR if you are stuck (so others can help you) or when your feature is complete and tested.
2. Update the changelog.md with details of changes made.
3. Increase the version numbers in any examples files and the readme.md to the new version that this Pull Request would represent.
4. Your PR will be merged (if accepted) once it is reviewed by other developers.


## New function template

Details about creating a new function are listed [in the readme](https://github.com/geometry-zsh/geometry/blob/master/plugins/readme.md).
There is also [a wiki page with third party functions](https://github.com/geometry-zsh/geometry/wiki/functions).
See below for a common template that can be followed while creating a new function.

* all customization options must be documented in the readme
* any pull request should contain a screenshot
* the function should be prefixed with `geometry_`
 * the function should be in [geometry/functions/](geometry/functions)


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
  echo `command_i_need_to_work --version`
}

```

You can follow the above template to get started with your own plugin. Please feel free to open an issue in case you have questions.
