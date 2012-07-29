<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
  <!-- Import the rest of the styesheets -->
  <xsl:import href="docbook/docbook.xsl"/>
  <xsl:import href="docbook/dropcaps.xsl"/>
  <xsl:import href="locale.xsl"/>

  <!-- Setup -->
  <xsl:variable name="document.class">
    letter, 12pt, oneside, final, onecolumn
  </xsl:variable>

  <xsl:variable name="package.titlesec.options"></xsl:variable>

  <!-- Fonts -->
  <xsl:variable name="font.main">Gentium</xsl:variable>

  <!-- Titles -->
  <xsl:template match="d:book" mode="create-title">
  </xsl:template>

  <xsl:template match="d:article" mode="maketitle">
    <xsl:text>
\makeatletter
\def\maketitle{%
  \thispagestyle{empty}%
  \begin{center}\leavevmode
    \hrulefill{\small\ \@author}\par
    {\huge\@title\par}
    \hrulefill\par
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
    \vskip 2cm
    \hrulefill\par
    \vskip 1cm
    {\HUGE\@title\par}
    \vskip 1cm
    \hrulefill\par
    \vskip 2cm
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
  <xsl:template match="d:article" mode="pagestyle">
    <xsl:text>\makepagestyle{custompage}</xsl:text>

    <!-- Odd Side -->
    <xsl:text>\makeoddhead{custompage}{{</xsl:text>

    <xsl:text>\scriptsize </xsl:text>
    <xsl:apply-templates select="d:info/d:author"/>

    <xsl:text>}}{{</xsl:text>
    <xsl:text>}}{{</xsl:text>

    <xsl:text>\scriptsize </xsl:text>
    <xsl:apply-templates select="d:info/d:title"/>
    <xsl:text>\hskip.5cm\vrule\hskip.5cm\thepage</xsl:text>

    <xsl:text>}}</xsl:text>

    <!-- Footers -->
    <xsl:text>
\makeevenfoot{plain}{}{}{}
\makeoddfoot{plain}{}{}{}

\pagestyle{custompage}
    </xsl:text>
  </xsl:template>

  <xsl:template match="d:book" mode="pagestyle">
    <xsl:text>\makepagestyle{custompage}</xsl:text>

    <!-- Odd Side -->
    <xsl:text>\makeoddhead{custompage}{{</xsl:text>

    <xsl:text>\scriptsize </xsl:text>
    <xsl:apply-templates select="d:info/d:author"/>

    <xsl:text>}}{{</xsl:text>
    <xsl:text>}}{{</xsl:text>

    <xsl:text>\scriptsize </xsl:text>
    <xsl:apply-templates select="d:info/d:title"/>
    <xsl:text>\hskip.5cm\vrule\hskip.5cm\thepage</xsl:text>

    <xsl:text>}}</xsl:text>

    <!-- Footers -->
    <xsl:text>
\makeevenfoot{plain}{}{}{}
\makeoddfoot{plain}{}{}{}

\pagestyle{custompage}
    </xsl:text>
  </xsl:template>
</xsl:stylesheet>
