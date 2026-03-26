<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:param name="base_url">https://arthur-schnitzler.github.io/schnitzler-fischer-static/</xsl:param>
    <xsl:template name="blockquote">
        <xsl:param name="pageId" select="''"></xsl:param>
        <xsl:param name="customUrl" select="$base_url"></xsl:param>
        <xsl:variable name="fullUrl" select="concat($customUrl, $pageId)"/>
        <div>
            <h2 class="fs-4">Zitatvorlage</h2>
            <blockquote class="blockquote">
                <p>
                    Arthur Schnitzler-Archiv Freiburg (Hg.): Arthur Schnitzler und der S. Fischer Verlag. 
                    Briefdatenbank 1888–1931. https://biblio.ub.uni-freiburg.de/sf/ (Datum des Zugriffs) (<a href="{$fullUrl}"><xsl:value-of select="$fullUrl"/></a>)
                </p>
            </blockquote>
        </div>
    </xsl:template>
</xsl:stylesheet>