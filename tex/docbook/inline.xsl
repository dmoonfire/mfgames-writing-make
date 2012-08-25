<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xlink="http://www.w3.org/1999/xlink"
    version="2.0">
  <xsl:template match="d:emphasis[@role='strong' or @role='bold']">
    <xsl:text>\textbf{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="d:emphasis[not(@role='strong' or @role='bold')]">
    <xsl:text>\emph{</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="d:link[@role='print']">
	<xsl:apply-templates/>

	<xsl:text> [</xsl:text>
	<xsl:value-of select="@xlink:href"/>
	<xsl:text>]</xsl:text>
  </xsl:template>
</xsl:stylesheet>