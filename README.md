# static template

Static template is a set of non-content files to facilitate a new website. Like most of my work, this is only guarenteed to work on linux.

## summary

It relies on [contate](https://github.com/autopogo/contate),

The `Makefile` will build the `*.contate` files in the `/raw` folder, and copy them all over to the output directory. the output directory is set by a file in conf, and is by default `/public` but has examples for `/stage` and `/deploy`.

The `sass` file is compiled to a `css/` folder in the output directory.

## contate

You should look at contate's instructions. In short, your web pages are parsed as scripts and can pass variables between each other. `*.contate` files in `/raw` will be compiled with contate. Other files will be copied as-is.
Use conf files to pass global environmental files to your contate files, they all source the `/conf/common` file.

I create a `fragments` folder where common elements are stored.

## permissions

`contate` expects to be run as a "nobody" user- the makefile does this automatically. This is forced as a security precaution. In this way, any script run will only have write access to folders it was explicitly given. This is important because we're executing arbitrary scripts.

`mkdir public && sudo chown nobody:nogroup public/`
`mkdir stage && sudo chown nobody:nogroup stage/`
`mkdir deploy && sudo chown nobody:nogroup deploy/`

## "installation"

```
git clone https://github.com/ayjayt/static_template my_new_website`
cd my_new_website
rm README.md
git submodule update --init
git remote remove origin
git remote add origin https://github.com/user/my_new_website
git remote add template https://github.com/ayjayt/static_template
```
