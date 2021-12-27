# amon - Another Markup and Object Notation language

## Preface
I usually write my notes and to-do lists in plain text files, and I have my own basic/inconsistent/minimal markup that is an amalgam of different markup languages and configuration files standards. And since I'm relearning programming, and I like to torture my self trying to build stuff instead of using [well](https://asciidoc.org/) [established](https://daringfireball.net/projects/markdown/) [and](https://orgmode.org/) [beautiful](https://docutils.sourceforge.io/rst.html) [alternatives](https://todotxt.org/); I decided to write my own specification and implementation for a markup language that no one is gonna use, and to throw in a pinch of object notation. And to be clear, this is not intended to replace any of the existing languages or standards. This is just how I organize my text files and I'm writing this to force some consistency in my notes, and hopefully use it in my static site genereator.

## Description
**amon** documents are plain text files with minimal markup intended for use in writing notes, to-do lists and documentation a bit faster and with intuitive tags. The markup is divided into five main types; [anchors](#anchors), [blocks](#blocks), [inline markup](#inline-markup), [lists](#lists), [variables definition and usage](#variables-definition-and-usage)

### Anchors
**amon** anchors can be considered like section markers and have three types:

#### Header anchors:
Much like basic Markdown headers the line must start with one and up to six `#` characters followed by one or more space characters, then any sequence of Unicode characters till the end of the line. So the following text:

```
# Level 1
## Level 2
### Level 3
#### Level 4
##### Level 5
###### Level 6
```

Is converted to:

```html
<h1>Level 1</h1>
<h2>Level 2</h2>
<h3>Level 3</h3>
<h4>Level 4</h4>
<h5>Level 5</h5>
<h6>Level 6</h6>
```

#### Collapsible block marker:
This also takes a line by itself, but starting tag is one or more `+` characters. If multiple collapsible blocks of sequential levels follow each other, the blocks are nested in the html representation.

```
+ Level 1
Level 1 details

++ Level 2
Level 2 details

+++ Level 3
Level 3 details
```

Becomes:

```html
<details>
    <summary>Level 1</summary>
    Level 1 details
    <details>
        <summary>Level 2</summary>
        Level 2 details
        <details>
            <summary>Level 3</summary>
            Level 3 details
            </details>
    </details>
</details>
```

#### Collapsible headers:
This is both [headers](#header-anchors) and [collapsible block markers](#Collapsible-block-marker). Starts with `*` character and can have up to six levels.


```
* Level 1
Level 1 details

** Level 2
Level 2 details

*** Level 3
Level 3 details
```

Becomes:

```html
<details>
    <summary><h1>Level 1</h1></summary>
    Level 1 details
    <details>
        <summary><h2>Level 2</h2></summary>
        Level 2 details
        <details>
            <summary><h3>Level 3</h3></summary>
            Level 3 details
            </details>
    </details>
</details>
```

### Blocks

### Inline markup

### Lists

### Variables definition and usage

## TODO
- [ ] Complete writing the description
- [ ] Write proper specification document
- [ ] Write specification using [ABNF](https://www.rfc-editor.org/rfc/rfc5234.html)
- [ ] Write implementation in portable shell script
- [ ] Write compliance test documents

## Credits
- [Changelog](./CHANGELOG.md) format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
- This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
- And I try my best to follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
- [.gitignore](./.gitignore) was generated using [gitignore.io](https://www.toptal.com/developers/gitignore)
- I'm using [Github Flavored Markdown Specification](https://github.github.com/gfm/) as a reference of writing the specs

## License
This project is licensed under [The Unlicense](./LICENSE)
