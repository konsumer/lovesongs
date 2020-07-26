# lovesongs

I wanted to make love2d-based mod-tracker for a pi-zero inisde a [gameboy case](http://retroflag.com/GPi-CASE.html). It has a focus on using a joystick (dpad and 8 buttons) to make songs easily on my hardware.

## usage

Run `make` then one of these targets:

```
help                           show this help
run                            run the current project
clean                          delete all output files
build                          build distributables for everyone in dist/
```

You will need `love` in your path.

On OSX, put this in your `~/.bashrc`:

```
alias love="open -a love"
```