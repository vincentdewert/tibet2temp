<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fnu="org.apache.commons.io.FilenameUtils"
	exclude-result-prefixes="xalan fnu">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	<xsl:key name="rowConv" match="//result/rowset/row"
		use="concat(field[@name='APPLICATIONFUNCTION'],'_',field[@name='CONVERSATIONID'])" />
	<xsl:template match="/">
		<xsl:variable name="notify">
			<records>
				<xsl:for-each
					select="result/rowset/row[field[@name='APPLICATIONFUNCTION']='Notify' and (field[@name='CPAID']=//result/rowset/row[field[@name='APPLICATIONFUNCTION']='StartTransferExecuted']/field[@name='CPAID'])=false()]">
					<record>
						<logId>
							<xsl:value-of select="field[@name='LOGID']" />
						</logId>
						<cpaId>
							<xsl:value-of select="field[@name='CPAID']" />
						</cpaId>
						<xsl:variable name="itx">
							<xsl:value-of
								select="field[@name='MESSAGE']/ActivityOutput/Body/AuditResponse/AuditRecord/InitiatorTransactionID" />
						</xsl:variable>
						<xsl:variable name="rtx">
							<xsl:value-of
								select="field[@name='MESSAGE']/ActivityOutput/Body/AuditResponse/AuditRecord/ResponderTransactionID" />
						</xsl:variable>
						<xsl:if test="string-length($itx)&gt;0 and string-length($rtx)&gt;0">
							<cpaId2>
								<xsl:call-template name="replace-string">
									<xsl:with-param name="text" select="field[@name='CPAID']" />
									<xsl:with-param name="replace" select="$rtx" />
									<xsl:with-param name="with" select="$itx" />
								</xsl:call-template>
							</cpaId2>
						</xsl:if>
						<logTs>
							<xsl:value-of select="field[@name='LOG_TS']" />
						</logTs>
						<xsl:variable name="fileName">
							<xsl:value-of
								select="field[@name='MESSAGE']/ActivityOutput/Body/AuditResponse/AuditRecord/InitiatorFileName" />
						</xsl:variable>
						<fileName>
							<xsl:value-of select="$fileName" />
						</fileName>
						<fileNameNormalized>
							<xsl:value-of select="fnu:normalize($fileName)" />
						</fileNameNormalized>
						<senderId>
							<xsl:value-of select="field[@name='SENDERID']" />
						</senderId>
					</record>
				</xsl:for-each>
			</records>
		</xsl:variable>
		<xsl:variable name="notifyBuild" select="xalan:nodeset($notify)" />
		<records>
			<notify>
				<xsl:copy-of select="$notifyBuild" />
			</notify>
			<xsl:for-each
				select="result/rowset/row[field[@name='APPLICATIONFUNCTION']='StartTransferExecuted']">
				<record>
					<logId>
						<xsl:value-of select="field[@name='LOGID']" />
					</logId>
					<xsl:variable name="cpaId" select="field[@name='CPAID']" />
					<cpaId>
						<xsl:value-of select="$cpaId" />
					</cpaId>
					<xsl:variable name="conversationId" select="field[@name='CONVERSATIONID']" />
					<xsl:variable name="logTs_submit">
						<xsl:value-of
							select="key('rowConv',concat('StartTransferSubmitted_',$conversationId))/field[@name='LOG_TS']" />
					</xsl:variable>
					<xsl:variable name="logTs1">
						<xsl:value-of select="translate($logTs_submit,' -:','')" />
					</xsl:variable>
					<logTs>
						<xsl:value-of select="field[@name='LOG_TS']" />
					</logTs>
					<xsl:variable name="fileName">
						<xsl:value-of
							select="field[@name='MESSAGE']/ActivityOutput/Body/Body/AuditRecord/InitiatorFileName" />
					</xsl:variable>
					<fileName>
						<xsl:value-of select="$fileName" />
					</fileName>
					<xsl:variable name="fileNameNormalized" select="fnu:normalize($fileName)" />
					<fileNameNormalized>
						<xsl:value-of select="$fileNameNormalized" />
					</fileNameNormalized>
					<notify>
						<xsl:for-each select="$notifyBuild/records/record[cpaId2=$cpaId]">
							<logId foundOn="CPAID">
								<xsl:value-of select="logId" />
							</logId>
						</xsl:for-each>
						<xsl:for-each select="$notifyBuild/records/record">
							<xsl:variable name="logTs2">
								<xsl:value-of select="translate(logTs,' -:','')" />
							</xsl:variable>
							<xsl:if
								test="$logTs1&lt;$logTs2 and fnu:wildcardMatch(fileNameNormalized, $fileNameNormalized)">
								<logId foundOn="FILENAME">
									<xsl:value-of select="logId" />
								</logId>
							</xsl:if>
						</xsl:for-each>
					</notify>
				</record>
			</xsl:for-each>
		</records>
	</xsl:template>
	<xsl:template name="replace-string">
		<xsl:param name="text" />
		<xsl:param name="replace" />
		<xsl:param name="with" />
		<xsl:choose>
			<xsl:when test="contains($text,$replace)">
				<xsl:value-of select="substring-before($text,$replace)" />
				<xsl:value-of select="$with" />
				<xsl:call-template name="replace-string">
					<xsl:with-param name="text"
						select="substring-after($text,$replace)" />
					<xsl:with-param name="replace" select="$replace" />
					<xsl:with-param name="with" select="$with" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
