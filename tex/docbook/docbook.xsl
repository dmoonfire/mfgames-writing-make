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
  <xsl:variable name="package.titlesec.options"></xsl:variable>

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
    <xsl:text>\usepackage</xsl:text><xsl:value-of select="$package.titlesec.options"/><xsl:text>{titlesec}</xsl:text>
	<xsl:call-template name="additional-usepackage"/>

	<!-- Set up the document sizes -->
    <xsl:apply-templates select="." mode="setup"/>

    <!-- Set up the fonts for the document -->
    <xsl:text>\setmainfont{</xsl:text>
    <xsl:value-of select="$font.main"/>
    <xsl:text>}
\newcommand\volis[1]{{\fontspec{Solomon Sans SemiBold}\fontsize{9pt}{9pt}\selectfont #1}}
\newcommand\sepfont[1]{{\fontspec{Courier New}\fontsize{9pt}{9pt}\selectfont #1}}

\def\center{\trivlist \centering\item\relax}
\def\endcenter{\endtrivlist}

\raggedbottom

\epigraphfontsize{\footnotesize}
\setlength{\epigraphwidth}{3.5in}
\setlength{\epigraphrule}{0pt}
\epigraphposition{center}
\epigraphtextposition{raggedright}
\epigraphsourceposition{raggedleft}</xsl:text>

    <xsl:apply-templates select="." mode="pagestyle"/>

    <xsl:apply-templates select="." mode="maketitle" />
    <xsl:apply-templates select="." mode="makechapter" />

    <xsl:text>\author{</xsl:text>
    <xsl:call-template name="person.name"/>
    <xsl:text>}\title{</xsl:text>
    <xsl:apply-templates select="d:info/d:title"/>
    <xsl:text>}</xsl:text>
    <xsl:call-template name="newline"/>

    <!-- Begin the document. -->
    <xsl:text>\begin{document}</xsl:text>
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

  <xsl:template match="d:info" />

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
    <xsl:text>\epigraph{</xsl:text>
    <xsl:apply-templates />
    <xsl:text>}{\scriptsize \textit{</xsl:text>
    <xsl:value-of select="d:attribution"/>
    <xsl:text>}}</xsl:text>
    <xsl:call-template name="newline"/>
  </xsl:template>

  <!-- Inlines -->
  <xsl:template match="d:quote">
    <xsl:text>&#8220;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#8221;</xsl:text>
  </xsl:template>

  <!-- Address -->
  <xsl:template match="d:street|d:city">
    <xsl:text>\\</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Formatting -->
  <xsl:template name="insert-title">
    <xsl:value-of select="d:info/d:title"/>
  </xsl:template>

  <xsl:template name="newline">
    <xsl:text>
</xsl:text>
  </xsl:template>
</xsl:stylesheet>
