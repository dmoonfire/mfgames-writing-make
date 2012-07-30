<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xlink="http://www.w3.org/1999/xlink"
    version="2.0">
  <!-- Contents -->
  <xsl:template name="insert-body-contents">
	<xsl:param name="depth"/>

	<xsl:apply-templates select="d:para|d:simpara|d:blockquote|d:itemizedlist|d:bridgehead|d:poetry"/>
	
	<xsl:apply-templates select="d:chapter|d:article|d:section">
	  <xsl:with-param name='depth'>
		<xsl:value-of select="$depth"/>
	  </xsl:with-param>
	</xsl:apply-templates>
  </xsl:template>

  <!-- Paragraphs -->
  <xsl:template match="d:para|d:simpara">
	<p>
	  <xsl:attribute name="class">
		<xsl:choose>
		  <xsl:when test="contains(@role, 'slab')">
			<xsl:value-of select="@role"/>
		  </xsl:when>
		  <xsl:when test="not(@role)">
			<xsl:text>indented</xsl:text>
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:value-of select="@role"/>
		  </xsl:otherwise>
		</xsl:choose>
	  </xsl:attribute>

	  <xsl:apply-templates />
	</p>
  </xsl:template>

  <xsl:template match="d:blockquote">
	<blockquote>
	  <xsl:apply-templates/>
	</blockquote>
  </xsl:template>

  <!-- Images -->
  <xsl:template match="d:mediaobject[
					   name(..) = 'para' or name(..) = 'simpara']">
	<xsl:apply-templates select="." mode="image"/>
  </xsl:template>

  <xsl:template match="d:mediaobject[not(
					   name(..) = 'para' or name(..) = 'simpara')]">
	<!-- Image is not in a paragraph tab, so wrap it. -->
	<p class='center'><xsl:apply-templates select="." mode="image"/></p>
  </xsl:template>

  <xsl:template match="d:mediaobject" mode="image">
	<xsl:apply-templates select="d:imageobject"/>
  </xsl:template>

  <xsl:template match="d:imageobject">
	<xsl:apply-templates select="d:imagedata"/>
  </xsl:template>

  <xsl:template match="d:imagedata">
	<xsl:element name="img">
	  <xsl:attribute name="src">
		<xsl:value-of select="@fileref"/>
	  </xsl:attribute>
	  <xsl:attribute name="alt">
		<xsl:value-of select="../../d:alt"/>
	  </xsl:attribute>
	</xsl:element>
  </xsl:template>

  <!-- Bridgeheads -->
  <xsl:template match="d:bridgehead[@otherrenderas='break']">
	<p class='center'>* * *</p>
  </xsl:template>

  <!-- Poetry -->
  <xsl:template match="d:poetry">
	<xsl:apply-templates />
  </xsl:template>

  <xsl:template match="d:linegroup">
	<div>
	  <xsl:attribute name="class">
		<xsl:choose>
		  <xsl:when test="contains(@role, 'slab')">
			<xsl:value-of select="@role"/>
		  </xsl:when>
		  <xsl:when test="not(@role)">
			<xsl:text>slab</xsl:text>
		  </xsl:when>
		  <xsl:otherwise>
			<xsl:value-of select="@role"/>
		  </xsl:otherwise>
		</xsl:choose>
	  </xsl:attribute>

	  <xsl:apply-templates/>
	  <br/>
	</div>
  </xsl:template>

  <xsl:template match="d:line">
	<xsl:apply-templates/>
	<br/>
  </xsl:template>
</xsl:stylesheet>