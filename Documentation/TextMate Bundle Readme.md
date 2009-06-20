Title:		MultiMarkdown Bundle for TextMate
Author:		Fletcher T. Penney
Web:		http://fletcherpenney.net/
Copyright:	2006-2009 Fletcher T. Penney.  
			This work is licensed under a Creative Commons License.  
			http://creativecommons.org/licenses/by-sa/2.5/
Keywords:	MultiMarkdown  
			TextMate  
			Markdown  
			PDF  
			XHTML  
			Markdown  
			LaTeX  
XMP:		CCAttributionShareAlike
Revision:	$Id: TextMate Bundle Readme.md 525 2009-06-15 18:45:44Z fletcher $
Version:	2.0.b6
CSS:		http://fletcherpenney.net/document.css

# Introduction #

[TextMate](http://macromates.com) is a wonderfully useful text editor for Mac
OS X. Of particular interest to me is the ability to extend it with add-on
Bundles for particular uses, either programming languages or document types.
Allan Odgaard created a Bundle for Markdown, and included some basic support
for MultiMarkdown.

To me, however, the job felt halfway done. First - the support for
MultiMarkdown was outdated, so at the very least it needed to be updated with
newer versions of the MultiMarkdown software. More importantly, however, the
Bundle didn't take advantage of all the features that TextMate offered that
could be used to make document creation and publishing easier. And that was
the whole reason for creating MultiMarkdown in the first place.

# What's the difference between this Bundle and the Markdown Bundle? #

The basic Markdown bundle that is included with TextMate is great, and I was
pleased when I learned that they added MultiMarkdown support. The problem was
that even I couldn't get a pdf to compile using it. The MultiMarkdown support
was limited, and didn't take full advantage of the features that TextMate had
to offer.

So I wrote this bundle to add those features back.

I attempted to simply build my bundle on top of the existing Markdown bundle,
as much of the grammar is the same. Unfortunately, this doesn't work, as a few
rules had to be rewritten in order to be compatible with MultiMarkdown. I am
more than happy to work together with the maintainers of the other bundle to
create one "super-bundle" that contains the best features of both, but so far
this hasn't happened. So instead, I periodically try to update my bundle to
match the language improvements made in the Markdown bundle.

If you just use regular Markdown, the other bundle may be sufficient. But if
you use MultiMarkdown, I believe you'll find this version to be indispensable.

# Where can you get a copy #

You can download a copy of the latest version from my web site:

* [MultiMarkdown Bundle for TextMate](http://files.fletcherpenney.net/MultiMarkdownForTextMate.zip)


# Why use this Bundle #

If you are interested in using some of the more advanced features of
MultiMarkdown, specifically the XSLT transforms and the MultiMarkdownMath
features, it can get cumbersome typing complicated command lines to process
your files. There are some predefined shell commands available for
MultiMarkdownMath to do basic processing that can be customized to your needs.

The TextMate Bundle makes this easier for you by having several different
work-flows available with a simple keystroke. You can, of course, create your
own commands or customize the default work-flows. But you are not required to
mess around with shell scripts if you have no desire to.

Obviously, you must have a working "common" installation of MultiMarkdown in
order to use this bundle.

# Getting it to work #

To install this bundle:

1. Install this bundle by double clicking it in the Finder.
2. (optional) - I suggest installing my MultiMarkdown TextMate theme as well 
(included in this package).
3. If your MultiMarkdown installation is not in your user's Library directory, 
you also need to set the Shell Variable `TM_MULTIMARKDOWN_PATH` appropriately.  
For example, you would set it to `/Library/Application Support/MultiMarkdown` 
for a system-wide installation.
4. Create a MultiMarkdown document.
5. Process it into the file type of your choice - XHTML, LaTeX, RTF, etc.

The above should be sufficient to use the bundle to edit documents, and to
convert MultiMarkdown into the above file types. But if you wish to convert
LaTeX into a pdf, you will need to do a few more things (if you haven't
already):

1. You will need the LaTeX Bundle for TextMate (should be installed by
default).
2. You will need a working installation of pdflatex (beyond the scope of this
document, but I suggest using [MacTeX](http://www.tug.org/mactex/).
3. Set your TextMate Preferences->Advanced->Shell Variables. Specifically, set
`TM_LATEX_COMPILER` to `latexmk.pl` and set `TM_LATEX_VIEWER` to `Preview` if
you wish to use the Preview application to view PDF's rather than TextMate
itself (I highly recommend that you set this).
4. If you create a LaTeX document, you can then use the `Typeset & View (PDF)`
command to create and open a pdf, assuming that you have installed the
TextMate LaTeX bundle.


# Features #

## Metadata ##

* Automatically clean up metadata section to align the data

* hitting return aligns you to continue entering metadata within the same key.
  hit return again to enter a new key. hit return again to insert a blank line
  and begin the body

* hitting tab after typing the colon for the key aligns you to the right tab
  width to start entering data

* If using the *Memoir* class, you can set the `chapterstyle` and `pagestyle`
  in the metadata within the document, or as part of your command using
  `addmetadata.pl`. See the companion style example.

* When creating a new document, you can pre-populate it with default metadata
  using the new file template, or by using the `Insert default metadata`
  snippet. Both of these can be customized to your fit your needs. The
  advantage of the snippet approach is that you can tab between all of the
  values to easily make changes.

## Headers ##

* you can use a keystroke to increase or decrease the level of the header
* hitting enter automatically adds trailing #'s to the header and skips some
  space

## Lists ##

* indent and outdent with a keystroke
* convert from numbered to unnumbered list with a keystroke
* clean up the spacing of your list automatically with a single keystroke

## Blockquotes ##

* hitting return automatically starts the next line with the proper level of ">"
* use a keystroke to increase or decrease quote level

## Tables ##

* Clean up ascii spacing of tables automatically
* navigate left and right across cells with a single keystroke


## Text Formatting ##

Key commands to toggle italics and bold

## Completions ##

Automatically complete:

* links by reference
* citations
* footnotes
* automatic cross-refs
* equation labels
* table labels
* autocomplete image filenames located in same folder as your document
* autocomplete BibTeX cite keys from .bib files located in the same folder as 
your document

## Document Conversion ##

Run the following with one menu selection (or keystroke):

* Preview XHTML - run MultiMarkdownMath (optionally), MultiMarkdown, SmartyPants
* View XHTML source
* Convert XHTML into LaTeX using article, memoir, report, science or other XSLT file of your choice
* Convert to S5 for presentations
* Convert to RTF or Word format

**Note**: You can convert either the entire document or just a selection. If
you choose to convert just a section, make sure that the section begins with a
blank line in order to differentiate it from the metadata that will be added
automatically. If this doesn't make sense, just stick with previewing the
entire document until it does. ;)

## Image Preview ##

Thanks to a suggestion from Andrew Nanton, images now work properly when XHTML
is previewed within TextMate.

# Limitations #

## Language Grammar ##

There are a few situations where the language matching grammar is too limited
to properly match MultiMarkdown documents:

* TextMate can't tell the difference between an anchor by reference on a line
  by itself, and the caption and optional label at the start of a table. If
  you are trying to use an anchor, you may need to add some non-whitespace
  characters to the end of the line to force the scope to change. I am open to
  suggestions on how to improve this.

* TextMate doesn't include the character after a scope as part of the scope.
  For example, Markdown anchors can consist of square brackets surrounding a
  label. The only way to allow customized autocompletion to work properly on
  the label is if you include the brackets in the scope of interest. I would
  like the cursor at the end of a scope to be considered part of that scope,
  until one types a character that is no longer part of that scope. (This idea
  makes sense to me as a type it, but I will be quite surprised if many people
  understood the gibberish I just typed :)


## Completions ##

Unfortunately, completions are apparently case sensitive. So if you have a
header `Introduction`, it will not show up as a completion for `i`. I suppose
you can make the best of this and label all references with lower case, and
use upper case for headers, allowing you to restrict your completion search by
using upper or lower case, but this seems like a limitation of TextMate.

# More to Come ... #

This document needs more work. I am welcome to contributions, suggestions,
rewrites, etc.
