<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	<xsl:param name="method" />
	<xsl:param name="uri" />
	<xsl:param name="esbInfo" />
	<xsl:variable name="uriXml">
		<uri>
			<xsl:for-each select="tokenize($uri,'/')">
				<token>
					<xsl:sequence select="normalize-space(.)" />
				</token>
			</xsl:for-each>
		</uri>
	</xsl:variable>
	<xsl:template match="/">
		<xsl:variable name="t3" select="$uriXml/uri/token[3]" />
		<xsl:variable name="t4" select="$uriXml/uri/token[4]" />
		<xsl:variable name="t5" select="$uriXml/uri/token[5]" />
		<xsl:variable name="t6" select="$uriXml/uri/token[6]" />
		<xsl:variable name="queueName">
			<xsl:choose>
				<xsl:when test="string-length($t4)&gt;0">
					<xsl:value-of select="$t4" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="root/queueName" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="principal">
			<xsl:choose>
				<xsl:when test="string-length($t6)&gt;0">
					<xsl:value-of select="$t6" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="root/principal" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<root>
			<serverAlias>
				<xsl:value-of select="$t3" />
			</serverAlias>
			<action>
				<xsl:choose>
					<xsl:when test="$method='GET'">
						<xsl:choose>
							<xsl:when test="string-length($principal)&gt;0">
								<xsl:text>readQueueAuthorization</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>readQueue</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$method='POST'">
						<xsl:choose>
							<xsl:when test="string-length($principal)&gt;0">
								<xsl:text>createQueueAuthorization</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>createQueue</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$method='PUT'">
						<xsl:choose>
							<xsl:when test="string-length($principal)&gt;0">
								<xsl:text>updateQueueAuthorization</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>updateQueue</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$method='DELETE'">
						<xsl:choose>
							<xsl:when test="string-length($principal)&gt;0">
								<xsl:text>deleteQueueAuthorization</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>deleteQueue</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
			</action>
			<url>
				<xsl:value-of select="$esbInfo/esbInfo/provUrl" />
			</url>
			<authAlias>
				<xsl:value-of select="$esbInfo/esbInfo/authAlias" />
			</authAlias>
			<queueName>
				<xsl:value-of select="$queueName" />
			</queueName>
			<principal>
				<xsl:value-of select="$principal" />
			</principal>
			<permissions>
				<xsl:value-of select="root/permissions" />
			</permissions>
		</root>
	</xsl:template>
</xsl:stylesheet>
