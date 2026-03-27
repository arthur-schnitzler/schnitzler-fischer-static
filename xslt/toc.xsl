<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes"
        omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:import href="./partials/tabulator_js.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Alle Briefe'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" style="hyphens: auto;" lang="de" xml:lang="de">
            <xsl:call-template name="html_head">
                <xsl:with-param name="html_title" select="$doc_title"/>
            </xsl:call-template>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container-fluid">
                        <div class="card">
                            <div class="card-header">
                                <h1>Alle Briefe</h1>
                            </div>
                            <div class="card-body" style="overflow-x: auto;">
                                <div style="display: flex; justify-content: center;">
                                    <table class="table table-sm display" id="tabulator-table"
                                        style="width: auto; min-width: 100%;">
                                        <thead>
                                            <tr>
                                                <th scope="col" tabulator-headerFilter="input"
                                                  tabulator-formatter="html">Titel</th>
                                                <th scope="col" tabulator-headerFilter="input"
                                                  tabulator-formatter="html">Datum (ISO)</th>
                                                <th scope="col" tabulator-headerFilter="input"
                                                  tabulator-formatter="html">ID</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <xsl:variable name="collection"
                                                select="collection('../data/editions/?select=*.xml')"/>
                                            <xsl:for-each select="$collection/tei:TEI">
                                                <xsl:variable name="current-node" select="."/>
                                                <xsl:variable name="full_path">
                                                  <xsl:value-of select="document-uri(/)"/>
                                                </xsl:variable>
                                                <xsl:variable name="korrespondenzparter" as="node()">
                                                  <xsl:element name="list">
                                                  <xsl:for-each
                                                  select="child::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspContext[1]/tei:ref[@type = 'belongsToCorrespondence']/@target">
                                                  <xsl:element name="item">
                                                  <xsl:value-of
                                                  select="replace(., 'correspondence_', '#pmb')"/>
                                                  </xsl:element>
                                                  </xsl:for-each>
                                                  </xsl:element>
                                                </xsl:variable>
                                                <xsl:variable name="schnitzler-als-empfaenger"
                                                  as="xs:string">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="child::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[@type = 'sent'][1]/tei:persName[@ref = '#pmb2121']">
                                                  <!-- Schnitzler ist Sender - prüfe ob Empfänger ein Korrespondenzpartner ist -->
                                                  <xsl:choose>
                                                  <xsl:when test="
                                                                        some $partner in $korrespondenzparter/*:item
                                                                            satisfies $current-node/child::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[@type = 'received'][1]/tei:persName[@ref = $partner]">
                                                  <xsl:text>as-sender</xsl:text>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>as-sender-umfeld</xsl:text>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="child::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[@type = 'received'][1]/tei:persName[@ref = '#pmb2121']">
                                                  <!-- Schnitzler ist Empfänger - prüfe ob Sender ein Korrespondenzpartner ist -->
                                                  <xsl:choose>
                                                  <xsl:when test="
                                                                        some $partner in $korrespondenzparter/*:item
                                                                            satisfies $current-node/child::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction[@type = 'sent'][1]/tei:persName[@ref = $partner]">
                                                  <xsl:text>as-empf</xsl:text>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>as-empf-umfeld</xsl:text>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>umfeld</xsl:text>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                </xsl:variable>
                                                <tr>
                                                  <td>
                                                  <sortdate hidden="true">
                                                  <xsl:value-of
                                                  select="descendant::tei:titleStmt/tei:title[@type = 'iso-date']/text()"/>
                                                  <xsl:text>;</xsl:text>
                                                  </sortdate>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:value-of
                                                  select="replace(tokenize($full_path, '/')[last()], '.xml', '.html')"
                                                  />
                                                  </xsl:attribute>
                                                  <xsl:attribute name="class">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="$schnitzler-als-empfaenger = 'as-empf'">
                                                  <xsl:text>sender-color</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="$schnitzler-als-empfaenger = 'as-empf-umfeld'">
                                                  <xsl:text>umfeld-color</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="$schnitzler-als-empfaenger = 'as-sender'">
                                                  <xsl:text>theme-color</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="$schnitzler-als-empfaenger = 'as-sender-umfeld'">
                                                  <xsl:text>umfeld-color</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="starts-with($schnitzler-als-empfaenger, 'umfeld')">
                                                  <xsl:text>umfeld-color</xsl:text>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>theme-color</xsl:text>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="descendant::tei:titleStmt/tei:title[@level = 'a'][1]/text()"
                                                  />
                                                  </a>
                                                  </td>
                                                  <td>
                                                  <span>
                                                  <xsl:attribute name="class">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="$schnitzler-als-empfaenger = 'as-empf'">
                                                  <xsl:text>sender-color</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="$schnitzler-als-empfaenger = 'as-empf-umfeld'">
                                                  <xsl:text>umfeld-color</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="$schnitzler-als-empfaenger = 'as-sender'">
                                                  <xsl:text>theme-color</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="$schnitzler-als-empfaenger = 'as-sender-umfeld'">
                                                  <xsl:text>umfeld-color</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="$schnitzler-als-empfaenger = 'umfeld'">
                                                  <xsl:text>umfeld-color</xsl:text>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>theme-color</xsl:text>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:attribute>
                                                  <xsl:value-of
                                                  select="descendant::tei:titleStmt/tei:title[@type = 'iso-date']/text()"
                                                  />
                                                  </span>
                                                  </td>
                                                  <td>
                                                  <span>
                                                  <xsl:attribute name="class">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="$schnitzler-als-empfaenger = 'as-empf'">
                                                  <xsl:text>sender-color</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="$schnitzler-als-empfaenger = 'as-empf-umfeld'">
                                                  <xsl:text>umfeld-color</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="$schnitzler-als-empfaenger = 'as-sender'">
                                                  <xsl:text>theme-color</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="$schnitzler-als-empfaenger = 'as-sender-umfeld'">
                                                  <xsl:text>umfeld-color</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="$schnitzler-als-empfaenger = 'umfeld'">
                                                  <xsl:text>umfeld-color</xsl:text>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>theme-color</xsl:text>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="replace(@xml:id, 'sf_', '')"/>
                                                  </span>
                                                  </td>
                                                </tr>
                                            </xsl:for-each>
                                        </tbody>
                                    </table>
                                </div>
                                <xsl:call-template name="tabulator_dl_buttons"/>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                    <xsl:call-template name="tabulator_js"/>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:div//tei:head">
        <h2 id="{generate-id()}">
            <xsl:apply-templates/>
        </h2>
    </xsl:template>
    <xsl:template match="tei:p">
        <p id="{generate-id()}">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:list">
        <ul id="{generate-id()}">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:item">
        <li id="{generate-id()}">
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="starts-with(data(@target), 'http')">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
