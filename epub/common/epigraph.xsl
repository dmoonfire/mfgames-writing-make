<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xlink="http://www.w3.org/1999/xlink"
    version="2.0">
  <xsl:template match="d:epigraph">
	<xsl:apply-templates select="d:simpara|d:para" mode="epigraph"/>
	<xsl:apply-templates select="d:attribution" mode="epigraph"/>
	<p>&#xa0;</p>
  </xsl:template>

  <xsl:template match="d:simpara|d:para" mode="epigraph">
	<p class="indent1">
	  <xsl:apply-templates/>
	</p>
  </xsl:template>

  <xsl:template match="d:attribution" mode="epigraph">
	<p class="indent2">
	  <xsl:text>&#x2014;&#xa0;</xsl:text>
	  <xsl:apply-templates/>
	</p>
  </xsl:template>
</xsl:stylesheet>
