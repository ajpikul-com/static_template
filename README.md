# static template

Static template is a set of non-content files to facillitate a new website

It relies on [contate](https://github.com/autopogo/contate),

The `Makefile` will build the `*.contate` files in the `/raw` folder, and copy them all over to `/public`.

`make sass` will compile sass files to public. Therefore, `css` is not in `raw/`.

There are also `html_fragments`, which is used by raw contate files, conf files which are loaded by the Makefile depending on what you want (for example, different conf for different targets_.

Highly recommend custom targets to stage and deploy.
