<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	<xsl:param name="fixedExecutes" />
	<xsl:key name="rowConv" match="//result/rowset/row"
		use="concat(field[@name='APPLICATIONFUNCTION'],'_',field[@name='CONVERSATIONID'])" />
	<xsl:key name="rowCpa" match="//result/rowset/row"
		use="concat(field[@name='APPLICATIONFUNCTION'],'_',field[@name='CPAID'])" />
	<xsl:template match="/">
		<records>
			<xsl:for-each
				select="result/rowset/row[field[@name='APPLICATIONFUNCTION']='StartTransfer']">
				<record>
					<xsl:variable name="conversationId" select="field[@name='CONVERSATIONID']" />
					<startTransfer>
						<xsl:call-template name="checkException" />
						<xsl:call-template name="logId" />
						<xsl:call-template name="logTimestamp" />
						<xsl:call-template name="conversationId" />
						<xsl:call-template name="cpaId" />
						<xsl:apply-templates
							select="field[@name='MESSAGE']/Envelope/Body/StartTransfer_Action/TransferDetails" />
					</startTransfer>
					<startTransferSubmitted>
						<xsl:apply-templates
							select="key('rowConv',concat('StartTransferSubmitted_',$conversationId))"
							mode="startTransferSubmitted" />
					</startTransferSubmitted>
					<startTransferExecuted>
						<xsl:apply-templates
							select="key('rowConv',concat('StartTransferExecuted_',$conversationId))"
							mode="startTransferExecuted" />
					</startTransferExecuted>
					<xsl:variable name="cpaId"
						select="key('rowConv',concat('StartTransferExecuted_',$conversationId))/field[@name='CPAID']" />
					<notify>
						<xsl:apply-templates select="key('rowCpa',concat('Notify_',$cpaId))"
							mode="notify" />
						<xsl:call-template name="fixedExecutes">
							<xsl:with-param name="logId"
								select="key('rowConv',concat('StartTransferExecuted_',$conversationId))/field[@name='LOGID']" />
						</xsl:call-template>
					</notify>
				</record>
			</xsl:for-each>
		</records>
	</xsl:template>
	<xsl:template match="TransferDetails">
		<flowId>
			<xsl:value-of select="TransferFlowId" />
		</flowId>
		<sender>
			<xsl:value-of select="SenderApplication" />
		</sender>
		<fileNameIn>
			<xsl:value-of select="Filename" />
		</fileNameIn>
	</xsl:template>
	<xsl:template match="row" mode="startTransferSubmitted">
		<xsl:call-template name="checkException" />
		<xsl:call-template name="logId" />
		<xsl:call-template name="logTimestamp" />
		<xsl:call-template name="conversationId" />
		<xsl:call-template name="cpaId" />
		<statusMsg>
			<xsl:value-of
				select="field[@name='MESSAGE']/ActivityOutput/OtherProperties/Message" />
		</statusMsg>
	</xsl:template>
	<xsl:template match="row" mode="startTransferExecuted">
		<xsl:call-template name="checkException" />
		<xsl:call-template name="logId" />
		<xsl:call-template name="logTimestamp" />
		<xsl:call-template name="conversationId" />
		<xsl:call-template name="cpaId" />
		<statusMsg>
			<xsl:value-of
				select="field[@name='MESSAGE']/ActivityOutput/Body/Body/AuditRecord/TransferStatusMsg" />
		</statusMsg>
	</xsl:template>
	<xsl:template match="row" mode="notify">
		<item>
			<xsl:call-template name="checkException" />
			<xsl:call-template name="logId" />
			<xsl:call-template name="logTimestamp" />
			<xsl:call-template name="conversationId" />
			<xsl:call-template name="cpaId" />
			<fileNameOut>
				<xsl:value-of
					select="field[@name='MESSAGE']/ActivityOutput/Body/AuditResponse/AuditRecord/ResponderFileName" />
			</fileNameOut>
			<senderId>
				<xsl:value-of select="field[@name='SENDERID']" />
			</senderId>
		</item>
	</xsl:template>
	<xsl:template name="logId">
		<logId>
			<xsl:value-of select="field[@name='LOGID']" />
		</logId>
	</xsl:template>
	<xsl:template name="logTimestamp">
		<logTs>
			<xsl:value-of select="field[@name='LOG_TS']" />
		</logTs>
	</xsl:template>
	<xsl:template name="conversationId">
		<conversationId>
			<xsl:value-of select="field[@name='CONVERSATIONID']" />
		</conversationId>
	</xsl:template>
	<xsl:template name="cpaId">
		<cpaId>
			<xsl:value-of select="field[@name='CPAID']" />
		</cpaId>
	</xsl:template>
	<xsl:template name="checkException">
		<xsl:if test="field[@name='TYPE']='E'">
			<xsl:attribute name="exception">true</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template name="fixedExecutes">
		<xsl:param name="logId" />
		<xsl:for-each
			select="$fixedExecutes/records/record[logId=$logId]/notify/logId[@foundOn='CPAID']">
			<xsl:call-template name="fixedExecutes_item">
				<xsl:with-param name="logId" select="." />
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each
			select="$fixedExecutes/records/record[logId=$logId]/notify/logId[@foundOn='FILENAME']">
			<xsl:variable name="id" select="." />
			<xsl:if
				test="count($fixedExecutes/records/record/notify/logId[@foundOn='CPAID' and .=$id])=0 and $fixedExecutes/records/record[notify/logId=$id][1]/logId=$logId">
				<xsl:call-template name="fixedExecutes_item">
					<xsl:with-param name="logId" select="$id" />
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="fixedExecutes_item">
		<xsl:param name="logId" />
		<item fixed="true">
			<logId>
				<xsl:value-of select="$logId" />
			</logId>
			<xsl:for-each
				select="$fixedExecutes/records/notify/records/record[logId=$logId]">
				<logTs>
					<xsl:value-of select="logTs" />
				</logTs>
				<fileNameOut>
					<xsl:value-of select="fileName" />
				</fileNameOut>
				<senderId>
					<xsl:value-of select="senderId" />
				</senderId>
			</xsl:for-each>
		</item>
	</xsl:template>
</xsl:stylesheet>
