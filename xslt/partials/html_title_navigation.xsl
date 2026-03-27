<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mam="whatever" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xsl tei xs" version="3.0">
    <!-- The template "add_header-navigation-custom-title" creates a custom header without
                using tei:title but includes prev and next urls. -->
    <xsl:template name="header-nav">
        <xsl:variable name="doc_title">
            <xsl:value-of select="descendant::tei:titleSmt/tei:title[@level = 'a'][1]/text()"/>
        </xsl:variable>
        <xsl:variable name="correspContext" as="node()?"
            select="descendant::tei:correspDesc[1]/tei:correspContext"/>
        <div class="container" id="title-nav">
            <!-- Zeile 1: Überschrift zentriert -->
            <div class="row">
                <div class="col-12 text-center">
                    <h1 itemprop="headline name">
                        <xsl:value-of select="//tei:fileDesc/tei:titleStmt/tei:title[@level = 'a']"
                        />
                    </h1>
                </div>
            </div>
            <!-- Zeile 2: Pfeile links / rechts -->
            <div class="d-flex justify-content-between">
                <div>
                    <xsl:if test="$correspContext/tei:ref[@subtype = 'previous_letter']">
                        <xsl:call-template name="mam:nav-li-item">
                            <xsl:with-param name="eintrag"
                                select="$correspContext/tei:ref[@subtype = 'previous_letter'][1]"/>
                            <xsl:with-param name="direction" select="'prev-doc'"/>
                        </xsl:call-template>
                    </xsl:if>
                </div>
                <div>
                    <xsl:if test="$correspContext/tei:ref[@subtype = 'next_letter']">
                        <xsl:call-template name="mam:nav-li-item">
                            <xsl:with-param name="eintrag"
                                select="$correspContext/tei:ref[@subtype = 'next_letter'][1]"/>
                            <xsl:with-param name="direction" select="'next-doc'"/>
                        </xsl:call-template>
                    </xsl:if>
                </div>
            </div>
        </div>
    </xsl:template>
    <xsl:template name="mam:nav-li-item">
        <xsl:param name="eintrag" as="node()"/>
        <xsl:param name="direction"/>
        <xsl:element name="a">
            <xsl:attribute name="id">
                <xsl:value-of select="$direction"/>
            </xsl:attribute>
            <xsl:attribute name="class">
                <xsl:text>dropdown-item theme-color</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:value-of select="replace(concat($eintrag/@target, '.html'), '//', '/')"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="contains($eintrag/@subtype, 'previous')">
                    <span>‹</span>
                    <xsl:text>&#160;</xsl:text>
                </xsl:when>
            </xsl:choose>
            <xsl:value-of select="$eintrag"/>
            <xsl:choose>
                <xsl:when test="contains($eintrag/@subtype, 'next')">
                    <xsl:text>&#160;</xsl:text>
                    <span>›</span>
                </xsl:when>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
