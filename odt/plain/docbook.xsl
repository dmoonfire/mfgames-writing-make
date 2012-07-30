<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:docbook="http://docbook.org/ns/docbook"
    xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
    xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
    xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0"
    xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
    xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:meta="urn:oasis:names:tc:opendocument:xmlns:meta:1.0" 
    xmlns:number="urn:oasis:names:tc:opendocument:xmlns:datastyle:1.0"
    xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"
    xmlns:chart="urn:oasis:names:tc:opendocument:xmlns:chart:1.0"
    xmlns:dr3d="urn:oasis:names:tc:opendocument:xmlns:dr3d:1.0"
    xmlns:math="http://www.w3.org/1998/Math/MathML"
    xmlns:form="urn:oasis:names:tc:opendocument:xmlns:form:1.0"
    xmlns:script="urn:oasis:names:tc:opendocument:xmlns:script:1.0"
    xmlns:dom="http://www.w3.org/2001/xml-events"
    xmlns:xforms="http://www.w3.org/2002/xforms"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:presentation="urn:oasis:names:tc:opendocument:xmlns:presentation:1.0"
    version="1.0">
  <!-- Import the rest of ODF stylesheet -->
  <xsl:import href="/usr/share/docbook2odf/xsl/docbook.xsl"/>

  <!-- Sections without Titles -->
  <xsl:template
      match="docbook:section[not(docbook:info/docbook:title)]"
      priority="10">
    <text:p text:style-name="Section_20_Divider">
      <xsl:text># # #</xsl:text>
    </text:p>

    <xsl:apply-templates/>
  </xsl:template>

  <!-- Custom Quotes -->
  <xsl:template match="docbook:quote[@xml:lang='miw']" priority="10">
    <text:span>
      <xsl:text>&#x201c;</xsl:text>
      <text:span text:style-name="Text_20_Italic">
	<xsl:apply-templates/>
      </text:span>
      <xsl:text>&#x201d;</xsl:text>
    </text:span>
  </xsl:template>  

  <!-- Custom Foreign Phrases -->
  <xsl:template match="docbook:foreignphrase[@xml:lang='miw']" priority="10">
    <text:span text:style-name="Text_20_Italic">
      <xsl:apply-templates/>
    </text:span>
  </xsl:template>  
</xsl:stylesheet>