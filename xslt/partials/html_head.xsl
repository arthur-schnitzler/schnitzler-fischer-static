<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:param name="project_short_title">Schnitzler – S. Fischer</xsl:param>
    <xsl:param name="project_title">Arthur Schnitzler und der S. Fischer Verlag</xsl:param>
    <xsl:param name="base_url">https://arthur-schnitzler.github.io/schnitzler-fischer-static/</xsl:param>
    <xsl:param name="project_logo">images/logo.png</xsl:param>
    <xsl:template name="html_head">
        <xsl:param name="html_title" select="$project_short_title"></xsl:param>
        <xsl:param name="html_description" select="''"/>
        <xsl:param name="html_url" select="''"/>
        <xsl:param name="html_image" select="concat($base_url, '/img/og-image.jpg')"/>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="{$project_logo}" sizes="any" />
        <title><xsl:value-of select="$html_title"/></title>

        <!-- <link rel="canonical" href="{$base_url}" /> -->
        <meta name="description" content="{$project_title}" />
        
        <meta property="og:type" content="website" />
        <meta property="og:title" content="{$project_short_title}" />
        <meta property="og:description" content="{$project_title}" />
        <!-- <meta property="og:url" content="{$base_url}" /> -->
        <meta property="og:site_name" content="{$project_short_title}" />
	    <meta property="og:image" content="{$project_logo}" />

        <link href="vendor/bootstrap-5.3.5-dist/css/bootstrap.min.css" rel="stylesheet"/>
        <link rel="stylesheet" href="vendor/bootstrap-icons/font/bootstrap-icons.min.css" />
        <link rel="stylesheet" href="css/style.css" type="text/css"></link>
        
        
    </xsl:template>
</xsl:stylesheet>