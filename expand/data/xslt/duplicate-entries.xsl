<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:math="http://www.w3.org/2005/xpath-functions/math"
 xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
 xmlns:tei="http://www.tei-c.org/ns/1.0"
 xmlns:xml="http://www.w3.org/XML/1998/namespace"
 exclude-result-prefixes="xs math xd tei"
 version="3.0">
 <xd:doc scope="stylesheet">
  <xd:desc>
   <xd:p><xd:b>Created on:</xd:b> May 19, 2025</xd:p>
   <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
   <xd:p></xd:p>
  </xd:desc>
 </xd:doc>
 
 <xsl:strip-space elements="*"/>
 <xsl:mode on-no-match="shallow-copy"/>
 <xsl:output method="xml" indent="yes" />
 
 <xsl:param name="multiplier" as="xs:integer" select="10" />
 
 <xsl:template match="tei:entry">
  <xsl:variable name="entry" select="."/>
  <xsl:copy-of select="." />
   
  <xsl:for-each select="(1 to $multiplier)">
   <xsl:variable name="iteration" select="."/>
   <xsl:element name="{name($entry)}" namespace="http://www.tei-c.org/ns/1.0">
    <xsl:copy-of select="$entry/@*" />
    <xsl:call-template name="add-xml-id">
     <xsl:with-param name="iteration" select="$iteration"/>
     <xsl:with-param name="root" select="$entry"/>
    </xsl:call-template>
    <xsl:apply-templates select="$entry/*">
     <xsl:with-param name="iteration" select="$iteration" />
    </xsl:apply-templates>
   </xsl:element>
  </xsl:for-each>
 </xsl:template>
 
 <xsl:template match="tei:sense">
  <xsl:param name="iteration" as="xs:integer" />
  <xsl:copy>
   <xsl:copy-of select="@*" />
   <xsl:call-template name="add-xml-id">
    <xsl:with-param name="iteration" select="$iteration"/>
    <xsl:with-param name="root" select="."/>
   </xsl:call-template>
   <xsl:apply-templates />
  </xsl:copy>
 </xsl:template>
 
 <xsl:template match="tei:form/tei:term">
  <xsl:param name="iteration" as="xs:integer" />
  <xsl:element name="form" namespace="http://www.tei-c.org/ns/1.0">
   <xsl:copy-of select="@*" />
   <xsl:attribute name="type" select="'lemma'" />
   <xsl:value-of select="concat(replace(normalize-space(), '\s', $iteration || ' '), $iteration)"/>
  </xsl:element>
 </xsl:template>
 
 
 <xsl:template name="add-xml-id">
  <xsl:param name="iteration" as="xs:integer" />
  <xsl:param name="root" as="element()" />
  <xsl:attribute name="id" namespace="http://www.w3.org/XML/1998/namespace" select="concat($root/@xml:id, '-', format-number($iteration, '000'))" />
 </xsl:template>
 
</xsl:stylesheet>