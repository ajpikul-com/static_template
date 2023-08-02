Note:

Also not good for using all the tools to generate multiple typescript projects in the same repo

I know webpack + tsc + prefixer works. Needs a main.ts. Debugging works. I know SASS works. This whole thing is a mess tho.

# Static Template

Static template is a development environment for producing a static website. It integrates `make` with:
* raw --> html
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

You have directories that are serving the static website. Configure them:

```bash
cd conf/
cp make.conf.default make.conf
nano make.conf # and follow the instructions
# or your editor of choice
```

My deployment and staging directories have special permisions. They're owned by a group, say `web`, and that group can read them and write them. `setfacl` as shown below creates a default permission for everything in the folder.

```
sudo apt install acl
chmod g+ws DIRECTORY
setfacl -d -m g::rwx DIRECTORY
setfacl -d -m o::rx DIRECTORY
```



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

At this point, you should remove this readme and turn this directory into your own repository.

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

### CSS/sassc

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
# You can delete sass-spec and libsass in the sources folder.
```

`Sassc` will build everything to `compiled/css` and then copy css to the proper output directory.

#### Prefixer

You can also use a prefixer which will look at your css in `compiled/css` and amend it so that it works in as many browsers as possible. 
To use the prefixer, you must have it installed in `build_tools/toolchain/prefixer`. There is a README.md there.

## Linters

### Basic HTML

Linters are only used on `public/`. Use `make lint`. This uses an online checker.

#### Spell Checker

`sudo apt-get install aspell` will install a spell checker. We add our own custom dictionary to `toolchain/` (TODO: not sure how dictionary is passed as config). `make lintspell` will make it interactive so you can add words to the dictionary as they are found through the linting.

### eslint

eslint, `make eslint`- the toolchain must be installed (`build_tools/toolchain/eslint`)
