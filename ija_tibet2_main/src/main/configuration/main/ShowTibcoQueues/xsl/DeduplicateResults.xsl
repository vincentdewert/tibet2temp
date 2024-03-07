<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:template match="results">
		<results>
			<xsl:apply-templates select="result"/>
		</results>
	</xsl:template>
	<xsl:template match="result">
		<result>
			<xsl:choose>
				<xsl:when test="count(queues)=0">
					<xsl:attribute name="status">error</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="item">
						<xsl:value-of select="@item"/>
					</xsl:variable>
					<xsl:variable name="url">
						<xsl:value-of select="queues/@url"/>
					</xsl:variable>
					<xsl:variable name="firstItem">
						<xsl:value-of select="(../../results/result[queues/@url=$url]/@item)[1]"/>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$firstItem=$item">
							<xsl:attribute name="status">ok</xsl:attribute>
							<xsl:copy-of select="*"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="status">duplicate</xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</result>
	</xsl:template>
</xsl:stylesheet>
