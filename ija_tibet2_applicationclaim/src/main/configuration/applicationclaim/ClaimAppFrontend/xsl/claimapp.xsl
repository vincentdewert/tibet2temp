<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	
	<xsl:template match="/">
		<page title="Claim an Application" style="width:100%; height:100%;margin:0px; padding:0px;inset:0px;">
			<iframe src = "/ija_tibet2/claimapp" style="width:100%; height:800px;overflow-x:hidden"></iframe>
		</page>
	</xsl:template>
</xsl:stylesheet>