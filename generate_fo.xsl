<?xml version="1.0" encoding="UTF-8"?>
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
        <fo:flow flow-name="xsl-region-body">
            <fo:block space-before.optimum="15pt" space-after.optimum="15pt" font-size="14pt">
                Drivers for ** for ** season
            </fo:block>
            <fo:table table-layout="fixed" width="100%">
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
                <fo:table-body border-width="1pt" border-style="solid">
                    <fo:table-row background-color="rgb(235,255,255)">
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
                                <fo:block font-size="8pt" text-align="center">Birthplace</fo:block>
                            </fo:table-cell>
                            <!-- C5-->
                            <fo:table-cell>
                                <fo:block font-size="8pt" text-align="center">Car Manufacturer</fo:block> <!-- Esto hay que ver el predeterminado de - para caundo no hay nada-->
                            </fo:table-cell>
                            <!-- C6-->
                            <fo:table-cell>
                                <fo:block font-size="8pt" text-align="center">Rank</fo:block> <!--Si este valor no esta no tiene que aparecer-->
                            </fo:table-cell>
                            <!-- C7-->
                            <fo:table-cell>
                                <fo:block font-size="8pt" text-align="center">Season Points</fo:block>
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
                                <fo:block font-size="8pt" text-align="center">Races not finished</fo:block>
                            </fo:table-cell>
                            <!-- C11-->
                            <fo:table-cell>
                                <fo:block font-size="8pt" text-align="center">Laps completed</fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                </fo:table-body>
            </fo:table>
        </fo:flow>
    </fo:page-sequence>
</fo:root>