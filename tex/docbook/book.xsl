<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
  <!--
      Titles
  -->
  <xsl:template match="d:book" mode="setup"/>

  <xsl:template match="d:book" mode="title">
    <!-- Insert the custom title page -->
    <xsl:text>\begin{titlingpage}</xsl:text>
    <xsl:text>\maketitle</xsl:text>
    <xsl:apply-templates select="d:info/d:legalnotice"/>
    <xsl:text>\end{titlingpage}</xsl:text>
  </xsl:template>

  <xsl:template match="d:book" mode="maketitle">
    <xsl:text>
\makeatletter
\def\maketitle{%
  \null
  \thispagestyle{empty}%
  \vfill
  \begin{center}\leavevmode
    \normalfont
    {\LARGE\raggedleft \@author\par}%
    \hrulefill\par
    {\huge\raggedright \@title\par}%
    \vskip 1cm
%    {\Large \@date\par}%
  \end{center}%
  \vfill
  \null
  \cleardoublepage
  }
\makeatother
    </xsl:text>
  </xsl:template>

  <xsl:template match="d:book" mode="makechapter">
    <xsl:text>% Create the chapter style used in the document.
    \makeatletter
    \makechapterstyle{mf}{%
    \chapterstyle{default}
    \renewcommand*{\chapnamefont}{\normalfont\Large\itshape}
  \renewcommand*{\chapnumfont}{\normalfont\huge}
  \renewcommand*{\printchaptername}{%
    \chapnamefont\centering\@chapapp}
  \renewcommand*{\printchapternum}{\chapnumfont \textit{\thechapter}}
  \renewcommand*{\chaptitlefont}{\normalfont\Huge}
  \renewcommand*{\printchaptertitle}[1]{%
    \vskip\onelineskip \centering \chaptitlefont\textbf{##1}\par}
  \renewcommand*{\afterchaptertitle}{\vskip\onelineskip \vskip
    \afterchapskip}
  \renewcommand*{\printchapternonum}{%
    \vphantom{\chapnumfont \textit{9}}\afterchapternum}}
\makeatother
\chapterstyle{mf}
\renewcommand*{\chapterheadstart}{}

\renewcommand*{\cftchapterfont}{\scriptsize}
\renewcommand*{\cftchapterpagefont}{\scriptsize}
\renewcommand*{\cftchaptername}{Chapter }
\renewcommand{\cftchapteraftersnum}{:}
\setlength{\cftbeforechapterskip}{0pt}
    </xsl:text>
  </xsl:template>

  <!--
      Front Matter
  -->
  <xsl:template match="d:book" mode="frontmatter">
    <xsl:text>\frontmatter</xsl:text>
    <xsl:call-template name="newline"/>
    <xsl:apply-templates select="d:dedication"/>
    <xsl:apply-templates select="d:acknowledgments"/>
    <xsl:text>\clearpage\tableofcontents*</xsl:text>
    <xsl:apply-templates select="d:preface"/>
  </xsl:template>
  
  <!--
      Main Matter
  -->
  <xsl:template match="d:book" mode="mainmatter">
    <!-- With books, we use the \mainmatter to break apart the
         region. This also creates a page break before the main
         contents. -->
    <xsl:text>\mainmatter</xsl:text>
    <xsl:apply-templates select="d:chapter"/>
  </xsl:template>
  
  <!--
      Back Matter
  -->
  <xsl:template match="d:book" mode="backmatter">
	<xsl:apply-templates select="d:appendix"/>

    <xsl:if test="d:colophon">
      <xsl:text>\backmatter</xsl:text>
      <xsl:call-template name="newline"/>
      <xsl:apply-templates select="d:colophon"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="d:appendix">
	<xsl:text>\appendix </xsl:text>

    <xsl:text>\chapter{</xsl:text>
    <xsl:call-template name="insert-title"/>
    <xsl:text>}</xsl:text>

	<xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>