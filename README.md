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

#### Paragraph blocks
The simplest type of blocks is a paragraph block. They consists of a sequence of non-empty lines as long as none starts with anchor or list markers, or a tab character.

```
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Donec massa sapien faucibus et.

Amet aliquam id diam maecenas ultricies mi.
Tempus egestas sed sed risus pretium quam vulputate dignissim suspendisse.
Justo eget magna fermentum iaculis eu non diam.
Venenatis a condimentum vitae sapien pellentesque habitant morbi.

Sapien faucibus et molestie ac feugiat sed lectus vestibulum mattis. Ultrices mi tempus imperdiet nulla malesuada. Sit amet facilisis magna etiam tempor orci eu lobortis.
Eget sit amet tellus cras adipiscing enim eu. Luctus accumsan tortor posuere ac.
```

Are converted to:

```html
<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Donec massa sapien faucibus et.</p>
<p>Amet aliquam id diam maecenas ultricies mi. Tempus egestas sed sed risus pretium quam vulputate dignissim suspendisse. Justo eget magna fermentum iaculis eu non diam. Venenatis a condimentum vitae sapien pellentesque habitant morbi.</p>
<p>Sapien faucibus et molestie ac feugiat sed lectus vestibulum mattis. Ultrices mi tempus imperdiet nulla malesuada. Sit amet facilisis magna etiam tempor orci eu lobortis. Eget sit amet tellus cras adipiscing enim eu. Luctus accumsan tortor posuere ac.</p>
```

#### Literal blocks
Any block of text indented with a tab character is converted into preformatted block.

```
	Amet aliquam id diam maecenas ultricies mi.
	Tempus egestas sed sed risus pretium quam vulputate dignissim suspendisse.
	Justo eget magna fermentum iaculis eu non diam.
	Venenatis a condimentum vitae sapien pellentesque habitant morbi.
```

```html
<pre>Amet aliquam id diam maecenas ultricies mi.
Tempus egestas sed sed risus pretium quam vulputate dignissim suspendisse.
Justo eget magna fermentum iaculis eu non diam.
Venenatis a condimentum vitae sapien pellentesque habitant morbi.</pre>
```

If a literal block started with a `$` character followed by a space, three comma separated arguments can be used to specify a programming language, filename, and starting line, like the following:

```
	$ C, hello.c, 3
	int main(void) {
	    printf("Hello World\n");
	    return 0;
	}
```

#### Quote blocks
Quote blocks also start with one or more tab character in case of nested quotes, but must start with one of the following *also tab indented* lines:
- `~ author, citation` to mark a quote from a book or a conversation
- `> email/id, date/time` to mark a quote from an email or a chat message

### Inline markup
Inline markup is parsed everywhere except inside [literal blocks](#literal-blocks)
- `*strong*` or `st**ro**ng`
- `/emphasis/` or `emp//ha//sis`
- `@context` or `@[context name]`
- `#tag` or `#[tag name]`
- `+list` or `+[list name]`
- `` `monospaced` `` or `` mon``ospa``ced ``
- `https://link.com` or `(link)` or `(link)name` or `(link)[link name]`
- `!(image)` or `!(image)[alt text, caption]`
- `^superscript` or `^[superscript text]` or `^(link)name` or `^(link)[superscript link name]`
- `_subscript` or `_[subscript text]` or `_(link)name` or `_(link)[subscript link name]`

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
