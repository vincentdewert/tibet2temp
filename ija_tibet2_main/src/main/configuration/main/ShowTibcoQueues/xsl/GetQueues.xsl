<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	<xsl:template match="qInfos">
		<queues>
			<xsl:choose>
				<xsl:when test="string-length(@resolvedUrl)&gt;0">
					<xsl:attribute name="url" select="@resolvedUrl" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="url" select="@url" />
				</xsl:otherwise>
			</xsl:choose>
			<xsl:attribute name="age" select="@age" />
			<xsl:apply-templates select="qInfo" />
		</queues>
	</xsl:template>
	<xsl:template match="qInfo">
		<queue>
			<name>
				<xsl:value-of select="qName" />
			</name>
			<acl>
				<xsl:value-of select="acl" />
			</acl>
			<xsl:if test="isBridged='true'">
				<bridgeTargets>
					<xsl:value-of select="bridgeTargets" />
				</bridgeTargets>
			</xsl:if>
			<msgCount>
				<xsl:value-of select="concat(inTotalMsgs,'/',outTotalMsgs,'/',pendingMsgCount)" />
			</msgCount>
		</queue>
	</xsl:template>
</xsl:stylesheet>
