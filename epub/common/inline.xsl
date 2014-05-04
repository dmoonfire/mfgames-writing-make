<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns="http://www.w3.org/1999/xhtml"
	xmlns:mbp="mobi"
	xmlns:xlink="http://www.w3.org/1999/xlink"
    version="2.0">
  <!-- Inlines -->
  <xsl:template match="d:emphasis[@role='strong']" priority="1">
	<strong><xsl:apply-templates/></strong>
  </xsl:template>

  <xsl:template match="d:emphasis|d:citetitle">
	<em><xsl:apply-templates/></em>
  </xsl:template>

  <xsl:template match="d:quote">
	<xsl:text>&#x201C;</xsl:text>
	<xsl:apply-templates/>
	<xsl:text>&#x201D;</xsl:text>
  </xsl:template>

  <!-- Links -->
  <xsl:template match="d:link">
	<a href="{@xlink:href}">
	  <xsl:apply-templates/>
	</a>
  </xsl:template>

  <!-- Superscript -->
  <xsl:template match="d:superscript">
	<sup><xsl:apply-templates/></sup>
  </xsl:template>
</xsl:stylesheet>
