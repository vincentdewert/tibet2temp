<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	<xsl:param name="srcPrefix" />
	<xsl:param name="summary" />
	<xsl:param name="minItem" />
	<xsl:param name="maxItem" />
	<xsl:param name="transfers" />
	<xsl:param name="junk" />
	<xsl:key name="sumType" match="//result/rowset/row"
		use="concat(field[@name='APPLICATIONFUNCTION'],'_',field[@name='TYPE'])" />
	<xsl:template match="/">
		<page title="Show FxF3v2 Log">
			<table>
				<caption class="caption">Summary (all items)</caption>
				<tr>
					<th class="colHeader">StartTransfer</th>
					<th class="colHeader">StartTransferSubmitted</th>
					<th class="colHeader">StartTransferExecuted</th>
					<th class="colHeader">Notify</th>
				</tr>
				<tr>
					<xsl:for-each select="$summary">
						<td align="right" class="filterRow">
							<xsl:call-template name="mergeSum">
								<xsl:with-param name="a"
									select="key('sumType','StartTransfer_A')/field[@name='COUNTER']" />
								<xsl:with-param name="e"
									select="key('sumType','StartTransfer_E')/field[@name='COUNTER']" />
							</xsl:call-template>
						</td>
						<td align="right" class="filterRow">
							<xsl:call-template name="mergeSum">
								<xsl:with-param name="a"
									select="key('sumType','StartTransferSubmitted_A')/field[@name='COUNTER']" />
								<xsl:with-param name="e"
									select="key('sumType','StartTransferSubmitted_E')/field[@name='COUNTER']" />
							</xsl:call-template>
						</td>
						<td align="right" class="filterRow">
							<xsl:call-template name="mergeSum">
								<xsl:with-param name="a"
									select="key('sumType','StartTransferExecuted_A')/field[@name='COUNTER']" />
								<xsl:with-param name="e"
									select="key('sumType','StartTransferExecuted_E')/field[@name='COUNTER']" />
							</xsl:call-template>
						</td>
						<td align="right" class="filterRow">
							<xsl:call-template name="mergeSum">
								<xsl:with-param name="a"
									select="key('sumType','Notify_A')/field[@name='COUNTER']" />
								<xsl:with-param name="e"
									select="key('sumType','Notify_E')/field[@name='COUNTER']" />
							</xsl:call-template>
						</td>
					</xsl:for-each>
				</tr>
			</table>
			<br />
			<br />
			<table>
				<caption class="caption">
					<xsl:value-of
						select="concat('Transfers (minItem=',$minItem, ', maxItem=',$maxItem,')')" />
				</caption>
				<tr>
					<th class="colHeader">FlowId</th>
					<th class="colHeader">Sender</th>
					<th class="colHeader">Filename (in)</th>
					<th class="colHeader">StartTransfer</th>
					<th class="colHeader">StartTransferSubmitted</th>
					<th class="colHeader">StartTransferExecuted</th>
					<th class="colHeader">StatusMsg</th>
					<th class="colHeader">Notify</th>
					<th class="colHeader">Filename (out)</th>
					<th class="colHeader">Queue</th>
				</tr>
				<xsl:for-each select="$transfers/records/record">
					<xsl:sort select="startTransfer/logId" data-type="number"
						order="descending" />
					<xsl:variable name="class">
						<xsl:choose>
							<xsl:when test="position() mod 2 = 0">
								<text>rowEven</text>
							</xsl:when>
							<xsl:otherwise>
								<text>filterRow</text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:call-template name="writeTransferRow">
						<xsl:with-param name="class" select="$class" />
					</xsl:call-template>
				</xsl:for-each>
			</table>
			<xsl:if test="count($junk/records/record)&gt;0">
				<br />
				<br />
				<table>
					<caption class="caption">Junk</caption>
					<tr>
						<th class="colHeader">LogId</th>
						<th class="colHeader">StartTransfer</th>
						<th class="colHeader">StartTransferSubmitted</th>
						<th class="colHeader">StartTransferExecuted</th>
						<th class="colHeader">StatusMsg</th>
						<th class="colHeader">Notify</th>
						<th class="colHeader">Filename (out)</th>
						<th class="colHeader">Queue</th>
					</tr>
					<xsl:for-each select="$junk/records/record">
						<xsl:sort select="logId" data-type="number" order="descending" />
						<xsl:variable name="class">
							<xsl:choose>
								<xsl:when test="position() mod 2 = 0">
									<text>rowEven</text>
								</xsl:when>
								<xsl:otherwise>
									<text>filterRow</text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:call-template name="writeJunkRow">
							<xsl:with-param name="class" select="$class" />
						</xsl:call-template>
					</xsl:for-each>
				</table>
			</xsl:if>
		</page>
	</xsl:template>
	<xsl:template name="writeTransferRow">
		<xsl:param name="class" />
		<tr>
			<xsl:variable name="count" select="count(notify/item)" />
			<xsl:variable name="rs">
				<xsl:choose>
					<xsl:when test="$count=0">
						<text>1</text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$count" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:attribute name="class" select="$class" />
			<xsl:call-template name="writeRow">
				<xsl:with-param name="rowspan" select="$rs" />
				<xsl:with-param name="value" select="startTransfer/flowId" />
				<xsl:with-param name="exception" select="startTransfer/@exception" />
				<xsl:with-param name="fixed" select="'false'" />
			</xsl:call-template>
			<xsl:call-template name="writeRow">
				<xsl:with-param name="rowspan" select="$rs" />
				<xsl:with-param name="value" select="startTransfer/sender" />
				<xsl:with-param name="exception" select="startTransfer/@exception" />
				<xsl:with-param name="fixed" select="'false'" />
			</xsl:call-template>
			<xsl:call-template name="writeRow">
				<xsl:with-param name="rowspan" select="$rs" />
				<xsl:with-param name="value">
					<xsl:call-template name="fileNameWithoutPath">
						<xsl:with-param name="fileName" select="startTransfer/fileNameIn" />
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="exception" select="startTransfer/@exception" />
				<xsl:with-param name="fixed" select="'false'" />
			</xsl:call-template>
			<xsl:call-template name="writeRow">
				<xsl:with-param name="rowspan" select="$rs" />
				<xsl:with-param name="value" select="startTransfer/logTs" />
				<xsl:with-param name="exception" select="startTransfer/@exception" />
				<xsl:with-param name="fixed" select="'false'" />
			</xsl:call-template>
			<xsl:call-template name="writeRow">
				<xsl:with-param name="rowspan" select="$rs" />
				<xsl:with-param name="value" select="startTransferSubmitted/logTs" />
				<xsl:with-param name="exception"
					select="startTransferSubmitted/@exception" />
				<xsl:with-param name="fixed" select="'false'" />
			</xsl:call-template>
			<xsl:call-template name="writeRow">
				<xsl:with-param name="rowspan" select="$rs" />
				<xsl:with-param name="value" select="startTransferExecuted/logTs" />
				<xsl:with-param name="exception"
					select="startTransferExecuted/@exception" />
				<xsl:with-param name="fixed" select="'false'" />
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="string-length(startTransferExecuted/logTs)&gt;0">
					<xsl:call-template name="writeRow">
						<xsl:with-param name="rowspan" select="$rs" />
						<xsl:with-param name="value"
							select="startTransferExecuted/statusMsg" />
						<xsl:with-param name="exception"
							select="startTransferExecuted/@exception" />
						<xsl:with-param name="fixed" select="'false'" />
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="writeRow">
						<xsl:with-param name="rowspan" select="$rs" />
						<xsl:with-param name="value"
							select="startTransferSubmitted/statusMsg" />
						<xsl:with-param name="exception"
							select="startTransferSubmitted/@exception" />
						<xsl:with-param name="fixed" select="'false'" />
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="writeRow">
				<xsl:with-param name="rowspan" select="''" />
				<xsl:with-param name="value" select="notify/item[1]/logTs" />
				<xsl:with-param name="exception" select="notify/item[1]/@exception" />
				<xsl:with-param name="fixed" select="notify/item[1]/@fixed" />
			</xsl:call-template>
			<xsl:call-template name="writeRow">
				<xsl:with-param name="rowspan" select="''" />
				<xsl:with-param name="value">
					<xsl:call-template name="fileNameWithoutPath">
						<xsl:with-param name="fileName" select="notify/item[1]/fileNameOut" />
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="exception" select="notify/item[1]/@exception" />
				<xsl:with-param name="fixed" select="notify/item[1]/@fixed" />
			</xsl:call-template>
			<xsl:call-template name="writeRow">
				<xsl:with-param name="rowspan" select="''" />
				<xsl:with-param name="value" select="notify/item[1]/senderId" />
				<xsl:with-param name="exception" select="notify/item[1]/@exception" />
				<xsl:with-param name="fixed" select="notify/item[1]/@fixed" />
			</xsl:call-template>
		</tr>
		<xsl:for-each select="notify/item[position()&gt;1]">
			<tr>
				<xsl:call-template name="writeRow">
					<xsl:with-param name="rowspan" select="''" />
					<xsl:with-param name="value" select="logTs" />
					<xsl:with-param name="exception" select="@exception" />
					<xsl:with-param name="fixed" select="@fixed" />
				</xsl:call-template>
				<xsl:call-template name="writeRow">
					<xsl:with-param name="rowspan" select="''" />
					<xsl:with-param name="value">
						<xsl:call-template name="fileNameWithoutPath">
							<xsl:with-param name="fileName" select="fileNameOut" />
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="exception" select="@exception" />
					<xsl:with-param name="fixed" select="@fixed" />
				</xsl:call-template>
				<xsl:call-template name="writeRow">
					<xsl:with-param name="rowspan" select="''" />
					<xsl:with-param name="value" select="senderId" />
					<xsl:with-param name="exception" select="@exception" />
					<xsl:with-param name="fixed" select="@fixed" />
				</xsl:call-template>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="writeRow">
		<xsl:param name="rowspan" />
		<xsl:param name="value" />
		<xsl:param name="exception" />
		<xsl:param name="fixed" />
		<td class="filterRow">
			<xsl:if test="string-length($rowspan)&gt;0">
				<xsl:attribute name="rowspan" select="$rowspan" />
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$exception='true'">
					<font color="red">
						<xsl:value-of select="$value" />
					</font>
				</xsl:when>
				<xsl:when test="$fixed='true'">
					<font color="gray">
						<xsl:value-of select="$value" />
					</font>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$value" />
				</xsl:otherwise>
			</xsl:choose>
		</td>
	</xsl:template>
	<xsl:template name="writeJunkRow">
		<xsl:param name="class" />
		<tr>
			<xsl:attribute name="class"><xsl:value-of select="$class" /></xsl:attribute>
			<xsl:call-template name="writeRow">
				<xsl:with-param name="rowspan" select="''" />
				<xsl:with-param name="value" select="logId" />
				<xsl:with-param name="exception" select="@exception" />
				<xsl:with-param name="fixed" select="'false'" />
			</xsl:call-template>
			<xsl:call-template name="writeRow">
				<xsl:with-param name="rowspan" select="''" />
				<xsl:with-param name="value" select="startTransfer" />
				<xsl:with-param name="exception" select="@exception" />
				<xsl:with-param name="fixed" select="'false'" />
			</xsl:call-template>
			<xsl:call-template name="writeRow">
				<xsl:with-param name="rowspan" select="''" />
				<xsl:with-param name="value" select="startTransferSubmitted" />
				<xsl:with-param name="exception" select="@exception" />
				<xsl:with-param name="fixed" select="'false'" />
			</xsl:call-template>
			<xsl:call-template name="writeRow">
				<xsl:with-param name="rowspan" select="''" />
				<xsl:with-param name="value" select="startTransferExecuted" />
				<xsl:with-param name="exception" select="@exception" />
				<xsl:with-param name="fixed" select="'false'" />
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="string-length(startTransferExecuted)&gt;0">
					<xsl:call-template name="writeRow">
						<xsl:with-param name="rowspan" select="''" />
						<xsl:with-param name="value" select="executedStatusMsg" />
						<xsl:with-param name="exception" select="@exception" />
						<xsl:with-param name="fixed" select="'false'" />
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="writeRow">
						<xsl:with-param name="rowspan" select="''" />
						<xsl:with-param name="value" select="submittedStatusMsg" />
						<xsl:with-param name="exception" select="@exception" />
						<xsl:with-param name="fixed" select="'false'" />
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:call-template name="writeRow">
				<xsl:with-param name="rowspan" select="''" />
				<xsl:with-param name="value" select="notify" />
				<xsl:with-param name="exception" select="@exception" />
				<xsl:with-param name="fixed" select="'false'" />
			</xsl:call-template>
			<xsl:call-template name="writeRow">
				<xsl:with-param name="rowspan" select="''" />
				<xsl:with-param name="value">
					<xsl:call-template name="fileNameWithoutPath">
						<xsl:with-param name="fileName" select="fileNameOut" />
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="exception" select="@exception" />
				<xsl:with-param name="fixed" select="'false'" />
			</xsl:call-template>
			<xsl:call-template name="writeRow">
				<xsl:with-param name="rowspan" select="''" />
				<xsl:with-param name="value" select="senderId" />
				<xsl:with-param name="exception" select="@exception" />
				<xsl:with-param name="fixed" select="'false'" />
			</xsl:call-template>
		</tr>
	</xsl:template>
	<xsl:template name="fileNameWithoutPath">
		<xsl:param name="fileName" />
		<xsl:variable name="lsasf">
			<xsl:call-template name="lastSubstringAfter">
				<xsl:with-param name="string" select="$fileName" />
				<xsl:with-param name="subString" select="'/'" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="lsasb">
			<xsl:call-template name="lastSubstringAfter">
				<xsl:with-param name="string" select="$fileName" />
				<xsl:with-param name="subString" select="'\'" />
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="string-length($lsasf)&lt;string-length($lsasb)">
				<xsl:value-of select="$lsasf" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$lsasb" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="lastSubstringAfter">
		<xsl:param name="string" />
		<xsl:param name="subString" />
		<xsl:choose>
			<xsl:when test="contains($string, $subString)">
				<xsl:call-template name="lastSubstringAfter">
					<xsl:with-param name="string"
						select="substring-after($string, $subString)" />
					<xsl:with-param name="subString" select="$subString" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="mergeSum">
		<xsl:param name="a" />
		<xsl:param name="e" />
		<xsl:variable name="ax">
			<xsl:choose>
				<xsl:when test="string-length($a)=0">
					<xsl:text>0</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$a" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="ex">
			<xsl:choose>
				<xsl:when test="string-length($e)=0">
					<xsl:text>0</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$e" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="concat($ax,'/',$ex)" />
	</xsl:template>
</xsl:stylesheet>
