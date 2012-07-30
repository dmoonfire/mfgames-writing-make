<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
  <xsl:template match="/">
	<fo:root>
	  <fo:layout-master-set>
		<fo:simple-page-master 
			page-height="1200px" 
			page-width="800px"
			master-name="only">
		  <fo:region-body 
			  region-name="xsl-region-body"  
			  margin-right="50px"
			  margin-left="50px"
			  />
		  <fo:region-before
			  region-name="xsl-region-before" 
			  extent="200px" />
		  <fo:region-after 
			  region-name="xsl-region-after"
			  extent="200px" />
		</fo:simple-page-master>
	  </fo:layout-master-set>
	  
	  <fo:page-sequence master-reference="only" format="A">
		<fo:flow flow-name="xsl-region-body">
		  <xsl:apply-templates select="*/d:info"/>
		</fo:flow>
	  </fo:page-sequence>
	</fo:root>
  </xsl:template>

  <xsl:template match="d:info">
	<xsl:apply-templates select="d:title"/>
	<xsl:apply-templates select="d:author"/>
  </xsl:template>

  <xsl:template match="d:title">
	<fo:block
		font-size="72pt"
		text-align="center"
		font-family="Gentium"
		border-top-style="solid"
		border-top-color="black"
		border-top-width="2px"
		border-bottom-style="solid"
		border-bottom-color="black"
		border-bottom-width="2px"
		margin-top="200px"
		padding-top="50px"
		padding-bottom="50px"
		>
	  <xsl:apply-templates/>
	</fo:block>
  </xsl:template>

  <xsl:template match="d:author">
	<fo:block
		font-size="48pt"
		text-align="center"
		font-family="Gentium"
		margin-top="200px"
		>
	  <xsl:if test="d:firstname">
		<xsl:value-of select="d:firstname"/>
		<xsl:text> </xsl:text>
	  </xsl:if>
	  <xsl:apply-templates select="d:surname"/>
	</fo:block>
  </xsl:template>
</xsl:stylesheet>