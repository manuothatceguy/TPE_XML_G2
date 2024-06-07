<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:template match="/">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <fo:simple-page-master master-name="first" margin-right="1.5cm" margin-left="1.5cm" margin-bottom="2cm" margin-top="1cm" page-width="21cm" page-height="29.7cm">
                        <fo:region-body margin-top="1cm"/> <fo:region-before extent="1cm"/>
                        <fo:region-after extent="1.5cm"/>
                </fo:simple-page-master>
            </fo:layout-master-set>
            <fo:page-sequence master-reference="first">
                <fo:static-content flow-name="xsl-region-before">
                    <fo:block line-height="14pt" font-size="10pt" text-align="end">TPE 2024 1Q-Grupo 02</fo:block>
                </fo:static-content>
                <xsl:choose>
                    <xsl:when test="not(//error)">
                        <fo:flow flow-name="xsl-region-body">
                            <fo:block space-before.optimum="15pt" space-after.optimum="15pt" font-size="14pt">
                                <fo:inline>Drivers for </fo:inline>
                                <fo:inline> <xsl:value-of select="/nascar_data/serie_type"/></fo:inline>
                                <fo:inline> for </fo:inline>
                                <fo:inline> <xsl:value-of select="/nascar_data/year"/></fo:inline>
                            </fo:block>
                        <fo:table table-layout="fixed" width="102%">
                            <fo:table-column column-number="1" column-width="14%"/>
                            <fo:table-column column-number="2" column-width="10%"/>
                            <fo:table-column column-number="3" column-width="10%"/>
                            <fo:table-column column-number="4" column-width="14%"/>
                            <fo:table-column column-number="5" column-width="9%"/>
                            <fo:table-column column-number="6" column-width="8%"/> 
                            <fo:table-column column-number="7" column-width="7%"/>
                            <fo:table-column column-number="8" column-width="7%"/>
                            <fo:table-column column-number="9" column-width="7%"/>
                            <fo:table-column column-number="10" column-width="8%"/>
                            <fo:table-column column-number="11" column-width="8%"/>

                            <fo:table-header border-width="1pt" border-style="solid">
                                <fo:table-row background-color="rgb(215,245,250)">
                                        <!-- C1-->
                                        <fo:table-cell>
                                            <fo:block font-size="8pt" text-align="center">Name</fo:block>
                                        </fo:table-cell>
                                        <!-- C2-->
                                        <fo:table-cell>
                                            <fo:block font-size="8pt" text-align="center">Country</fo:block>
                                        </fo:table-cell>
                                        <!-- C3-->
                                        <fo:table-cell>
                                            <fo:block font-size="8pt" text-align="center">Birth Date</fo:block>
                                        </fo:table-cell>
                                        <!-- C4-->
                                        <fo:table-cell>
                                            <fo:block font-size="8pt" text-align="center">Birth place</fo:block>
                                        </fo:table-cell>
                                        <!-- C5-->
                                        <fo:table-cell>
                                            <fo:block font-size="8pt" text-align="center">Car manufacturer</fo:block> <!-- Esto hay que ver el predeterminado de - para caundo no hay nada-->
                                        </fo:table-cell>
                                        <!-- C6-->
                                        <fo:table-cell>
                                            <fo:block font-size="8pt" text-align="center">Rank</fo:block> <!--Si este valor no esta no tiene que aparecer-->
                                        </fo:table-cell>
                                        <!-- C7-->
                                        <fo:table-cell>
                                            <fo:block font-size="8pt" text-align="center">Season points</fo:block>
                                        </fo:table-cell>
                                        <!-- C8-->
                                        <fo:table-cell>
                                            <fo:block font-size="8pt" text-align="center">Wins</fo:block>
                                        </fo:table-cell>
                                        <!-- C9-->
                                        <fo:table-cell>
                                            <fo:block font-size="8pt" text-align="center">Poles</fo:block>
                                        </fo:table-cell>
                                        <!-- C10-->
                                        <fo:table-cell>
                                            <fo:block font-size="8pt" text-align="center">Unfinished races</fo:block>
                                        </fo:table-cell>
                                        <!-- C11-->
                                        <fo:table-cell>
                                            <fo:block font-size="8pt" text-align="center">Completed laps</fo:block>
                                        </fo:table-cell>
                                </fo:table-row>
                            </fo:table-header>
                            <fo:table-body end-indent="0in" hyphenate="true" hyphenation-character="-"> 
                                <xsl:for-each select="/nascar_data/drivers/driver">
                                            <fo:table-row> 
                                                <fo:table-cell>
                                                    <fo:block font-size="8pt" text-align="center">
                                                        <xsl:value-of select="full_name"/>
                                                    </fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell>
                                                    <fo:block font-size="8pt" text-align="center">
                                                        <xsl:value-of select="country"/>
                                                    </fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell>
                                                    <fo:block font-size="8pt" text-align="center">
                                                        <xsl:value-of select="birth_date"/>
                                                    </fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell>
                                                    <fo:block font-size="8pt" text-align="center">
                                                        <xsl:value-of select="birth_place"/>
                                                    </fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell>
                                                    <fo:block font-size="8pt" text-align="center">
                                                        <xsl:choose>
                                                            <xsl:when test="car != ''">
                                                                <fo:block>
                                                                    <xsl:value-of select="car"/> 
                                                                </fo:block>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <fo:block>
                                                                        <fo:inline>-</fo:inline>
                                                                </fo:block>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell>
                                                    <fo:block font-size="8pt" text-align="center">
                                                        <xsl:choose>
                                                            <xsl:when test="rank/text() &lt;= 3">
                                                                <fo:block color="green">
                                                                    <xsl:value-of select="rank"/> 
                                                                </fo:block>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <fo:block>
                                                                    <xsl:value-of select="rank"/>
                                                                </fo:block>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell>
                                                    <fo:block font-size="8pt" text-align="center">
                                                        <xsl:value-of select="statistics/season_points"/>
                                                    </fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell>
                                                    <fo:block font-size="8pt" text-align="center">
                                                        <xsl:value-of select="statistics/wins"/>
                                                    </fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell>
                                                    <fo:block font-size="8pt" text-align="center">
                                                        <xsl:value-of select="statistics/poles"/>
                                                    </fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell>
                                                    <fo:block font-size="8pt" text-align="center">
                                                        <xsl:value-of select="statistics/races_not_finished"/>
                                                    </fo:block>
                                                </fo:table-cell>
                                                <fo:table-cell>
                                                    <fo:block font-size="8pt" text-align="center">
                                                        <xsl:value-of select="statistics/laps_completed"/>
                                                    </fo:block>
                                                </fo:table-cell>
                                            </fo:table-row>
                                </xsl:for-each>

                            </fo:table-body> 
                        </fo:table>
                        </fo:flow>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:flow flow-name="xsl-region-body">
                            <xsl:for-each select="/nascar_data/error">    
                                <fo:block space-before.optimum="15pt" space-after.optimum="15pt" font-size="14pt">
                                    
                                        <fo:inline><xsl:text>Error: </xsl:text> <xsl:value-of select="."/> </fo:inline>
                                    
                                </fo:block>
                            </xsl:for-each>
                        </fo:flow>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:page-sequence>
        </fo:root>
</xsl:template>
</xsl:stylesheet>