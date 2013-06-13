# Rigid

One of my projects these days is making a simple static web page generator in Bash.
It's a hell of a good way to learn Bash scripting.

I like minimalism and KISS principles. It's something fascinating about using
the rawest materials possible. Easier to maintain, more durable, more ... rigid.

## My demands

* No database or configuration file
* Using only Bash and basic tools (awk, sed, etc.)
* Simple templates
* Markdown support

## Installation

    git clone git://github.com/atmoz/rigid.git
    cd rigid
    sudo make

No installation is really needed. You can just download and run the script. But if
you would like the script available in path (so you can run it wherever you
are), the included Makefile (`sudo make`) will copy the script to /usr/local/bin for you.

Make sure you have at least Bash version 4 and the GNU implementation of AWK (gawk).

## Usage

    rigid [sourceDir] [targetDir]

Create a folder with markdown files (.md) and run `rigid`. HTML files will be
generated in "$PWD.rigid" by default. You can add a file called 
"rigid.template.html" if you want to use a template.

If you have this folder structure:

    web/
        index.md
        rigid.template.html
        projects/
            one.md
            two.md

This new folder will be created when you run rigid:

    web.rigid/
        index.html
        projects/
            one.html
            two.html

It's that simple.

Source code for this blog is a good example and can give you some hints on how
to use multiple templates:
[https://github.com/atmoz/blog](https://github.com/atmoz/blog)

## Template

You have a small selection of placeholders to choose from: `%TITLE%`, `%CONTENT%`,
`%DATE%` and `%INDEX%`.

### %TITLE%

Title is determined by your first level 1 header.

### %CONTENT%

The content of your markdown file, converted to HTML by md2html.awk.

### %DATE%

Date when file was created, in the format YYYY-MM-DD (changing format will be available later).
This is tricky, as you can not get this date from the filesystem. Only date of last 
modification is accessible. That's why I added git support. Rigid uses the date when
you added the file to the repository. If that fails, last modification date is 
used as a fallback.

### %INDEX%

Builds a list of all HTML files in the format `<li><a href="path">title</a></li>`.

I added some optional options so you can sort and filter:

    %INDEX(/ ^post/ date -r)%
           |   |     |   |
           |   |     |   `– argument given to sort (man sort)
           |   |     `– – – sort by: "date" or "name"
           |   `– – – – – – regex filter (grep)
           `– – – – – – – – path prefix ("null" for no prefix)

Using placeholder without parameters (`%INDEX%`) is the same as using
`%INDEX(null .* name)%`.

### Multiple templates

You can use multiple templates! You can have one main template in root, and add
more flesh on the bone as you go deeper down the folder structure.

Example: I wanted to use the disqus comment system only on my blog posts, so I added the
JS code in a template file under my *post* folder. That's why my index file
don't have comments.

## Git hooks for easy publishing

Use Git magic to publish your new content!

    vim page.md
    git add page.md
    git commit && git push

**.git/hooks/post-receive** on remote:

    git checkout -f
    rigid /path/to/worktree /path/to/public_html

