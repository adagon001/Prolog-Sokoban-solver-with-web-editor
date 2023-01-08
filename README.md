# Prolog-Sokoban-solver-with-web-editor

FMFI Logic Programing project
avalible in git repo
https://github.com/adagon001/Prolog-Sokobonan-solver-with-web-editor

## Platform support

SWI-Prolog command `swipl` must be available in `PATH`.

### Windows

tested with this solution:
https://www.youtube.com/watch?v=oJVXMv2TIoU&ab_channel=AkashDevdhar

### MacOS

SWI-Prolog command `swipl` must be available in `PATH`.

### cmd should recognize command `swipl`

```
C:\Users\adago>swipl
Welcome to SWI-Prolog (threaded, 64 bits, version 8.5.20-8-g1a8e7284f)
SWI-Prolog comes with ABSOLUTELY NO WARRANTY. This is free software.
Please run ?- license. for legal details.

For online help and background, visit https://www.swi-prolog.org
For built-in help, use ?- help(Topic). or ?- apropos(Word).

1 ?-
```

## Installation and run

To install node_modules run:

```sh
$ npm install
```

To start project run:

```sh
$ npm start
```

UI with editor should be avalible on url :
http://localhost:9000/

## Theory location

generated prolog theory should be in `temp-theory.pl`

## Alternative theories

I also tried DFS search located in `dfs.pl` but it proved to be less efective, due to high number of array operations and higher memory usage.
Final theory is in `theory-improved.pl` you can uncooment line 6 `%:- table subset/2.`.
