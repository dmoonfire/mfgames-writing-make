<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
  <xsl:template match="d:legalnotice">
    <xsl:text>\clearpage </xsl:text>
    <xsl:apply-templates/>
	<xsl:apply-templates select="../d:copyright"/>
	<xsl:apply-templates select="../d:publisher"/>
	<xsl:apply-templates select="../d:bibliod[class='isbn']"/>
  </xsl:template>

  <xsl:template match="d:copyright">
	<xsl:text>\begin{center}</xsl:text>
	<xsl:text>Copyright &#169; </xsl:text>
	<xsl:apply-templates select="d:year"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="d:holder"/>
	<xsl:text>\end{center}</xsl:text>
  </xsl:template>
 
  <xsl:template match="d:year">
	<xsl:apply-templates/><xsl:text>, </xsl:text>
  </xsl:template>

  <xsl:template match="d:publisher">
	<xsl:text>\begin{center}</xsl:text>
	<xsl:value-of select="d:publishername"/>
	<xsl:text>\end{center}</xsl:text>
  </xsl:template>

  <xsl:template match="d:biblioid">
	<xsl:text>\begin{center}</xsl:text>
	<xsl:text>ISBN: </xsl:text>
	<xsl:apply-templates/>
	<xsl:text>\end{center}</xsl:text>
  </xsl:template>
</xsl:stylesheet>
