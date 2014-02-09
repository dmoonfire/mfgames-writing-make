<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
  <xsl:variable name="text.indent">0.2in</xsl:variable>

  <xsl:template match="d:*" mode="setup-page-size">
	<xsl:message>Using 6x9 page size</xsl:message>
    <xsl:text>
%% Configuration settings for a 6x9 page.
\setlength\parindent{0.5in}
\setstocksize{9in}{6in}
\settrimmedsize{9in}{6in}{*}
\settrims{0in}{0in}
\setlrmarginsandblock{0.7in}{0.5in}{*}
\setulmarginsandblock{1in}{0.7in}{*}
\setheadfoot{15pt}{15pt}
\setlength\headsep{12pt}
\checkandfixthelayout
	</xsl:text>
  </xsl:template>
</xsl:stylesheet>
