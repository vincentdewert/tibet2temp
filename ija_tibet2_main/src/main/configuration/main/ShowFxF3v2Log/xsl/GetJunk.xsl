<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	<xsl:param name="transfers" />
	<xsl:variable name="logIds">
		<xsl:for-each select="$transfers//logId">
			<logId>
				<xsl:value-of select="." />
			</logId>
		</xsl:for-each>
	</xsl:variable>
	<xsl:template match="/">
		<records>
			<xsl:for-each select="result/rowset/row">
				<xsl:variable name="id" select="field[@name='LOGID']" />
				<xsl:if test="count($logIds[logId=$id])=0">
					<xsl:variable name="function"
						select="field[@name='APPLICATIONFUNCTION']" />
					<record>
						<xsl:if test="field[@name='TYPE']='E'">
							<xsl:attribute name="exception">true</xsl:attribute>
						</xsl:if>
						<logId>
							<xsl:value-of select="field[@name='LOGID']" />
						</logId>
						<xsl:choose>
							<xsl:when test="$function='StartTransferSubmitted'">
								<startTransferSubmitted>
									<xsl:value-of select="field[@name='LOG_TS']" />
								</startTransferSubmitted>
								<submittedStatusMsg>
									<xsl:value-of
										select="field[@name='MESSAGE']/ActivityOutput/OtherProperties/Message" />
								</submittedStatusMsg>
							</xsl:when>
							<xsl:when test="$function='StartTransferExecuted'">
								<startTransferExecuted>
									<xsl:value-of select="field[@name='LOG_TS']" />
								</startTransferExecuted>
								<executedStatusMsg>
									<xsl:value-of
										select="field[@name='MESSAGE']/ActivityOutput/Body/Body/AuditRecord/TransferStatusMsg" />
								</executedStatusMsg>
							</xsl:when>
							<xsl:when test="$function='Notify'">
								<notify>
									<xsl:value-of select="field[@name='LOG_TS']" />
								</notify>
								<fileNameOut>
									<xsl:value-of
										select="field[@name='MESSAGE']/ActivityOutput/Body/AuditResponse/AuditRecord/ResponderFileName" />
								</fileNameOut>
								<senderId>
									<xsl:value-of select="field[@name='SENDERID']" />
								</senderId>
							</xsl:when>
							<xsl:otherwise>
								<startTransfer>
									<xsl:value-of select="field[@name='LOG_TS']" />
								</startTransfer>
							</xsl:otherwise>
						</xsl:choose>
					</record>
				</xsl:if>
			</xsl:for-each>
		</records>
	</xsl:template>
</xsl:stylesheet>
