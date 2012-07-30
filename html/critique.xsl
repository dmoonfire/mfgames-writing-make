<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:mw="urn:mfgames:writing:docbook,0"
    version="2.0">
  <!-- Import the rest of DocBook HTML -->
  <xsl:import href="plain.xsl"/>

  <!-- Modify critique paragraphs to include the paragraph index. -->
  <xsl:template match="d:simpara[@mw:para-index]" priority="1">
    <div class="para-index">
      <xsl:value-of select="@mw:para-index"/>
    </div>
    <p class="para-index-p"><xsl:apply-templates/></p>
  </xsl:template>

  <xsl:template 
      match="d:simpara[name(parent::node()) = 'blockquote']"
      priority="2">
    <p><xsl:apply-templates/></p>
  </xsl:template>
</xsl:stylesheet>
