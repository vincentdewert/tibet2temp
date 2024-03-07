<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="srcPrefix" />
	<xsl:template match="/">
			<page title="Generate WSDL">
				<script type="text/javascript">
					<xsl:text disable-output-escaping="yes">
						//&lt;![CDATA[

						function changeBg(obj,isOver) {
							var color1="#8D0022";
							var color2="#b4e2ff";
							if (isOver) {
							    obj.style.backgroundColor=color1;
							    obj.style.color=color2;
							} else {
							    obj.style.backgroundColor=color2;
							    obj.style.color=color1;
							}
						}
						
						function switchVars(action) {
							if (action == 'open') {
								document.getElementById("variables").style.display = "block";
								document.getElementById("open").style.display = "none";
								document.getElementById("close").style.display = "inline-block";
							} else {
								document.getElementById("variables").style.display = "none";
								document.getElementById("open").style.display = "inline-block";
								document.getElementById("close").style.display = "none";
							}
						}

						//]]&gt;
					</xsl:text>
				</script>
				<form method="post" action="" enctype="multipart/form-data">
					<table border="0" width="100%">
						<tr>
							<td>Upload xsd/zip file</td>
							<td>
								<input type="file" name="file" value=""/>
							</td>
						</tr>
						<tr>
							<td/>
							<td>
								<input type="submit" onmouseover="changeBg(this,true);" onmouseout="changeBg(this,false);" value="send"/>
							</td>
						</tr>
					</table>
				</form>
				<table>
					<tr>
						<td>
							<xsl:variable name="imgSrc" select="concat($srcPrefix,'images/smallhelp.gif')"/>
							<a onclick="switchVars('open');return false;" href="#" id="open" class="expand"><img alt="open help"><xsl:attribute name="src" select="$imgSrc"/></img></a>
							<a style="display:none;" onclick="switchVars('close');return false;" href="#" id="close" class="expand"><img alt="close help"><xsl:attribute name="src" select="$imgSrc"/></img></a>
						</td>
					</tr>
					<tr>
						<td>
							<div style="display:none;" id="variables" class="messagesRow">	
								<p>
									<text>Choose one of the following files to upload:</text>
									<ol>
										<li><b>xsd file</b></li>
										<p>
											<text>Upload a single xsd file when no other xml schemas are imported or included, and when a wsdl properties file is not required.</text>
										</p>
										<li><b>zip file</b></li>
										<p>
											<text>Upload a zip file when multiple xsd files are involved or when a wsdl properties file is required. When a wsdl properties file is not available, the first xsd file in the root directory of the zip file is assumed to be the root xsd file.</text>
										</p>
									</ol>
								</p>
								<p>
									<table>
										<caption class="caption">WSDL properties file ("wsdl.properties")</caption>
										<tr>
											<td class="subHeader">Property</td>
											<td class="subHeader">Description</td>
											<td class="subHeader">Default</td>
										</tr>
										<tr>
											<td class="messagesRow">input.xsd</td>
											<td class="messagesRow">The file name of the root xsd file which contains the input message. When this xsd file is not in the root directory of the zip file (but in a subdirectory), use a relative path.</td>
											<td class="messagesRow"></td>
										</tr>
										<tr>
											<td class="messagesRow">input.namespace</td>
											<td class="messagesRow">The target namespace which should be used for the input message. If this namespace differs from the actual target namespace in the xsd file, the actual target namespace in the xsd file is overridden. In this way it's also possible to add a target namespace to an input message which has no target namespace in the xsd file.</td>
											<td class="messagesRow">The actual target namespace in the input xsd file (targetNamespace attribute in the root schema element)</td>
										</tr>
										<tr>
											<td class="messagesRow">input.root</td>
											<td class="messagesRow">The name of the input message root element</td>
											<td class="messagesRow">The name of the first element in the input xsd file (element element)</td>
										</tr>
										<tr>
											<td class="messagesRow">input.cmh</td>
											<td class="messagesRow">The version of the Common Message Header which should be used for the input message</td>
											<td class="messagesRow">1</td>
										</tr>
										<tr>
											<td class="messagesRow">output.xsd</td>
											<td class="messagesRow">The file name of the root xsd file which contains the output message. When this xsd file is not in the root directory of the zip file (but in a subdirectory), use a relative path.</td>
											<td class="messagesRow">When a xsd file is uploaded, an output message is assumed if there are two or more elements in the xsd file.</td>
										</tr>
										<tr>
											<td class="messagesRow">output.namespace</td>
											<td class="messagesRow">The target namespace which should be used for the output message. If this namespace differs from the actual target namespace in the xsd file, the actual target namespace in the xsd file is overridden. In this way it's also possible to add a target namespace to an output message which has no target namespace in the xsd file.</td>
											<td class="messagesRow">The actual target namespace in the output xsd file (targetNamespace attribute in the root schema element)</td>
										</tr>
										<tr>
											<td class="messagesRow">output.root</td>
											<td class="messagesRow">The name of the output message root element</td>
											<td class="messagesRow">When the output xsd file is the input xsd file, the name of the second element in the xsd file (element element). Otherwise the name of the first element in the xsd file.</td>
										</tr>
										<tr>
											<td class="messagesRow">output.cmh</td>
											<td class="messagesRow">The version of the Common Message Header which should be used for the output message</td>
											<td class="messagesRow">1</td>
										</tr>
									</table>
								</p>
							</div>
						</td>
					</tr>
				</table>
			</page>
	</xsl:template>
</xsl:stylesheet>
