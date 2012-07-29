<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
  <!--
      Titles
  -->
  <xsl:template match="d:article" mode="setup"/>

  <xsl:template match="d:article" mode="title">
    <xsl:text>\maketitle</xsl:text>
    <xsl:call-template name="newline"/>
  </xsl:template>
  
  <xsl:template match="d:article" mode="maketitle">
    <xsl:text>
\makeatletter
\def\maketitle{%
  \thispagestyle{empty}%
  \begin{center}\leavevmode
    \normalfont
    {\LARGE\raggedleft \@author\par}%
    \hrulefill\par
    {\huge\raggedright \@title\par}%
    \vskip 1cm
  \end{center}%
  }
\makeatother
    </xsl:text>
    <xsl:call-template name="newline"/>
  </xsl:template>

  <xsl:template match="d:article" mode="makechapter" />

  <!--
      Front Matter
  -->
  <xsl:template match="d:article" mode="frontmatter">
  </xsl:template>
  
  <!--
      Main Matter
  -->
  <xsl:template match="d:article" mode="mainmatter">
<xsl:message>bob</xsl:message>
    <xsl:apply-templates />
  </xsl:template>
  
  <!--
      Back Matter
  -->
  <xsl:template match="d:article" mode="backmatter">
  </xsl:template>
</xsl:stylesheet>