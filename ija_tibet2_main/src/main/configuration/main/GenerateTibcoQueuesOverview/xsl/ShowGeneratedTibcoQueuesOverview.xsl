<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="srcPrefix" />
	<xsl:param name="outputFileInfo" />
	<xsl:template match="/">
		<page title="Show Generated Tibco Queues Overview">
			<xsl:choose>
				<xsl:when test="name(*)='ok'">
					<table>
						<caption class="caption">Files</caption>
						<tr>
							<th class="colHeader">Name</th>
							<th class="colHeader">Size</th>
							<th class="colHeader">Date</th>
							<th class="colHeader">Time</th>
							<th class="colHeader">as</th>
						</tr>
						<xsl:for-each select="$outputFileInfo/file">
							<xsl:variable name="class">
								<xsl:choose>
									<xsl:when test="position() mod 2 = 0">rowEven</xsl:when>
									<xsl:otherwise>filterRow</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<tr>
								<xsl:attribute name="class">
									<xsl:value-of select="$class"/>
								</xsl:attribute>
								<td class="filterRow">
									<xsl:value-of select="name"/>
								</td>
								<td class="filterRow">
									<xsl:value-of select="fSize"/>
								</td>
								<td class="filterRow">
									<xsl:value-of select="modificationDate"/>
								</td>
								<td class="filterRow">
									<xsl:value-of select="modificationTime"/>
								</td>
								<td class="filterRow">
									<xsl:call-template name="createHyperlink">
										<xsl:with-param name="resultType">bin</xsl:with-param>
									</xsl:call-template>
								</td>
							</tr>
						</xsl:for-each>
					</table>
				</xsl:when>
				<xsl:otherwise>
					<font color="red">
						<xsl:value-of select="*" />
					</font>
				</xsl:otherwise>
			</xsl:choose>
		</page>
	</xsl:template>
	<xsl:template name="createHyperlink">
		<xsl:param name="resultType"/>
		<a>
			<xsl:attribute name="href"><xsl:value-of
				select="concat($srcPrefix,'FileViewerServlet?resultType=',$resultType,'&amp;fileName=',fullName)" /></xsl:attribute>
			<xsl:value-of select="$resultType" />
		</a>
	</xsl:template>
</xsl:stylesheet>
