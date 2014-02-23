<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
  <xsl:variable name="text.indent">0.2in</xsl:variable>
  <xsl:variable name="margin.inner">0.7in</xsl:variable>
  <xsl:variable name="margin.outer">0.5in</xsl:variable>
  <xsl:variable name="margin.top">1.0in</xsl:variable>
  <xsl:variable name="margin.bottom">0.7in</xsl:variable>

  <xsl:template match="d:*" mode="setup-page-size">
	<xsl:message>Using 6x9 page size</xsl:message>
    <xsl:text>
%% Configuration settings for a 6x9 page.
\setlength\parindent{0.5in}
\setstocksize{9in}{6in}
\settrimmedsize{9in}{6in}{*}
\settrims{0in}{0in}
\setheadfoot{15pt}{15pt}
\setlength\headsep{12pt}
	</xsl:text>
  </xsl:template>
</xsl:stylesheet>
