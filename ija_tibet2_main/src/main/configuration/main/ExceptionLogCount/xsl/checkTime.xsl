
<xsl:stylesheet version="2.0"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  >
  <xsl:output method="text"/>
  <xsl:param name="dateTimeStamp"/>
  
  
   <xsl:template match="/">
   
   <xsl:param name="dateTimeStamp2">
        <xsl:value-of select="substring( $dateTimeStamp,15, 2)"/>
   </xsl:param>    
    
        <xsl:choose>
            <xsl:when test="number($dateTimeStamp2) &gt; 54 and number($dateTimeStamp2) &lt; 60">rename</xsl:when>
            <xsl:otherwise>write</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
 