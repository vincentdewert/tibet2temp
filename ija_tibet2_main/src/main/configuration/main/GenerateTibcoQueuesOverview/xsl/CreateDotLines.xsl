<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="text" indent="no"/>
	<xsl:param name="searchString"/>
	<xsl:param name="legend"/>
	<xsl:param name="expand"/>
	<xsl:param name="eol"/>
	<xsl:param name="msgCount"/>
	<xsl:param name="tibcoQueues"/>
	<xsl:variable name="space" select="' '"/>
	<xsl:variable name="quote" select="'&quot;'"/>
	<xsl:variable name="brvbar" select="'&#166;'" />
	<xsl:template match="lines">
		<xsl:value-of select="concat('digraph {',$eol)"/>
		<xsl:value-of select="concat('labelloc=',$quote,'t',$quote,$eol)"/>
		<xsl:value-of select="concat('label=',$quote,'T I B C O  Q U E U E S  O V E R V I E W\n searched on [',$searchString,']',$quote,$eol)"/>
		<xsl:value-of select="concat('graph [rankdir=LR,splines=true,concentrate=true]',$eol)"/>
		<xsl:value-of select="concat('node [shape=box]',$eol)"/>
		<xsl:if test="$legend='on'">
			<xsl:value-of select="concat('subgraph cluster_legend {',$eol)"/>
			<xsl:value-of select="concat('label=',$quote,'Legend',$quote,';',$eol)"/>
			<xsl:value-of select="concat('npac [label=',$quote,'...',$quote,']',$eol)"/>
			<xsl:value-of select="concat('npa [shape=plaintext,label=',$quote,'Message sender/receiver',$quote,']',$eol)"/>
			<xsl:value-of select="concat('npafc [label=',$quote,'...',$quote,'style=filled,fillcolor=grey]',$eol)"/>
			<xsl:value-of select="concat('npaf [shape=plaintext,label=',$quote,'Message sender/receiver containing searched string',$quote,']',$eol)"/>
			<xsl:value-of select="concat('npacx [label=',$quote,'...|...',$quote,'shape=record]',$eol)"/>
			<xsl:value-of select="concat('npax [shape=plaintext,label=',$quote,'Expanded message sender/receiver',$quote,']',$eol)"/>
			<xsl:value-of select="concat('queuec [label=',$quote,'...',$quote,',style=rounded]',$eol)"/>
			<xsl:value-of select="concat('queue [shape=plaintext,label=',$quote,'Queue',$quote,']',$eol)"/>
			<xsl:value-of select="concat('queuefc [label=',$quote,'...',$quote,',style=&quot;rounded,filled&quot;,fillcolor=grey]',$eol)"/>
			<xsl:value-of select="concat('queuef [shape=plaintext,label=',$quote,'Queue containing searched string',$quote,']',$eol)"/>
			<xsl:value-of select="concat('queuecx [label=',$quote,'...|...',$quote,',style=rounded,shape=record]',$eol)"/>
			<xsl:value-of select="concat('queuex [shape=plaintext,label=',$quote,'Queue with message count (inbound/outbound/pending, since latest restart)',$quote,']',$eol)"/>
			<xsl:value-of select="concat('npac1 [label=',$quote,'...',$quote,']',$eol)"/>
			<xsl:value-of select="concat('queuec1 [label=',$quote,'...',$quote,',style=rounded]',$eol)"/>
			<xsl:value-of select="concat('npac1 -&gt; queuec1 [color=red]',$eol)"/>
			<xsl:value-of select="concat('sending [shape=plaintext,label=',$quote,'Message sending to queue',$quote,']',$eol)"/>
			<xsl:value-of select="concat('queuec2 [label=',$quote,'...',$quote,',style=rounded]',$eol)"/>
			<xsl:value-of select="concat('npac2 [label=',$quote,'...',$quote,']',$eol)"/>
			<xsl:value-of select="concat('queuec2 -&gt; npac2 [color=blue]',$eol)"/>
			<xsl:value-of select="concat('receiving [shape=plaintext,label=',$quote,'Message receiving from queue',$quote,']',$eol)"/>
			<xsl:value-of select="concat('npac3 [label=',$quote,'...',$quote,']',$eol)"/>
			<xsl:value-of select="concat('queuec3 [label=',$quote,'...',$quote,',style=rounded]',$eol)"/>
			<xsl:value-of select="concat('npac3 -&gt; queuec3 [color=purple]',$eol)"/>
			<xsl:value-of select="concat('queuec3 -&gt; npac3 [color=purple]',$eol)"/>
			<xsl:value-of select="concat('both [shape=plaintext,label=',$quote,'Both message sending and receiving',$quote,']',$eol)"/>
			<xsl:value-of select="concat('queuec4a [label=',$quote,'...',$quote,',style=rounded]',$eol)"/>
			<xsl:value-of select="concat('queuec4b [label=',$quote,'...',$quote,',style=rounded]',$eol)"/>
			<xsl:value-of select="concat('queuec4a -&gt; queuec4b [color=green]',$eol)"/>
			<xsl:value-of select="concat('bridging [shape=plaintext,label=',$quote,'Message bridging between queues',$quote,']',$eol)"/>
			<xsl:value-of select="concat('npa -> npac [style=invis]',$eol)"/>
			<xsl:value-of select="concat('{rank=same;npa npaf npax queue queuef queuex sending receiving both bridging}',$eol)"/>
			<xsl:value-of select="concat('{rank=same;npac npafc npacx queuec queuefc queuecx npac1 queuec2 npac3 queuec4a}',$eol)"/>
			<xsl:value-of select="concat('}',$eol)"/>
		</xsl:if>
		<xsl:for-each-group select="line/*[@type='queue']" group-by=".">
			<xsl:variable name="elem" select="."/>
			<xsl:variable name="contain">
				<xsl:call-template name="containsStringToken">
					<xsl:with-param name="source" select="$elem"/>
					<xsl:with-param name="string" select="$searchString"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="msgCountLabel">
				<xsl:if test="$msgCount='on'">
					<xsl:for-each select="($tibcoQueues/queues/queue[name=$elem])[1]">
						<xsl:value-of select="concat(',label=&quot;',$elem,'|',msgCount,$space,'(',msgCount/@since,')','&quot;,shape=record')"/>
					</xsl:for-each>
				</xsl:if>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$contain='Y'">
					<xsl:value-of select="concat($quote,$elem,$quote,$space,'[style=&quot;rounded,filled&quot;,fillcolor=grey',$msgCountLabel,']',$eol)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($quote,$elem,$quote,$space,'[style=rounded',$msgCountLabel,']',$eol)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each-group>
		<xsl:for-each-group select="line/*[@type='principal']" group-by=".">
			<xsl:variable name="elem" select="."/>
			<xsl:choose>
				<xsl:when test="$expand='on' and contains($elem,$brvbar)">
					<xsl:variable name="elem1" select="substring-before($elem,$brvbar)"/>
					<xsl:variable name="elem2" select="substring-after($elem,$brvbar)"/>
					<xsl:variable name="label" select="concat('label=&quot;',$elem1,'|',$elem2,'&quot;,shape=record')"/>
<!--
					<xsl:variable name="label">
						<xsl:text>shape=none,label=&lt;&lt;table border=&quot;0&quot; cellspacing=&quot;0&quot;&gt;</xsl:text>
						<xsl:text>&lt;tr&gt;&lt;td border=&quot;1&quot;&gt;</xsl:text>
						<xsl:value-of select="$elem1"/>
						<xsl:text>&lt;/td&gt;&lt;/tr&gt;</xsl:text>
						<xsl:text>&lt;tr&gt;&lt;td border=&quot;1&quot;&gt;</xsl:text>
						<xsl:value-of select="$elem2"/>
						<xsl:text>&lt;/td&gt;&lt;/tr&gt;</xsl:text>
						<xsl:text>&lt;/table&gt;&gt;</xsl:text>
					</xsl:variable>
-->
					<xsl:variable name="contain">
						<xsl:call-template name="containsStringToken">
							<xsl:with-param name="source" select="$elem1"/>
							<xsl:with-param name="string" select="$searchString"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="$contain='Y'">
							<xsl:value-of select="concat($quote,$elem,$quote,$space,'[style=filled,fillcolor=grey,',$label,']',$eol)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat($quote,$elem,$quote,$space,'[',$label,']',$eol)"/>
						</xsl:otherwise>
					</xsl:choose>				
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="contain">
						<xsl:call-template name="containsStringToken">
							<xsl:with-param name="source" select="$elem"/>
							<xsl:with-param name="string" select="$searchString"/>
						</xsl:call-template>
					</xsl:variable>
					<xsl:if test="$contain='Y'">
						<xsl:value-of select="concat($quote,$elem,$quote,$space,'[style=filled,fillcolor=grey]',$eol)"/>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each-group>
		<xsl:for-each select="line">
			<xsl:variable name="toType" select="to/@type"/>
			<xsl:variable name="to" select="to"/>
			<xsl:variable name="fromType" select="from/@type"/>
			<xsl:variable name="from" select="from"/>
			<xsl:variable name="color">
				<xsl:choose>
					<xsl:when test="../line[to/@type=$fromType and to=$from and from/@type=$toType and from=$to]">
						<xsl:text>purple</xsl:text>
					</xsl:when>
					<xsl:when test="$toType='principal'">
						<xsl:text>blue</xsl:text>
					</xsl:when>
					<xsl:when test="$fromType='principal'">
						<xsl:text>red</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>green</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:value-of select="concat($quote,from,$quote,$space,'-&gt;',$space,$quote,to,$quote,$space,'[color=',$color,']',$eol)"/>
		</xsl:for-each>
		<xsl:text>}</xsl:text>
	</xsl:template>
	<xsl:template name="containsStringToken">
		<xsl:param name="source"/>
		<xsl:param name="string"/>
		<xsl:variable name="result">
			<xsl:for-each select="tokenize($string,',')">
				<xsl:variable name="token">
					<xsl:sequence select="normalize-space(.)"/>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="contains(upper-case($source),upper-case($token))">
						<xsl:text>Y</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>N</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($result,'Y')">
				<xsl:text>Y</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>N</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
