# kube_ps1

kube_ps1 plugin based on project [kube-ps1](https://github.com/jonmosco/kube-ps1) that displays the current kubernetes and namespace on your Zsh right prompt.

## Installation

This plugin assumes you have the following installed:
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
- [kube-ps1](https://github.com/jonmosco/kube-ps1)

## Configuration

In your ~/.zshrc, enable kube-ps1 plugin:

```bash
plugins=(
    kube-ps1
)
```

In your ~/.zshrc, enable geometry pompt kube_ps1 plugin:

```bash
GEOMETRY_PROMPT_PLUGINS=(
    kube_ps1
)
```

## Customization

To change behavior of the plugin see kube-ps1 documentation for overwritting variables:
[kube-ps1 customization](https://github.com/jonmosco/kube-ps1#customization)

