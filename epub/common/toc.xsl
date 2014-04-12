<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns="http://www.w3.org/1999/xhtml"
	xmlns:mfw="urn:mfgames:writing:docbook,0"
    version="2.0">
  <xsl:template match="d:*" mode="toc">
	<xsl:param name="depth"/>

	<!-- Give the section a heading title based on the level. -->
	<xsl:element name="h{$depth}">
	  <xsl:call-template name="insert-anchor"/>
	  <xsl:attribute name="class">page</xsl:attribute>
	  <xsl:attribute name="id">toc</xsl:attribute>
	  <xsl:text>Table of Contents</xsl:text>
	</xsl:element>

	<xsl:apply-templates select="." mode="toc-entry">
	  <xsl:with-param name="depth">0</xsl:with-param>
	</xsl:apply-templates>
  </xsl:template>

  <!-- TOC Entries -->
  <xsl:template match="d:book|d:chapter|d:article|d:section|d:appendix" mode="toc-entry">
	<xsl:param name="depth"/>

	<xsl:apply-templates select="d:dedication|d:acknowledgments" mode="toc-entry">
	  <xsl:with-param name="depth">
		<xsl:value-of select="number($depth)"/>
	  </xsl:with-param>
	</xsl:apply-templates>

    <!-- Include the name of the article as a heading 1. -->	
	<p>
	  <xsl:choose>
		<xsl:when test="number($depth) = 0">
		  <xsl:attribute name="class">indent1</xsl:attribute>
		</xsl:when>
		<xsl:when test="number($depth) = 1">
		  <xsl:attribute name="class">indent2</xsl:attribute>
		</xsl:when>
		<xsl:when test="number($depth) = 2">
		  <xsl:attribute name="class">indent3</xsl:attribute>
		</xsl:when>
	  </xsl:choose>

	  <xsl:if test="@xml:id">
		<a href="content.html#{@xml:id}">
		  <xsl:apply-templates select="." mode="insert-toc-number">
			<xsl:with-param name="index">
			  <xsl:value-of select="position()"/>
			</xsl:with-param>
		  </xsl:apply-templates>

		  <xsl:apply-templates select="d:info/d:title" mode="toc-entry"/>
		</a>
	  </xsl:if>
	  <xsl:if test="not(@xml:id)">
		<xsl:apply-templates select="." mode="insert-toc-number">
		  <xsl:with-param name="index">
			<xsl:value-of select="position()"/>
		  </xsl:with-param>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="d:info/d:title" mode="toc-entry"/>
	  </xsl:if>	  
	</p>

	<!-- Include the rest of the items. -->
	<xsl:apply-templates select="d:chapter|d:article|d:section" mode="toc-entry">
	  <xsl:with-param name="depth">
		<xsl:value-of select="number($depth) + 1"/>
	  </xsl:with-param>
	</xsl:apply-templates>

	<xsl:apply-templates select="d:appendix|d:colophon" mode="toc-entry">
	  <xsl:with-param name="depth">
		<xsl:value-of select="number($depth)"/>
	  </xsl:with-param>
	</xsl:apply-templates>
  </xsl:template>

  <xsl:template match="d:colophon" mode="toc-entry">
	<p class='indent1'><a href="content.html#colophon">Colophon</a></p>
  </xsl:template>

  <xsl:template match="d:dedication" mode="toc-entry">
	<p class='indent1'><a href="content.html#dedication">Dedication</a></p>
  </xsl:template>

  <xsl:template match="d:acknowledgments" mode="toc-entry">
	<p class='indent1'><a href="content.html#acknowledgments">Acknowledgments</a></p>
  </xsl:template>

  <!-- Structural Elements -->
  <xsl:template match="*" priority="-1" mode="toc-entry"/>

  <!-- Numbering -->
  <xsl:template match="d:chapter" mode="insert-toc-number">
	<xsl:param name="index"/>

	<xsl:if test="not(//mfw:output/@chapter-numbers = 'none')">
	  <xsl:text>Chapter </xsl:text>
	  <xsl:value-of select="$index"/>
	  <xsl:text>: </xsl:text>
	</xsl:if>
  </xsl:template>

  <xsl:template match="*" mode="insert-toc-number" priority="-1"/>

  <!-- Info -->
  <xsl:template match="d:title" mode="toc-entry">
	<xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>
