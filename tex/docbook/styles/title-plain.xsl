<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
  <xsl:template match="d:book" mode="maketitle">
    <xsl:text>
\makeatletter
\def\maketitle{%
  \null
  \thispagestyle{empty}%
  \vfill
  \begin{center}\leavevmode
    \normalfont
    {\fontsize{48pt}{52pt}\selectfont \@title\par}%
    \vskip 2cm
    {\LARGE \@author\par}%
  \end{center}%
  \vfill
  \null
  \cleardoublepage
  }
\makeatother
    </xsl:text>
  </xsl:template>
</xsl:stylesheet>
