<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns="http://www.w3.org/1999/xhtml"
	xmlns:mbp="mobi"
	xmlns:xlink="http://www.w3.org/1999/xlink"
    version="2.0">
  <!-- Includes various other components -->
  <xsl:include href="../common/inline.xsl"/>
  <xsl:include href="../common/blocks.xsl"/>
  <xsl:include href="../common/lists.xsl"/>

  <xsl:template match="/">
	<html>
	  <head>
		<meta http-equiv="Content-Type"
			  content="application/xhtml+xml; charset=utf-8" />
		<title>
		  <xsl:apply-templates select="*/d:info/d:title"/>
		  
		  <xsl:if test="*/d:info/d:subtitle">
			<xsl:text>: </xsl:text>
			<xsl:apply-templates select="*/d:info/d:subtitle"/>
		  </xsl:if>
		</title>

		<!-- Add in the stylesheet -->
		<xsl:apply-templates select="*" mode="css-style"/>
	  </head>
	  <body>
		<!-- Front Matter -->
		<xsl:apply-templates select="*/d:info" mode="title"/>
		<xsl:apply-templates select="*/d:info" mode="legal"/>
		<xsl:apply-templates select="*/d:dedication" />
		<xsl:apply-templates select="*/d:acknowledgements" />

		<!-- Contents -->
		<xsl:apply-templates/>

		<p id='end' class='end'>END</p>
		
		<!-- Back Matter -->
		<xsl:apply-templates select="*/d:appendix|*/d:colophon">
		  <xsl:with-param name="depth">1</xsl:with-param>
		</xsl:apply-templates>
	  </body>
	</html>
  </xsl:template>

  <xsl:template match="d:book">
	<!-- Main Matter -->
	<xsl:apply-templates select="d:info" mode="title"/>
	<div id="start"/>
	
	<xsl:apply-templates select="d:preface">
	  <xsl:with-param name="depth">1</xsl:with-param>
	</xsl:apply-templates>
	
	<xsl:call-template name="insert-body-contents">
	  <xsl:with-param name="depth">1</xsl:with-param>
	</xsl:call-template>
  </xsl:template>

  <xsl:template match="/d:article">
	<h1 class='page'>
	  <xsl:call-template name="insert-anchor"/>
	  <xsl:apply-templates select="d:info/d:title"/>
	</h1>
	<div id="start"/>
	
	<xsl:apply-templates select="d:preface">
	  <xsl:with-param name="depth">2</xsl:with-param>
	</xsl:apply-templates>
	
	<xsl:call-template name="insert-body-contents">
	  <xsl:with-param name="depth">2</xsl:with-param>
	</xsl:call-template>
  </xsl:template>

  <!-- Legal Notices -->
  <xsl:template match="d:info" mode="legal">
	<!-- Add in the link for legal -->
	<div class='page' id="legal"/>

	<!-- Add in the copyright. -->
	<xsl:apply-templates select="d:copyright"/>

	<!-- Include the contents of the notice. -->
	<xsl:apply-templates select="d:legalnotice/d:para|d:legalnotice/d:simpara"/>
  </xsl:template>

  <xsl:template match="d:copyright">
	<para>
	  <xsl:text>Copyright &#169; </xsl:text>
	  <xsl:value-of select="d:year"/>
	  <xsl:text> </xsl:text>
	  <xsl:value-of select="d:holder"/>
	</para>
  </xsl:template>

  <!-- Dedication -->
  <xsl:template match="d:dedication">
	<xsl:param name="depth"/>

	<!-- Include the contents of the notice. -->
	<div class='dedication'>
	  <xsl:call-template name="insert-anchor"/>
	  <xsl:apply-templates select="d:para|d:simpara"/>
	</div>
  </xsl:template>

  <!-- Colophon -->
  <xsl:template match="d:colophon">
	<xsl:param name="depth"/>
	<xsl:message>colophon</xsl:message>

	<!-- Give the section a heading title based on the level. -->
	<xsl:element name="h{$depth}">
	  <xsl:call-template name="insert-anchor"/>
	  <xsl:attribute name="class">page</xsl:attribute>
	  <xsl:text>Colophon</xsl:text>
	</xsl:element>

	<!-- Include the contents of the notice. -->
	<xsl:apply-templates select="d:para|d:simpara"/>
  </xsl:template>

  <!-- Acknowledgments -->
  <xsl:template match="d:acknowledgements">
	<xsl:param name="depth"/>

	<!-- Give the section a heading title based on the level. -->
	<xsl:element name="h1">
	  <xsl:call-template name="insert-anchor"/>
	  <xsl:attribute name="class">page</xsl:attribute>
	  <xsl:text>Acknowledgements</xsl:text>
	</xsl:element>

	<!-- Include the contents of the notice. -->
	<xsl:apply-templates select="d:para|d:simpara"/>
  </xsl:template>

  <!-- Chapters, Sections with Titles -->
  <xsl:template match="d:chapter|d:appendix|d:preface">
	<xsl:param name="depth"/>

	<!-- Give the section a heading title based on the level. -->
	<xsl:element name="h{$depth}">
	  <xsl:attribute name="class">page</xsl:attribute>
	  <xsl:call-template name="insert-anchor"/>
	  <xsl:apply-templates select="d:info/d:title"/>
	</xsl:element>

	<!-- If we have an authors, then add them automatically. -->
	<xsl:if test="d:info//d:author">
	  <div class='bylinegroup'>
		<xsl:apply-templates select="d:info//d:author" mode="chapter"/>
	  </div>
	</xsl:if>

	<!-- Include the contents of the section. -->
	<xsl:call-template name="insert-body-contents">
	  <xsl:with-param name="depth">
		<xsl:value-of select="$depth + 1"/>
	  </xsl:with-param>
	</xsl:call-template>
  </xsl:template>

  <xsl:template match="d:section">
	<xsl:param name="depth"/>

	<!-- Give the section a heading title based on the level. -->
	<xsl:element name="h{$depth}">
	  <xsl:call-template name="insert-anchor"/>
	  <xsl:apply-templates select="d:info/d:title"/>
	</xsl:element>

	<!-- Include the contents of the section. -->
	<xsl:call-template name="insert-body-contents">
	  <xsl:with-param name="depth">
		<xsl:value-of select="$depth + 1"/>
	  </xsl:with-param>
	</xsl:call-template>
  </xsl:template>

  <!-- Sections without Title -->
  <xsl:template match="d:section[not(d:info/d:title)]">
	<xsl:message>Sections without Title are not supported.</xsl:message>
  </xsl:template>

  <!-- Structural Catches -->
  <xsl:template match="*" mode="title" priority="-1"/>

  <!-- Title Page -->
  <xsl:template match="d:info" mode="title">
	<div class='page'/>
	<xsl:apply-templates select="d:title" mode='title'/>
	<xsl:apply-templates select="d:subtitle" mode='title'/>
	<div class='authorgroup'>&#160;</div>
	<xsl:apply-templates select="d:author" mode='title'/>
  </xsl:template>

  <xsl:template match="d:title" mode='title'>
	<h1 class="title">
	  <xsl:apply-templates />
	</h1>
  </xsl:template>
  
  <xsl:template match="d:subtitle" mode='title'>
	<h2 class="subtitle">
	  <xsl:apply-templates />
	</h2>
  </xsl:template>
  
  <xsl:template match="d:author" mode="chapter">
	<h2 class='bylinesingle'>
	  <xsl:value-of select="d:personname/d:firstname"/>
	  <xsl:text> </xsl:text>
	  <xsl:value-of select="d:personname/d:othername"/>
	  <xsl:text> </xsl:text>
	  <xsl:value-of select="d:personname/d:surname"/>
	</h2>
  </xsl:template>

  <xsl:template match="d:author" mode='title'>
	<h2 class="author">
	  <xsl:value-of select="d:personname/d:firstname"/>

	  <xsl:if test="d:personname/d:othername">
		<xsl:text> </xsl:text>
		<xsl:value-of select="d:personname/d:othername"/>
	  </xsl:if>

	  <xsl:text> </xsl:text>
	  <xsl:value-of select="d:personname/d:surname"/>
	</h2>
  </xsl:template>

  <!-- Anchors -->
  <xsl:template name="insert-anchor">
	<xsl:if test="@id">
	  <xsl:attribute name="id">
		<xsl:value-of select="@id"/>
	  </xsl:attribute>
	</xsl:if>
  </xsl:template>

  <!-- Info -->
  <xsl:template match="d:title|d:subtitle">
	<xsl:apply-templates/>
  </xsl:template>
</xsl:stylesheet>