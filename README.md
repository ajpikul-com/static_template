# Static Template

Static template is a development environment for producing a static website. It integrates `make` with:
* html fragments --> html
* typescript --> javascript
* sass --> prefixing --> css
* linting
* staging and deployment


Fair warning! This build system is NOT tested!

## Dependencies

1) Linux
2) bash
3) make
4) rsync
5) npm (optional)
	- npx (optional, needs npm/node)
	- tsc (optional, needs npm/node)

More:

`build_tools/sources` contains `git-module` stuff

`build_tools/toolchain` contains mainly `npm` stuff that is installed through their package manager.

(both explained below)

## Basic Use

TODO: Include your usual usual setup for /var/ with ACL

Generally, hidden files (`.*`) are ignored by this software.

Since `make` attempts to run almost everything as the `nobody:nogroup` user, you must, from the main directory:

```
sudo chown -R nobody:nogroup compiled/
```

Specify your deployment directories in `conf/make.conf` by setting `STAGE_SYNC_DIR=` and `PRODUCTION_SYNC_DIR=`

### Make Commands 
`make all` will clean (erase) `compiled/public/`, build `raw/`, `sass/`, and `ts/|js/` if they are present, and move them all to `compiled/public`.

`make stage` will clean (erase) `compiled/stage/`, build `raw/`, `sass/`, and `ts/|js/` if they are present, move them all to `compiled/stage`, and `rsync` to your `STAGE_SYNC_DIR`. \
`make restage` will do the above `rsync` step only.

`make deploy` will clean (erase) `compiled/deploy/`, build `raw/`, `sass/`, and `ts/|js/` if they are present, move them all to `compiled/deploy`, and `rsync` to your `PRODUCTION_SYNC_DIR`. \
`make redeploy` will do the above `rsync` step only.

`default-raw, default-css, default-js, stage-css, stage-js, stage-raw, deploy-css, deploy-js, deploy-raw` aren't documented individually, but are intended for your use.

If no `STAGE_SYNC_DIR` or `PRODUCTION_SYNC_DIR` is specified, no `rsync`ing will occur.

TODO: remove origin and add your own website, readme and updating.

### HTML/Contate

The `raw/` directory will be copied into the output folders. `raw/js` and `raw/css` will overwrite whatever `make` generates from typescript or sass.

If `contate` is not installed, `cp` is used. 

While optional, [contate](https://github.com/ajpikul.com/contate) allows you to write scripts directly into your content. Any `raw/*.contate* will be processed as such with ".contate" removed. Contate sources `/conf/common`. 

To install `contate`, you can use

```bash
# To install just contate
git submodule update --init build_tools/sources/contate
# To install everything in .gitmodules
git submodule update --init
```

Or just have it installed and in `PATH`.

### Typescript/Javascript

You can keep javascript in a `raw/js` folder which will overwrite all other javascript. Or use another folder and don't worry about write order. If `webpack` is installed (via `/build_tools/toolchain/webpack`, where there is a proper `config` for typescript) and `tsc` is installed, `webpack` will first look to compile stuff in `ts/` and then in `js/`, but not both.  If `tsc` is installed, it will output w/o `webpack`'s help. `tsc` will use `ts/.tsconfig.json`. 

Everything gets comiled to `compiled/js` before copied to the proper output directory.

### CSS/Sassc

#### Sass

You can keep css in a `raw/css/` folder which will overwrite anything compiled from `sass`, if you're using `sassc`. You can also use a different path and forget about write order.

You can put sass files in the `sass/` folder if you want to use sass. You need to have `sassc` installed:

```bash
git submodule update --init build_tools/sources/sassc
# or
git submodule update --init
# for everything in .gitmodules
```
Then, In `/build_tools/sources/sassc`
```
. scripts/bootstrap
make
```

`Sassc` will build everything to `compiled/css` and then copy css to the proper output directory.

#### Prefixer

You can also use a prefixer which will look at your css in `compiled/css` and amend it so that it works in as many browsers as possible. 
To use the prefixer, you must have it installed.

## Linters

### Spell Checker

`sudo apt-get install aspell` will install a spell checker.


### Other Stuff
Modify the `Makefile` so that `PRODUCTION_DIR` and `STAGE_DIR` point to your actively served web directories.
```
git clone https://github.com/ayjayt/static_template <my_new_website>`
cd my_new_website
rm README.md
git submodule update --init
cd build_tools/toolchain
```
Read the README's in the folders in `build_tools/toolchain` to build your linter (js) and your css-prefixer.

`sudo apt-get install aspell`

That will install a spell checker.
```
cd -
cd build_tools/sources/sassc
. scripts/bootstrap
make
```
You can delete sass-spec and libsass in the sources folder.
```
cd -
git remote remove origin
git remote add origin https://github.com/<user>/<my_new_website>
```

NOTE: `contate` expects to be run as a "nobody" user- the Makefile does this automatically. This is forced as a security precaution. In this way, any script run will only have write access to folders it was explicitly given. This is important because we're executing arbitrary scripts.


```
mkdir public && sudo chown nobody:nogroup public/
mkdir stage && sudo chown nobody:nogroup stage/
mkdir deploy && sudo chown nobody:nogroup deploy/
```

## using

This template relies on a Makefile and the following `make` targets:

###
`all` (default target) - clean public and build raw to it, recompile css

`stage` - clean stage outputdir and build raw to it, recompile css, and sync to stage folder

`deploy` - clean deploy outputdir, and build raw to it, recompile css, and sync to deploy folder 

### linting
`lint` - all kind of web and local based html linting

`lintspell` - make the spell checker interactive and allow you add words to a dictionary

`eslint` - lint the javascript

### internal
`contate` - run contate

`clean` - delete everything in outputdir except css

`clean_css` - delete css in outputdir
