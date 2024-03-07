<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="srcPrefix" />
	<xsl:param name="tibcoPrincipal" />
	<xsl:template match="/">
		<page title="Generate Tibco Queues Overview">
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
				<xsl:if test="number(queues/@error)&gt;0">
					<i><font color="red">Note: input file contains errors</font></i>
					<br/><br/>
				</xsl:if>
				<table border="0" width="100%">
					<tr>
						<td>Search value(s)</td>
						<td>
							<input class="text" type="text" name="searchValue" maxlength="100" size="30" value=""/>
						</td>
					</tr>
					<tr>
						<td>Output format</td>
						<td>
							<select class="normal" name="outputFormat">
								<option value="bmp">bmp (Bitmap)</option>
								<option value="gif">gif (Graphics Interchange Format)</option>
								<option value="jpg">jpg (Joint Photographic Experts Group)</option>
								<option value="jpeg">jpeg (Joint Photographic Experts Group)</option>
								<option value="pdf">pdf (Portable Document Format)</option>
								<option value="png">png (Portable Network Graphics)</option>
								<option selected="selected" value="svg">svg (Scalable Vector Graphics)</option>
								<option value="tif">tif (Tag Image File Format)</option>
								<option value="tiff">tiff (Tag Image File Format)</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>Legend</td>
						<td>
							<input class="checkbox" type="checkbox" name="legend" value="on" />
						</td>
					</tr>
					<tr>
						<td>Expand Tibco principal</td>
						<td>
							<input class="checkbox" type="checkbox" name="expandTP" value="on" />
						</td>
					</tr>
					<tr>
						<td>Tibco principal</td>
						<td>
							<input class="text" type="text" name="tibcoPrincipal" maxlength="50" size="20">
								<xsl:attribute name="value" select="$tibcoPrincipal"/>
							</input>
						</td>
					</tr>
					<tr>
						<td>Add message count</td>
						<td>
							<input class="checkbox" type="checkbox" name="msgCount" value="on" />
						</td>
					</tr>
					<tr>
						<td/>
						<td>
							<input class="submit" onmouseover="changeBg(this,true);" onmouseout="changeBg(this,false);" type="submit" value="send"/>
						</td>
					</tr>
				</table>
			</form>
			<table>
				<tr>
					<td>
						<a onclick="switchVars('open');return false;" href="#" id="open" class="expand"><img src="../images/smallhelp.gif" alt="open help"/></a>
						<a style="display:none;" onclick="switchVars('close');return false;" href="#" id="close" class="expand"><img src="../images/smallhelp.gif" alt="close help"/></a>
					</td>
				</tr>
				<tr>
					<td>
						<div style="display:none;" id="variables" class="messagesRow">	
							<p>
								<text>In the field 'Search value(s)' specify a comma separated list of values (or just one value) to search on.</text>
								<br/>
								<text>These values can be a queue name, a principal name or a principal description. Also partial names and partial descriptions are allowed.</text>
								<br/>
								<br/>
								<text>When a queue is found, this queue with all sender principals and receiver principals are shown in the overview. If this queue is brigded, also the bridge target queues and its receiver principals are shown in the overview.</text>
								<br/>
								<br/>
								<text>When a principal is found, this principal with all the sender queues and receiver queues are shown in the overview. For these sender queues also the receiver principals are shown.</text>
							</p>
						</div>
					</td>
				</tr>
			</table>
		</page>
	</xsl:template>
</xsl:stylesheet>
