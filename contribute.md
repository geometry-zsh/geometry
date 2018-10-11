# Contributing

When contributing to this repository, please first discuss the change you wish to make/new feature you want to add via issue, or any other method with the owners of this repository. 


## Pull Request Process

1. It is advised to create a PR if you are stuck (so others can help you) or when your feature is complete and tested. 
2. Update the CHANGELOG.md with details of changes made.
3. Increase the version numbers in any examples files and the README.md to the new version that this
   Pull Request would represent.
4. Your PR will be merged (if accepted) once it is reviewed by other developers.


## New plugin template

Details about creating a new plugin are listed [here](https://github.com/geometry-zsh/geometry/blob/master/plugins/README.md) and a wiki using third party plugins are [here](https://github.com/geometry-zsh/geometry/wiki/plugins) . See below for a common template that can be followed while creating a new plugin.

* To create a new plugin, you will need a setup, check, and a render function, with the plugin name on them
* Your new plugin needs to be a plugin.zsh file placed inside a directory with the name of the plugin
* Users are advised to also place a README.md file inside the plugin directory with details about its behaviour, use and customization options  
* Add your plugin directory to `geometry/plugins/` folder


``` zsh
# Step1: Define your variables above all 
GEOMETRY_<PLUGIN_NAME>_VAR1=${GEOMETRY_<PLUGIN_NAME>_VAR1:-"VALUE1"}
GEOMETRY_<PLUGIN_NAME>_VAR2=${GEOMETRY_<PLUGIN_NAME>_VAR2:-"VALUE2"}

# Step2: This is the method that will be called first when the plugin is loaded.
geometry_prompt_<plugin_name>_setup() {
# Your code here
}

# Step3: The check function is called after setup and before render
geometry_prompt_<plugin_name>_check() {
  # Your code here
}

# Step4: Define Render function - This is where your main logic would go
geometry_prompt_<plugin_name>_render() {
  # Your code here
}

# Step5: Register your plugin
geometry_plugin_register <plugin_name>

```

You can follow the above template to get started with your own plugin. Please feel free to open an issue in case you have questions. 
