<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
  <xsl:template match="d:book" mode="makechapter">
	<xsl:message>Using dash chapter style</xsl:message>
    <xsl:text>
\makeatletter
\newcommand\thickhrulefill{\leavevmode \leaders \hrule height 1pt \hfill \kern \z@}
\setlength\midchapskip{10pt}
\makechapterstyle{dash}{
\renewcommand\chapternamenum{}
\renewcommand\printchaptername{}
\renewcommand\chapnamefont{\Large\scshape}
\renewcommand\printchapternum{%
\chapnamefont\null\thickhrulefill\quad
\@chapapp\space\thechapter\quad\thickhrulefill}
\renewcommand\printchapternonum{%
\par\thickhrulefill\par\vskip\midchapskip
\vskip\midchapskip
}
\renewcommand\chaptitlefont{\Huge\scshape\centering}
\renewcommand\afterchapternum{%
\par\nobreak\vskip\midchapskip\vskip\midchapskip}
\renewcommand\afterchaptertitle{%
\par\vskip\midchapskip\nobreak\vskip\afterchapskip}
}
\makeatother
\chapterstyle{dash}
    </xsl:text>
  </xsl:template>
</xsl:stylesheet>
