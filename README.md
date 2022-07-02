# Setting up Nix with Fish shell for LFE Repo

Nix is a package manager for declaring shell packages that should be used for each project. 
Nix will install the right packages to run a project automatically.

In this example I go through how to set it up for [Elixir](https://elixir-lang.org).
I use the [Fish](https://fishshell.com) shell.

I carried out the following steps on a fresh install of macOS 12.4 Monterey on a Macbook Pro M1.


## Install Nix

`$ sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume --daemon`

Please read through and understand these chapters on Nix first:

https://nix.dev/tutorials/install-nix

https://nix.dev/tutorials/ad-hoc-developer-environments

https://nix.dev/tutorials/towards-reproducibility-pinning-nixpkgs

https://nix.dev/tutorials/declarative-and-reproducible-developer-environments


## Setup LFE project repo

Inspired by [this blog post](https://www.mathiaspolligkeit.com/dev/elixir-dev-environment-with-nix/)
I used niv packager manager to initialize a nix file like this:

`$ nix-shell -p niv --run 'niv init'`

This created `nix/sources.nix` and `nix/sources.json`

Then in the project root i created the `shell.nix` file:

```
\\ shell.nix

{ sources ? import ./nix/sources.nix
, pkgs ? import <nixpkgs> { }
}:

pkgs.mkShell {
  buildInputs = [
    pkgs.lfe
    pkgs.niv
  ];
}
```


Now we know how to use Nix to run a shell with the defined packages. 
But we want it to automatically switch between shells with the dependencies defined in the repo. We can do this with `direnv`. 

## Install `direnv`
Since this needs to be installed globally we will use Homebrew to install it. We could also use Nix HomeManager, but this isn't worth the effort for now.

### Install homebrew (or skip if already installed):

`$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

Add homebrew to fish path:

`echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.config/fish/config.fish
    eval "$(/opt/homebrew/bin/brew shellenv)"`

### Install `direnv`

`$ brew install direnv`

Hook it into our fish shell:

`$ direnv hook fish | source`

At the top-level of our project we run:

`$ echo "use nix" > .envrc && direnv allow`

Now whenever we cd to a repo with a Nix file it will automatically load the packages.

```
$ cd elixir-getting-started/
direnv: loading ~/Documents/Developer/elixir-getting-started/.envrc
direnv: using nix
direnv: export +AR +AS +CC +CONFIG_SHELL 
...
$ lfe
Erlang/OTP 21 [erts-10.3.5.19] [source] [64-bit] [smp:10:10] [ds:10:10:10] [async-threads:1]

   ..-~.~_~---..
  (      \\     )    |   A Lisp-2+ on the Erlang VM
  |`-.._/_\\_.-':    |   Type (help) for usage info.
  |         g |_ \   |
  |        n    | |  |   Docs: http://docs.lfe.io/
  |       a    / /   |   Source: http://github.com/rvirding/lfe
   \     l    |_/    |
    \   r     /      |   LFE v1.3 (abort with ^G)
     `-E___.-'

lfe> (+ 2 2)
4
```

Now we can run LFE in our repo, without worrying about contaminating other projects with dependencies.
