# geometry v2 migration guide

Geometry v2 has been released - with less lines of code, less bugs, and easier customization.

To upgrade, first switch to the `mnml` branch by deleting and re-cloning the repository,
or  manually via `git pull && git checkout -b mnml origin/mnml`.

Next, check the options documentation in `options.md` for renamed and new environment variables.
The main difference is that `GEOMETRY_PROMPT` and `GEOMETRY_RPROMPT` are just arrays of function names.

Finally, if you have a custom plugin, they have been simplified to just be functions.
Instead of a setup, check, and render function, just make any function that prints to stdout.

Thanks for using geometry, and as always, we love feedback on https://github.com/geometry-zsh/issues
