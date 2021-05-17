My i3 config
===

# Introduction

This is my i3 configuration, it has grown in size and complexity over the years.
This repo is just an occasional release when i feel like it. The original is
managed in a private repo.

The configs are generated on the fly by a few scripts you can read for yourself.
Start at `switchconfig.sh`

# Dependencies

I specified most dependencies in ./arch_reqs, but don't expect it to be
exhaustive. The most important ones are:

- perl
- i3
- rofi
- dmenu

# How to use

1. Clone the repo to .config/i3
2. run ./generate.sh to generate the config with the default "profile"
5. alternatively run switchconfig.sh to pick a profile

# Things that probably wont work

 - Backgrounds - i store these outside the repo but reference them in the i3 config
 - some scripts that use credentials from outside the repo

# Relevant files and directories

```
~/.config/i3
├── arch_reqs
├── i3_gen
│   ├── generate.sh     # generates all config files into their proper place
│   ├── switchconfig.sh # script to pick a preset
│   ├── bash_expand.sh  # does the actual magic of processing the configs
│   │
│   ├── dunst.config    # directory with config (edit here)
│   ├── i3.config       # directory with config (edit here)
│   ├── rofi.config     # directory with config (edit here)
│   │
│   ├── presets         # directory with presets
│   └── switcher_defaults # default variables if presets doesn't specify
├── config    # generated config file (i3)
├── dunstrc   # generated config file (dunst)
├── rofi.conf # generated config file (rofi)
├── compton.conf  # regular config
├── i3blocks.conf # regular config
├── i3blocks
├── layouts
└── scripts
```
