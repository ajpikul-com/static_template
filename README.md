# static template

Static template is a set of non-content files to facillitate a new website. Like most of my work, this is only guarenteed to work on linux.

## summary

It relies on [contate](https://github.com/autopogo/contate),

The `Makefile` will build the `*.contate` files in the `/raw` folder, and copy them all over to `/public`.

`make sass` will compile sass files to `public/`. Therefore, css is generally not in `raw/`.

There are also `fragments/` used by raw contate files and `conf/` files which are loaded by the Makefile depending on what you want (for example, different configurations for different targets).

I highly recommend custom Makefile targets to stage and deploy.

## permissions

`contate` expects to be run as a "nobody" user- the makefile does this automatically. This is forced as a security precaution. In this way, any script run will only have write access to folders it was explicitly given. This is important because we're executing arbitrary scripts.

`mkdir public && sudo chown nobody:nogroup public/`

