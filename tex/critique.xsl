<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:mw='urn:mfgames:writing:docbook,0'
    version="2.0">
  <!-- Import the rest of the styesheets -->
  <xsl:import href="docbook/docbook.xsl"/>
  <xsl:import href="locale.xsl"/>

  <!-- Setup -->
  <xsl:variable name="document.class">
    letter, 12pt, oneside, final, onecolumn
  </xsl:variable>

  <xsl:variable name="package.titlesec.options"></xsl:variable>

  <!-- Fonts -->
  <xsl:variable name="font.main">Courier New</xsl:variable>

  <!-- Setup -->
  <xsl:template match="d:article|d:book" mode="setup">
	<xsl:text>\setlength{\parindent}{0cm}</xsl:text>
	<xsl:text>\reversemarginpar</xsl:text>
  </xsl:template>

  <!-- Titles -->
  <xsl:template match="d:book" mode="create-title">
  </xsl:template>

  <xsl:template match="d:article" mode="maketitle">
    <xsl:text>
\makeatletter
\def\maketitle{%
  \thispagestyle{empty}%
  \begin{center}\leavevmode
    \@title\par
	\@author\par
    \vskip 1cm
  \end{center}%
  }
\makeatother
    </xsl:text>
    <xsl:call-template name="newline"/>
  </xsl:template>

  <xsl:template match="d:book" mode="maketitle">
    <xsl:text>
\makeatletter
\def\maketitle{%
  \thispagestyle{empty}%
  \begin{center}\leavevmode
    {\HUGE\@title\par}
    \@author
  \end{center}%
  }
\makeatother
    </xsl:text>
    <xsl:call-template name="newline"/>
  </xsl:template>

  <xsl:template match="d:book" mode="makechapter">
    <xsl:text>
% Defines the chapter style.
\titleformat{\chapter}[display]
  {\normalfont\filcenter}
  {\hrulefill\ {\small\chaptertitlename\ \thechapter}}
  {0pt}
  {\huge}
  [\vspace{5pt}\titlerule]
\titlespacing*{\chapter}{0pt}{-13.5pt}{1.18cm}
    </xsl:text>
  </xsl:template>

  <!--
      Styles
  -->
  <xsl:template match="d:book|d:article" mode="pagestyle">
    <xsl:text>\makepagestyle{custompage}</xsl:text>

    <!-- Odd Side -->
    <xsl:text>\makeoddhead{custompage}{{</xsl:text>
    <xsl:text>}}{{</xsl:text>
    <xsl:text>}}{{</xsl:text>

    <xsl:text>\scriptsize </xsl:text>
    <xsl:apply-templates select="d:info/d:author"/>
    <xsl:text>/</xsl:text>
    <xsl:apply-templates select="d:info/d:title"/>
    <xsl:text>/\thepage</xsl:text>

    <xsl:text>}}</xsl:text>

    <!-- Footers -->
    <xsl:text>
\makeevenfoot{plain}{}{}{}
\makeoddfoot{plain}{}{}{}

\pagestyle{custompage}
    </xsl:text>
  </xsl:template>

  <!-- Paragraphs -->
  <xsl:template match="d:para|d:simpara">
	<!-- Put a blank between the lines. -->
	<xsl:text>\vspace{12pt}</xsl:text>

	<!-- Add in the line counter -->
	<xsl:if test="@mw:para-index">
	  <!-- We put this in the left margin, coupled with a bit of white
	       space to shift it down. -->
	  <xsl:text>\hspace{0pt}\marginpar{\hspace{12pt} \tiny </xsl:text>
	  <xsl:value-of select="@mw:para-index"/>
	  <xsl:text>}</xsl:text>
	</xsl:if>

	<!-- Perform normal processing of the paragraph -->
    <xsl:next-match />
  </xsl:template>

  <xsl:template match="d:bridgehead[@otherrenderas='break']">
    <xsl:text>\vskip\onelineskip {\centering \# \# \#\\} </xsl:text>
    <xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
