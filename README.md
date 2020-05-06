# static template

Static template is a set of non-content files to facilitate a new website. Like most of my work, this is only guarenteed to work on linux.

## quick

If you're not setting up the environment, the only three folders you need to worry about are `sass/` (which contains css), `raw/` (which is what turns into the webpage), and `fragments/` (which are the library of resuable HTML that `raw/` can use). The `sass` file is compiled to a `css/` folder directly in the output directory.

If you use typescript (a good option), the `ts/` folder will be compiled to the outputdirectory's `/js` folder in the same way as sass. You're expected to install `tsc` normally.

The `Makefile` will build the `*.contate` files in the `/raw` folder, and copy them all over to the output directory. The output directory is set by a file in `conf/`, and is by default `/public` but has examples for `/stage` and `/deploy`. See the [using](#using) section for Makefile targets.

## contate

It relies on [contate](https://github.com/autopogo/contate).

You should look at contate's instructions. In short, your web pages are parsed as scripts and can pass variables between each other. `*.contate` files in `/raw` will be compiled with contate. Other files will be copied as-is.
Use conf files to pass global environmental files to your contate files, they all source the `/conf/common` file.

I create a `fragments` folder where common elements are stored.

## installation

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
