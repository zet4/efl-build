# EFL-Build [![Build Status](https://travis-ci.com/zet4/efl-build.svg?branch=master)](https://travis-ci.com/zet4/efl-build)

Forked from [lorddrew/efl-cross-build](https://git.enlightenment.org/devs/lorddrew/efl-cross-build.git/)

## What the hell is this

This project is essentially a collection of configs for TravisCI that are used to cross-compile upstream EFL for Windows.
It was mainly done due to Win-Builds release being heavily out-of-date. (Last update being in late 2015.)

## How the hell do I use this

For now? You don't, this will upload it's output to [github releases](https://github.com/zet4/efl-build/releases/latest) which is then consumed by upstream projects like fyne-io/bootstrap. Also it's worth keeping in mind that this project is still using Win-Builds style layout and will probably only work properly in environments like msys2.