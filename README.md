# exec_dialog
Dialog box for executing a command list using a POSIX shell

## execution
```
./di-exec.sh
```

## Listed commands
Commands that should appear in the execution interface must be placed in the file:
```
$ ./config/options.json
```
Every command must contain 2 values:
- caption: Text to be showed in the program interface
- command: The command it self, if the command uses quotes use simple ones to avoid conflict with json syntax.

```
{
  "options": [
    {"caption":"cat", "command":"cat /etc/hosts"},
  ]
}
```
