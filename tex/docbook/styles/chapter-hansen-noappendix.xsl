<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
  <xsl:template match="d:book" mode="makechapter">
	<xsl:message>Using Hansen chapter style</xsl:message>
    <xsl:text>
\definecolor{chaptercolor}{gray}{0.8}
% helper macros
\newcommand\numlifter[1]{\raisebox{-2cm}[0pt][0pt]{\smash{#1}}}
\newcommand\numindent{\kern37pt}
\newlength\chaptertitleboxheight
\makechapterstyle{hansen}{
\renewcommand\printchaptername{\raggedleft}
\renewcommand\printchapternum{%
\begingroup%
\leavevmode%
\chapnumfont%
\strut%
\numlifter{\thechapter}%
\numindent%
\endgroup%
}
\renewcommand
*
{\printchapternonum}{%
\vphantom{\begingroup%
\leavevmode%
\chapnumfont%
\numlifter{\vphantom{9}}%
\numindent%
\endgroup}
\afterchapternum}
\setlength\midchapskip{0pt}
\setlength\beforechapskip{0.5\baselineskip}
\setlength{\afterchapskip}{3\baselineskip}
\renewcommand\chapnumfont{%
\fontsize{4cm}{0cm}%
\bfseries%
\sffamily%
\color{chaptercolor}%
}
\renewcommand\chaptitlefont{%
\normalfont%
\huge%
\bfseries%
\raggedleft%
}%
\settototalheight\chaptertitleboxheight{%
\parbox{\textwidth}{\chaptitlefont \strut bg\\bg\strut}}
\renewcommand\printchaptertitle[1]{%
\parbox[t][\chaptertitleboxheight][t]{\textwidth}{%
%\microtypesetup{protrusion=false}% add this if you use microtype
\chaptitlefont\strut ##1\strut}%
}
}
\chapterstyle{hansen}
    </xsl:text>
  </xsl:template>
</xsl:stylesheet>
