# lovesongs

I wanted to make love2d-based mod-tracker for a pi-zero inisde a [gameboy case](http://retroflag.com/GPi-CASE.html). It has a focus on using a joystick (dpad and 8 buttons) to make songs easily on my hardware.

## development

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

## TODO

### stage 1

This is basic editor phase. It doesn't really work, but demos how the UI will work.

* 4 track
* 16-note patterns


### stage 2

* as many tracks as you like
* as many notes in pattern as you like
* effects
* actually play * edit patterns
* dialog for instruments
* dialog for samples
* dialog for file load/save
