<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns="http://www.w3.org/1999/xhtml"
	xmlns:mbp="mobi"
	xmlns:xlink="http://www.w3.org/1999/xlink"
    version="2.0">
  <xsl:template match="d:itemizedlist">
	<ul>
	  <xsl:apply-templates/>
	</ul>
  </xsl:template>

  <xsl:template match="d:listitem">
	<li>
	  <xsl:apply-templates mode="list"/>
	</li>
  </xsl:template>

  <xsl:template match="d:para" mode="list">
	<xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="d:*" mode="list" priority="-1">
	<xsl:apply-templates select="."/>
  </xsl:template>
</xsl:stylesheet>