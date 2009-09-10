<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:aws="http://webservices.amazon.com/AWSECommerceService/2009-07-01">
  
  <xsl:output method="xml"/>
  
  <xsl:template match="/">
    <rss version="2.0">
      <channel>
        <xsl:apply-templates select="aws:ListLookupResponse/aws:Lists/aws:List" />
      </channel>
    </rss>
  </xsl:template>
  
  <xsl:template match="aws:List">
    <title>WishList for <xsl:value-of select="aws:CustomerName" /></title>
    <link><xsl:value-of select="aws:ListURL"/></link>
    <xsl:apply-templates select="aws:ListItem"/>
  </xsl:template>
  
  <xsl:template match="aws:ListItem">
      <item>
        <title><xsl:value-of select="aws:Item/aws:ItemAttributes/aws:Title" /></title>
        <link><xsl:value-of select="aws:Item/aws:DetailPageURL" /></link>
        <description>
          <p>Author: <xsl:value-of select="aws:Item/aws:ItemAttributes/aws:Author" /></p>
          <p>ISBN: <xsl:value-of select="aws:Item/aws:ItemAttributes/aws:ISBN" /></p>
          <p>List Price: <xsl:value-of select="aws:Item/aws:ItemAttributes/aws:ListPrice/aws:FormattedPrice" /></p>
          <p>Price: <xsl:value-of select="aws:Item/aws:OfferSummary/aws:LowestNewPrice/aws:FormattedPrice"/></p>
          <xsl:apply-templates select="aws:Item/aws:ItemLinks/aws:ItemLink"/>
        </description>
        <guid><xsl:value-of select="aws:Item/aws:DetailPageURL" /></guid>
      </item>
  </xsl:template>
  
  <xsl:template match="aws:ItemLink">
    <a href="{aws:URL}"><xsl:value-of select="aws:Description" /></a>
  </xsl:template>
  
</xsl:stylesheet>