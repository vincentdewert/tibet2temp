<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	<xsl:param name="showAge" />
	<xsl:param name="srcPrefix" />
	<xsl:template match="/">
		<page title="Show Tibco Queues">
			<xsl:choose>
				<xsl:when test="name(*)='qMessage'">
					<xsl:value-of
						select="concat(qMessage/@timestamp, ', ', qMessage/@url, ' (', qMessage/@resolvedUrl, '), up since: ', qMessage/@startTime)" />
					<br />
					<br />
					<table>
						<caption class="caption">Queue Info</caption>
						<tr>
							<td class="filterRow">
								<xsl:text>queueName</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="qMessage/qName" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>pendingMsgCount</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="qMessage/qInfo/pendingMsgCount" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>pendingMsgSize</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="qMessage/qInfo/pendingMsgSize" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>receiverCount</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="qMessage/qInfo/receiverCount" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>inTotalMsgs</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="qMessage/qInfo/inTotalMsgs" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>outTotalMsgs</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="qMessage/qInfo/outTotalMsgs" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>isStatic</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="qMessage/qInfo/isStatic" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>prefetch</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="qMessage/qInfo/prefetch" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>isBridged</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="qMessage/qInfo/isBridged" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>acl</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="qMessage/qInfo/acl" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>connectedConsumers</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="qMessage/qInfo/connectedConsumers" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>bridgeTargets</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="qMessage/qInfo/bridgeTargets" />
							</td>
						</tr>
					</table>
					<table>
						<caption class="caption">Queue Message</caption>
						<tr>
							<td class="filterRow">
								<xsl:text>item</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="qMessage/qName/@item" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>messageId</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="qMessage/qMessageId" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>timestamp</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="qMessage/qTimestamp" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>properties</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="qMessage/qProps" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>messageSize</xsl:text>
							</td>
							<td class="filterRow">
								<xsl:value-of select="qMessage/qTextSize" />
							</td>
						</tr>
						<tr>
							<td class="filterRow">
								<xsl:text>message</xsl:text>
								<xsl:if test="lower-case(qMessage/qText/@text)='false'">
									<xsl:text> *</xsl:text>
								</xsl:if>
								<xsl:if test="lower-case(qMessage/qText/@chomped)='true'">
									<xsl:text> **</xsl:text>
								</xsl:if>
							</td>
							<td class="filterRow">
								<xsl:value-of select="qMessage/qText" />
							</td>
						</tr>
					</table>
				</xsl:when>
				<xsl:when test="name(*)='qInfos'">
					<xsl:value-of
						select="concat(qInfos/@timestamp, ', ', qInfos/@url, ' (', qInfos/@resolvedUrl, '), up since: ', qInfos/@startTime)" />
					<br />
					<br />
					<table>
						<caption class="caption">Queues Info</caption>
						<tr>
							<th class="colHeader">QueueName</th>
							<th class="colHeader">PendingMsgCount</th>
							<th class="colHeader">PendingMsgSize</th>
							<th class="colHeader">ReceiverCount</th>
							<th class="colHeader">InTotalMsgs</th>
							<th class="colHeader">OutTotalMsgs</th>
							<xsl:if test="lower-case($showAge)='true'">
								<th class="colHeader">FirstMsgAge</th>
							</xsl:if>
							<th class="colHeader">IsStatic</th>
							<th class="colHeader">Prefetch</th>
							<th class="colHeader">IsBridged</th>
							<th class="colHeader">ACL</th>
							<th class="colHeader">ConnectedConsumers</th>
							<th class="colHeader">BridgeTargets</th>
						</tr>
						<xsl:for-each select="qInfos/qInfo">
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
							<tr>
								<xsl:attribute name="class">
									<xsl:value-of select="$class" />
								</xsl:attribute>
								<td class="filterRow">
									<a>
										<xsl:attribute name="href">
											<xsl:variable name="qn">
												<xsl:choose>
													<xsl:when test="string-length(qNameEncoded)&gt;0">
														<xsl:value-of select="qNameEncoded" />
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="qName" />
													</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:value-of select="concat('?queueName=',$qn,'&amp;queueItem=1')" />
										</xsl:attribute>
										<xsl:choose>
											<xsl:when test="pendingMsgCount&gt;0 and receiverCount=0">
												<font color="red">
													<b>
														<xsl:value-of select="qName" />
													</b>
												</font>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="qName" />
											</xsl:otherwise>
										</xsl:choose>
									</a>
									<xsl:if
										test="pendingMsgCount&gt;0 and receiverCount=0 and (matches(acl, 'ibis4[^;]*=[^;]*receive', 'i') or matches(acl, 'ija_[^;]*=[^;]*receive', 'i'))">
										<font color="red"> *</font>
									</xsl:if>
								</td>
								<td class="filterRow">
									<xsl:value-of select="pendingMsgCount" />
								</td>
								<td class="filterRow">
									<xsl:value-of select="pendingMsgSize" />
								</td>
								<td class="filterRow">
									<xsl:value-of select="receiverCount" />
								</td>
								<td class="filterRow">
									<xsl:value-of select="inTotalMsgs" />
								</td>
								<td class="filterRow">
									<xsl:value-of select="outTotalMsgs" />
								</td>
								<xsl:if test="lower-case($showAge)='true'">
									<td class="filterRow">
										<xsl:value-of select="firstMsgAge" />
									</td>
								</xsl:if>
								<td class="filterRow">
									<xsl:value-of select="isStatic" />
								</td>
								<td class="filterRow">
									<xsl:value-of select="prefetch" />
								</td>
								<td class="filterRow">
									<xsl:value-of select="isBridged" />
								</td>
								<td class="filterRow">
									<xsl:value-of select="acl" />
								</td>
								<td class="filterRow">
									<xsl:value-of select="connectedConsumers" />
								</td>
								<td class="filterRow">
									<xsl:value-of select="bridgeTargets" />
								</td>
							</tr>
						</xsl:for-each>
					</table>
				</xsl:when>
				<xsl:when test="name(*)='qCount'">
					<xsl:value-of select="qCount" />
				</xsl:when>
				<xsl:when test="name(*)='error' and error/@info='true'">
					<font color="red">Foobar Incorrect URI, choose one of the following:</font>
					<table>
						<xsl:for-each select="error/serverAlias">
							<tr>
								<td class="filterRow">
									<a>
										<xsl:attribute name="href"><xsl:value-of
											select="concat($srcPrefix,'rest/queues/',@name)" /></xsl:attribute>
										<xsl:value-of select="@name" />
									</a>
								</td>
								<td class="filterRow">
									<xsl:value-of select="." />
								</td>
							</tr>
						</xsl:for-each>
					</table>
				</xsl:when>
				<xsl:otherwise>
					<font color="red">
						<xsl:value-of select="*" />
					</font>
					<font color="blue">
						Foobar you're now here!
					</font>
				</xsl:otherwise>
			</xsl:choose>
		</page>
	</xsl:template>
</xsl:stylesheet>