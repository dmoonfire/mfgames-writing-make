<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns="http://www.w3.org/1999/xhtml"
	xmlns:mfw="urn:mfgames:writing:docbook,0"
    version="1.0">
  <xsl:template match="d:mediaobject">
	<!-- With ODF, we have to have the image inside a paragraph tag. -->
	<xsl:choose>
	  <xsl:when test="parent::d:para or parent::node()/parent::d:para">
		<xsl:apply-templates select="." mode="media.chooser"/>
	  </xsl:when>
	  <xsl:when test="parent::d:cover or parent::node()/parent::d:cover">
		<p>
		  <xsl:apply-templates select="." mode="media.chooser"/>
		</p>
	  </xsl:when>
	  <xsl:otherwise>
		<p>
		  <xsl:apply-templates select="." mode="media.chooser"/>
		</p>
	  </xsl:otherwise>
	</xsl:choose>
  </xsl:template>

  <xsl:template match="d:mediaobject" mode="media.chooser">
	<!-- DocBook allows for multiple image, video, and text objects within the object. According to the specification, we have to pick the first one that we can support. That isn't entirely easy. -->
	<xsl:apply-templates select="d:imageobject|d:textobject"/>
  </xsl:template>

  <xsl:template match="d:imageobject">
	<!-- @align                                                  -->
	<!-- @contentwidth                                           -->
	<!-- @contentheight                                          -->
	<!-- @fileref                                                -->
	<!-- @format                                                 -->
	<!-- @scale                                                  -->
	<!-- @scalefit                                               -->
	<!-- @valign                                                 -->
	<!-- @width                                                  -->
	<!-- @depth                                                  -->
	
	<!-- Only handle this if we are the first.-->
	<xsl:if test="position() = 1">
	  <img src="{d:imagedata/@fileref}" alt="{../d:alt}"/>
	</xsl:if>
  </xsl:template>

  <xsl:template match="d:textobject">
	<xsl:if test="position() = 1">
	  <xsl:apply-templates/>
	</xsl:if>
  </xsl:template>

  <xsl:template match="screenshot">
	<xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
