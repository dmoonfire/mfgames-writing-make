<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:xlink="http://www.w3.org/1999/xlink"
    version="2.0">

  <xsl:template match="d:mediaobject">
	<xsl:apply-templates select="d:imageobject"/>
  </xsl:template>

  <xsl:template match="d:imageobject[position() = 1]">
	<xsl:if test="not(name(../../..) = 'para' and @align = 'center')">
	  <xsl:text>\begin{center}</xsl:text>
	</xsl:if>

	<xsl:text>\includegraphics[</xsl:text>

	<xsl:text>width=</xsl:text>
	<xsl:if test="d:imagedata/@width">
	  <xsl:value-of select="d:imagedata/@width"/>
	</xsl:if>
	<xsl:if test="not(d:imagedata/@width)">
	  <xsl:text>\linewidth</xsl:text>
	</xsl:if>

	<xsl:text>,keepaspectratio=true</xsl:text>
	<xsl:text>]{</xsl:text>
	<xsl:value-of select="d:imagedata/@fileref"/>
	<xsl:text>}</xsl:text>

	<xsl:if test="not(name(../../..) = 'para' and @align = 'center')">
	  <xsl:text>\end{center}</xsl:text>
	</xsl:if>
  </xsl:template>

  <xsl:template match="d:imageobject">
  </xsl:template>

<!--
	  <mediaobject>
		<imageobject>
		  <imagedata fileref="../fangs-for-nothing/ad.jpg" align="center" scalefit="1" />
		</imageobject>
	  </mediaobject>
-->
</xsl:stylesheet>
