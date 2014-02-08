<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
  <xsl:template match="d:appendix">
	<xsl:text>\renewcommand\thechapter{}</xsl:text>
    <xsl:text>\chapter{</xsl:text>
    <xsl:call-template name="insert-title"/>
    <xsl:text>}</xsl:text>

	<xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
