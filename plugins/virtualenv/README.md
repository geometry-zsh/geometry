# Virtualenv

You can display the current `virtualenv` or `conda` environment by enabling this plugin. Individual colors can be assigned to each of the two environments. If both are active at the same time they will be separated by `GEOMETRY_VIRTUALENV_CONDA_SEPARATOR`.


## Settings
Set these variables to change the appearance (with default values):
```bash
GEOMETRY_COLOR_VIRTUALENV=green           # Color for virtualenv environment name
GEOMETRY_COLOR_CONDA=green                # Color for conda environment name
GEOMETRY_VIRTUALENV_CONDA_SEPARATOR=:     # String that separates virtualenv and conda environment names if both are active
```

Change the displayed color by setting the `GEOMETRY_COLOR_PROMPT` environment
variable. Defaults to `green`.
