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
<pre><code><span>Amet aliquam id diam maecenas ultricies mi.</span>
<span>Tempus egestas sed sed risus pretium quam vulputate dignissim suspendisse.</span>
<span>Justo eget magna fermentum iaculis eu non diam.</span>
<span>Venenatis a condimentum vitae sapien pellentesque habitant morbi.</span></code></pre>
```

If a literal block started with a `$` character followed by a space, three comma separated arguments can be used to specify a programming language, filename, and starting line, like the following:

```
	$ C, hello.c, 3
	int main(void) {
	    printf("Hello World\n");
	    return 0;
	}
```

Which converts it to the following:

```html
<figure><figcaption>hello.c</figcaption>
<pre style="counter-reset: line 2"><code lang="c"><span>int main(void) {</span>
<span>    printf("Hello World\n");</span>
<span>    return 0;</span>
<span>}</span></code></pre>
```

#### Quote blocks
Quote blocks also start with one or more tab character in case of nested quotes, but must start with one of the following *also tab indented* lines:
- `~ author, citation` to mark a quote from a book or a conversation
- `> email/id, date/time` to mark a quote from an email or a chat message

An example for the second form could be:

```
	> Bob, 2021-12-28
	Hello Alice
		> Alice, 2021-12-27
		Hello
```

Outputs the following:

```html
<figure><figcaption>Bob wrote on 2021-12-28</figcaption>
    <blockquote>
        Hello Alice
        <figure><figcaption>Alice wrote on 2021-12-27</figcaption>
            <blockquote>
                Hello Bob
            </blockquote>
        </figure>
    </blockquote>
</figure>
```

### Inline markup
Inline markup is parsed everywhere except inside [literal blocks](#literal-blocks)
| Inlines                    | Example             | **amon** syntax        | HTML output               |
| -------------------------- | ------------------- | ---------------------- | ------------------------- |
| Strong emphasis            | **strong**          | `*strong*`             | `<strong>strong</strong>` |
| Surrounded strong emphasis | st**ro**ng          | `st**ro**ng`           | `st<strong>ro</strong>ng` |
| Emphasis                   | *emphasis*          | `/emphasis/`           | `<em>emphasis</em>`       |
| Surrounded emphasis        | emp*ha*sis          | `emp//ha//sis`         | `emp<em>ha</em>sis`       |
| Inline code                | `monospaced`        | ``` `monospaced` ```   | `<code>monospaced</code>` |
| Surrounded inline code     | mon`ospa`ced        | ``` mon``ospa``ced ``` | `mon<code>ospa</code>ced` |
| Superscript                | S<sup>up</sup>      | `S ^up`                | `S<sup>up</sup>`          |
| Multi-word superscript     | S<sup>up text</sup> | `S ^[up text]`         | `S<sup>up text</sup>`     |
| Subscript                  | S<sub>ub</sub>      | `S _ub`                | `S<sub>ub</sub>`          |
| Multi-word subscript       | S<sub>ub text</sub> | `S _[ub text]`         | `S<sub>ub text</sub>`     |

Inline links can have many forms as well depending on the desired formatting:
| Link example                                  | **amon** syntax                        | HTML output                                                |
| --------------------------------------------- | -------------------------------------- | ---------------------------------------------------------- |
| <https://example.com>                         | `https://example.com`                  | `<a href="https://example.com">https://example.com</a>`    |
| [example.com](https://example.com)            | `(https://example.com)`                | `<a href="https://example.com">example.com</a>`            |
| [word](https://example.com)                   | `(https://example.com)word`            | `<a href="https://example.com">word</a>`                   |
| [many words](https://example.com)             | `(https://example.com)[many words]`    | `<a href="https://example.com">many words</a>`             |
| S<sup>[word](https://example.com)</sup>       | `S ^(https://example.com)word`         | `S<sup><a href="https://example.com">word</a></sup>`       |
| S<sup>[many words](https://example.com)</sup> | `S ^(https://example.com)[many words]` | `S<sup><a href="https://example.com">many words</a></sup>` |
| S<sub>[word](https://example.com)</sub>       | `S _(https://example.com)word`         | `S<sub><a href="https://example.com">word</a></sub>`       |
| S<sub>[many words](https://example.com)</sub> | `S _(https://example.com)[many words]` | `S<sub><a href="https://example.com">many words</a></sub>` |

Images are supported as well by using `!` prefix
| **amon** syntax                   | HTML output                                                                              |
| --------------------------------- | ---------------------------------------------------------------------------------------- |
| `!(image.jpg)`                    | `<img src="image.jpg"/>`                                                                 |
| `!(image.jpg)[alt text]`          | `<img src="image.jpg" alt="alt text"/>`                                                  |
| `!(image.jpg)[alt text, caption]` | `<figure><img src="image.jpg" alt="alt text"/><figcaption>caption</figcaption></figure>` |

Some special links are also available that can be used to link to tags, contexts, lists or series pages:
| Link type | Example usage                               | **amon** syntax | HTML output                          |
| --------- | ------------------------------------------- | --------------- | ------------------------------------ |
| Context   | People or places                            | `@4BCX`         | `<a href="/contexts/4bcx">@4BCX</a>` |
| Tag       | Programming language, social media hashtags | `#C`            | `<a href="/tags/c">#C</a>`           |
| List      | Categories or projects                      | `+amon`         | `<a href="/lists/amon">+amon</a>`    |

Special links can also have multiple words as name, a slug is generated from that name. Example: `@[Ahmed Alaa]` outputs `<a href="/contexts/ahmed-alaa">@Ahmed Alaa</a>`

### Lists
Lists are either unordered or numbered and must be followed by a blank line to exit the list block.

```
- List item one
- List item two
- List item three
continue item three
- list item four
```

Generates:

```html
<ul><li><p>List item one</p></li>
<li><p>List item two</p></li>
<li><p>List item three
continue item three</p></li>
<li><p>List item four</p></li>
</ul>
```

```
. List item one
. List item two
. List item three
continue item three
. list item four
```

Generated an auto-numbered list

```html
<ol><li><p>List item one</p></li>
<li><p>List item two</p></li>
<li><p>List item three
continue item three</p></li>
<li><p>List item four</p></li>
</ol>
```

The starting number of the list can be changed by prefixing the first item with a decimal number.

```
5. List item five
. List item six
```

```html
<ol start="5"><li><p>List item five</p></li>
<li><p>List item six</p></li>
</ol>
```

### Variables definition and usage
Variables can be added within the flow of the document inside paragraph blocks like the other inlines, to be used as metadata by the parser, or to be substituted within the same document or environment.

Defining a variable can be done using the format `:variable_name value` or `:variable_name [complex value]`. Variable names are case-sensitive and can only be composed of ASCII letters, digits, and the underscore character. And can only start with a letter or the underscore; much like *C* variables.

Variable substitution can be done with the format `$variable_name` anywhere in the document except in the literal blocks. And to define and use the value at the same time the shorthand expression `$:variable_name value` is used.

The conditional expression `?variable_name [output text]` can be used to output `output text` in case if the value of `variable_name` is defined and does not equal the number  zero `0`. The format `?number [output text]` repeats the output as long as the number does not equal zero `0`, and this can also be used with variables using the format `?$variable_name [output text]` which substitutes `variable_name` with it's value before repeating the output.

## TODO
- [x] Complete writing the description
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
