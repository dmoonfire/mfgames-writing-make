<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
  <!-- Includes -->
  <xsl:import href="param.xsl"/>
  <xsl:import href="/usr/share/xml/docbook/stylesheet/docbook-xsl-ns/lib/lib.xsl"/>
  <xsl:import href="/usr/share/xml/docbook/stylesheet/docbook-xsl-ns/common/l10n.xsl"/>
  <xsl:import href="/usr/share/xml/docbook/stylesheet/docbook-xsl-ns/common/common.xsl"/>
  <xsl:import href="/usr/share/xml/docbook/stylesheet/docbook-xsl-ns/common/utility.xsl"/>
  <xsl:import href="/usr/share/xml/docbook/stylesheet/docbook-xsl-ns/common/labels.xsl"/>
  <xsl:import href="/usr/share/xml/docbook/stylesheet/docbook-xsl-ns/common/titles.xsl"/>
  <xsl:import href="/usr/share/xml/docbook/stylesheet/docbook-xsl-ns/common/subtitles.xsl"/>
  <xsl:import href="/usr/share/xml/docbook/stylesheet/docbook-xsl-ns/common/gentext.xsl"/>
  <xsl:import href="/usr/share/xml/docbook/stylesheet/docbook-xsl-ns/common/olink.xsl"/>
  <xsl:import href="/usr/share/xml/docbook/stylesheet/docbook-xsl-ns/common/targets.xsl"/>
  <xsl:import href="/usr/share/xml/docbook/stylesheet/docbook-xsl-ns/common/pi.xsl"/>
  <xsl:import href="links.xsl"/>
  <xsl:import href="/usr/share/xml/docbook/stylesheet/docbook-xsl-ns/common/addns.xsl"/>

  <xsl:import href="titles.xsl"/>
  <xsl:import href="style.xsl"/>
  <xsl:import href="book.xsl"/>
  <xsl:import href="article.xsl"/>
  <xsl:import href="legalnotice.xsl"/>
  <xsl:import href="inline.xsl"/>

  <!-- TeX files are text files. -->
  <xsl:output method="text" />

  <!-- Default Variables -->
  <xsl:variable name="font.main">Courier New</xsl:variable>
  <xsl:variable name="font.main.features"></xsl:variable>

  <xsl:variable name="package.titlesec.options"></xsl:variable>

  <xsl:variable name="epigraph.font"><xsl:value-of select="$font.main"/></xsl:variable>
  <xsl:variable name="epigraph.font.size">9pt</xsl:variable>
  <xsl:variable name="epigraph.attribution.font"><xsl:value-of select="$epigraph.font"/></xsl:variable>
  <xsl:variable name="epigraph.attribution.font.size"><xsl:value-of select="$epigraph.font.size"/></xsl:variable>
  <xsl:variable name="epigraph.width">4in</xsl:variable>

  <xsl:variable name="margin.top">1in</xsl:variable>
  <xsl:variable name="margin.bottom">1in</xsl:variable>
  <xsl:variable name="margin.inner">1in</xsl:variable>
  <xsl:variable name="margin.outer">1in</xsl:variable>
  <xsl:variable name="text.indent">0.5in</xsl:variable>

  <!-- Additional packages -->

  <xsl:template name="additional-usepackage"/>

  <!-- Top-Level Book -->
  <xsl:template match="/">
    <!-- insert the header controls to use XeLaTeX for formatting -->
    <xsl:text>%!TEX TS-program = xelatex</xsl:text>
    <xsl:call-template name="newline"/>
    <xsl:text>%!TEX encoding = UTF-8 Unicode</xsl:text>
    <xsl:call-template name="newline"/>

    <xsl:apply-templates select="d:book|d:article"/>
  </xsl:template>

  <xsl:template match="d:book|d:article">
    <xsl:text>\documentclass[</xsl:text>
    <xsl:value-of select="$document.class"/>
    <xsl:text>]{memoir}</xsl:text>

    <!-- Include the standard packages -->
    <xsl:text>\usepackage{xunicode}</xsl:text>
    <xsl:text>\usepackage{xltxtra}</xsl:text>
    <xsl:text>\usepackage{type1cm}</xsl:text>
    <xsl:text>\usepackage{lettrine}</xsl:text>
    <xsl:text>\usepackage{fontspec}</xsl:text>
    <xsl:text>\usepackage{graphicx}</xsl:text>
    <xsl:text>\usepackage{xcolor}</xsl:text>
    <xsl:text>\usepackage{microtype}</xsl:text>
    <xsl:text>\usepackage{calc}</xsl:text>
    <xsl:text>\usepackage</xsl:text><xsl:value-of select="$package.titlesec.options"/><xsl:text>{titlesec}</xsl:text>
	<xsl:call-template name="additional-usepackage"/>

	<!-- Set up the document sizes -->
    <xsl:apply-templates select="." mode="setup-page-size"/>
    <xsl:apply-templates select="." mode="setup"/>

    <!-- Set up the fonts for the document -->
    <xsl:text>\setmainfont[</xsl:text>
    <xsl:value-of select="$font.main.features"/>
	<xsl:text>]{</xsl:text>
    <xsl:value-of select="$font.main"/>
    <xsl:text>}</xsl:text>

	<!-- Set up the font and sizes for epigraphs. -->
	<xsl:text>\newcommand\epigraphfont[1]{{\fontspec{</xsl:text>
	<xsl:value-of select="$epigraph.font"/>
	<xsl:text>}\fontsize{</xsl:text>
	<xsl:value-of select="$epigraph.font.size"/>
	<xsl:text>}{</xsl:text>
	<xsl:value-of select="$epigraph.font.size"/>
	<xsl:text>}\selectfont #1}}</xsl:text>

	<!-- Set up the font and sizes for epigraph attributions. -->
	<xsl:text>\newcommand\epigraphattributionfont[1]{{\fontspec{</xsl:text>
	<xsl:value-of select="$epigraph.attribution.font"/>
	<xsl:text>}\fontsize{</xsl:text>
	<xsl:value-of select="$epigraph.attribution.font.size"/>
	<xsl:text>}{</xsl:text>
	<xsl:value-of select="$epigraph.attribution.font.size"/>
	<xsl:text>}\selectfont #1}}</xsl:text>

	<!-- Allow for any additional fonts in the style. -->
	<xsl:apply-templates select="." mode="fonts"/>

    <xsl:text>
\def\center{\trivlist \centering\item\relax}
\def\endcenter{\endtrivlist}

\raggedbottom

\setlength{\epigraphwidth}{</xsl:text><xsl:value-of select="$epigraph.width"/><xsl:text>}
\setlength{\epigraphrule}{0pt}
\epigraphposition{center}
\epigraphtextposition{raggedright}
\epigraphsourceposition{raggedleft}

%% Set the text indent.
\setlength{\parindent}{</xsl:text><xsl:value-of select="$text.indent"/><xsl:text>}</xsl:text>

    <xsl:apply-templates select="." mode="pagestyle"/>

    <xsl:apply-templates select="." mode="maketitle" />
    <xsl:apply-templates select="." mode="makechapter" />

    <xsl:text>\author{</xsl:text>
    <xsl:call-template name="person.name"/>
    <xsl:text>}\title{</xsl:text>
    <xsl:apply-templates select="d:info/d:title"/>
    <xsl:text>}</xsl:text>
    <xsl:call-template name="newline"/>

	<xsl:text>
%% lr margin is really out inner/outer
\setlrmarginsandblock{</xsl:text><xsl:value-of select="$margin.inner"/><xsl:text>}{</xsl:text><xsl:value-of select="$margin.outer"/><xsl:text>}{*}
\setulmarginsandblock{</xsl:text><xsl:value-of select="$margin.top"/><xsl:text>}{</xsl:text><xsl:value-of select="$margin.bottom"/><xsl:text>}{*}
\checkandfixthelayout
    </xsl:text>

    <!-- Begin the document. -->
    <xsl:text>\begin{document}</xsl:text>
    <xsl:call-template name="newline"/>
    <xsl:text>\sloppy</xsl:text>
    <xsl:call-template name="newline"/>

    <!-- Add in the various elements using multiple passes. -->
    <xsl:apply-templates select="." mode="title"/>
    <xsl:apply-templates select="." mode="frontmatter"/>
    <xsl:apply-templates select="." mode="mainmatter"/>
    <xsl:apply-templates select="." mode="backmatter"/>

    <!-- Finish up the document. -->
    <xsl:text>\end{document}</xsl:text>
    <xsl:call-template name="newline"/>
  </xsl:template>

  <xsl:template match="d:*" mode="setup-page-size" priority="-1">
	<!-- We default to not specifying a page size. -->
  </xsl:template>

  <xsl:template match="d:info" />
  <xsl:template match="d:title" />

  <xsl:template match="d:author">
    <xsl:value-of select="d:firstname"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="d:surname"/>
  </xsl:template>

  <!-- Structural Elements -->
  <xsl:template match="d:chapter|d:preface">
    <xsl:text>\chapter{</xsl:text>
    <xsl:call-template name="insert-title"/>
    <xsl:text>}</xsl:text>

    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="d:colophon">
    <xsl:text>\chapter*{Colophon}</xsl:text>
    <xsl:call-template name="newline"/>

    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="d:dedication">
    <xsl:text>\clearpage\thispagestyle{empty}\begin{center}\vspace*{1in}</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>\end{center}</xsl:text>
  </xsl:template>

  <xsl:template match="d:acknowledgments">
    <xsl:text>\chapter*{Acknowledgements}</xsl:text>
    <xsl:call-template name="newline"/>

    <xsl:apply-templates/>
  </xsl:template>

  <!-- Sections -->
  <xsl:template match="d:bridgehead[@otherrenderas='break']">
    <xsl:text>\vskip\onelineskip {\centering \sepfont{&#x25e6; &#x25e6; &#x25e6;}\\} \vskip\onelineskip </xsl:text>

    <xsl:apply-templates/>
  </xsl:template>

  <!-- Paragraphs -->
  <xsl:template match="d:blockquote">
    <xsl:text>\begin{quote}</xsl:text>
	<xsl:apply-templates select="d:para|d:simpara"/>
    <xsl:text>\end{quote}</xsl:text>
  </xsl:template>

  <xsl:template match="d:para|d:simpara">
    <xsl:if test="@role = 'slab'">
      <xsl:text>\noindent </xsl:text>
    </xsl:if>

    <xsl:if test="@role = 'center'">
      <xsl:text>\begin{center}</xsl:text>
    </xsl:if>

    <xsl:apply-templates />

    <xsl:if test="@role = 'slab'">
      <xsl:text>\mbox{} \\ </xsl:text>
    </xsl:if>

    <xsl:if test="@role = 'center'">
      <xsl:text>\end{center}</xsl:text>
    </xsl:if>

    <xsl:call-template name="newline"/>
    <xsl:call-template name="newline"/>
  </xsl:template>

  <xsl:template match="d:epigraph">
    <xsl:text>\epigraph{\epigraphfont {</xsl:text>
    <xsl:apply-templates select="d:para|d:simpara"/>
    <xsl:text>}}{\epigraphattributionfont {</xsl:text>
    <xsl:value-of select="d:attribution"/>
    <xsl:text>}}</xsl:text>
    <xsl:call-template name="newline"/>
  </xsl:template>

  <!-- Inlines -->
  <xsl:template match="d:quote[@role='single']">
    <xsl:text>&#x2018;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#x2019;</xsl:text>
  </xsl:template>
  <xsl:template match="d:quote" priority="-1">
    <xsl:text>&#8220;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#8221;</xsl:text>
  </xsl:template>

  <!-- Address -->
  <xsl:template match="d:street|d:city|d:otheraddr">
    <xsl:text>\\</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Formatting -->
  <xsl:template name="insert-title">
    <xsl:value-of select="d:title|d:info/d:title"/>
  </xsl:template>

  <xsl:template name="newline">
    <xsl:text>
</xsl:text>
  </xsl:template>
</xsl:stylesheet>
