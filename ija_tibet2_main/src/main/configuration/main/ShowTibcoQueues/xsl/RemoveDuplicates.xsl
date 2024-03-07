<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

	<xsl:template match="/*">
		<queues>
       <xsl:for-each-group select="queue" group-by="name | name">
         <xsl:sequence select="."/>
       </xsl:for-each-group>
     	</queues>
	</xsl:template>	
	
</xsl:stylesheet>
