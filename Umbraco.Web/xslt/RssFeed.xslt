<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:msxml="urn:schemas-microsoft-com:xslt"
xmlns:umbraco.library="urn:umbraco.library"
xmlns:dc="http://purl.org/dc/elements/1.1/"
xmlns:content="http://purl.org/rss/1.0/modules/content/"
exclude-result-prefixes="msxml umbraco.library">

<xsl:output method="xml" omit-xml-declaration="yes"/>

<xsl:param name="currentPage"/>
<xsl:variable name="currentSiteRoot" select="$currentPage/ancestor-or-self::* [@isDoc][@level=1]" />

<xsl:variable name="urlPrefix">
<xsl:text>http://</xsl:text>
<xsl:value-of select="umbraco.library:RequestServerVariables('HTTP_HOST')" />
</xsl:variable>

<!-- Update these variables to modify the feed -->
<xsl:variable name="rssNoItems" select="string('10')"/>
<xsl:variable name="rssTitle" select="$currentSiteRoot/@nodeName"/>
<xsl:variable name="siteUrl" select="$urlPrefix"/>
<xsl:variable name="rssDescription" select="$currentSiteRoot/metadescription"/>

<!-- This gets all news and events and orders by updateDate to use for the pubDate in RSS feed -->
<xsl:variable name="pubDate">
<xsl:for-each select="$currentSiteRoot//* [@isDoc]">
<xsl:sort select="@createDate" data-type="text" order="descending" />
<xsl:if test="position() = 1">
<xsl:value-of select="umbraco.library:FormatDateTime(@createDate,'r')" />
</xsl:if>
</xsl:for-each>
</xsl:variable>

<xsl:template match="/">
<!-- change the mimetype for the current page to xml -->
<xsl:value-of select="umbraco.library:ChangeContentType('text/xml')"/>
<xsl:text disable-output-escaping="yes">&lt;?xml version="1.0" encoding="UTF-8"?&gt;</xsl:text>
<rss version="2.0" xmlns:atom="http://www.w3.org/2005/Atom">
<channel>
<title>
<xsl:value-of select="$rssTitle"/>
</title>
<link>
<xsl:value-of select="$siteUrl"/>
</link>
<pubDate>
<xsl:value-of select="$pubDate"/>
</pubDate>
<generator>umbraco</generator>
<description>
<xsl:value-of select="$rssDescription"/>
</description>
<language>en</language>

<atom:link rel="self" type="application/rss+xml">
<xsl:attribute name="href">
<xsl:value-of select="$urlPrefix" />
<xsl:text>/rss.aspx</xsl:text>
</xsl:attribute>
</atom:link>

<xsl:apply-templates select="$currentSiteRoot//* [@isDoc]">
<xsl:sort select="@createDate" order="descending" />
</xsl:apply-templates>

</channel>
</rss>

</xsl:template>

<xsl:template match="* [@isDoc]">
<xsl:if test="position() &lt;= $rssNoItems">
<item>
<title>
<xsl:value-of select="@nodeName"/>
</title>
<author>
<xsl:text>info.nospamplease@</xsl:text>
<xsl:value-of select="umbraco.library:RequestServerVariables('HTTP_HOST')" />
<xsl:text> (</xsl:text>
<xsl:value-of select="@creatorName"/>
<xsl:text>)</xsl:text>
</author>
<link>
<xsl:value-of select="umbraco.library:NiceUrl(@id)"/>
</link>
<pubDate>
<xsl:value-of select="umbraco.library:FormatDateTime(@createDate,'r')" />
</pubDate>
<guid>
<xsl:value-of select="umbraco.library:NiceUrl(@id)"/>
</guid>

<xsl:call-template name="content">
<xsl:with-param name="useText" select="concat('&lt;![CDATA[ ', umbraco.library:Replace(./bodyText, '/media/', concat($siteUrl, '/media/')),']]&gt;')"/>
</xsl:call-template>

</item>
</xsl:if>
</xsl:template>

<xsl:template name="content">
<xsl:param name="useText" />
<description>
<xsl:value-of select="$useText" disable-output-escaping="yes"/>
</description>
<content:encoded>
<xsl:value-of select="$useText" disable-output-escaping="yes"/>
</content:encoded>
</xsl:template>

</xsl:stylesheet>