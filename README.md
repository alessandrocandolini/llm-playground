# llm-playground

Nothing interesting here for now

Todo
1. github actions, but when i decide what code I really wanna write in this repo

## How to run the examples?

The repo provides a simple `shell.nix` file.
Assuming [https://nixos.org/](nix) is available on the machine, in a shell type
```
nix-shell
```
and then to check that pytorch works correctly run
```
python3 main.py --plot
```
or, in order to check if matplotlib was installed successfully,
```
python3 main.py --plot
```

Commands can also be executed via nix-shell directly. For example,
```bash
 nix-shell --pure --run "python main.py"
```
