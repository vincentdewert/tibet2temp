<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="2.0">
	<xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
	<xsl:param name="srcPrefix" />
	<xsl:template match="/">
		<page title="Send Tibco Message">
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

						//]]&gt;
					</xsl:text>
			</script>
			<form method="post" action="" enctype="multipart/form-data">
				<table border="0" width="100%">
					<tr>
						<td>Select a queue connection factory</td>
						<td>
							<select class="normal" name="qcf">
								<option selected="selected" value="qcf_tibco_esb_rr">qcf_tibco_esb_rr
								</option>
								<option value="qcf_tibco_esb_ff">qcf_tibco_esb_ff</option>
								<option value="qcf_tibco_esb_rr_large">qcf_tibco_esb_rr_large</option>
								<option value="qcf_tibco_p2p_rr">qcf_tibco_p2p_rr</option>
								<option value="qcf_tibco_p2p_ff">qcf_tibco_p2p_ff</option>
								<option value="qcf_tibco_p2p_rr_large">qcf_tibco_p2p_rr_large</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>Queue destination</td>
						<td>
							<input class="text" type="text" name="queue" maxlength="180"
								size="80" value="" />
						</td>
					</tr>
					<tr>
						<td>Timeout (in msec)</td>
						<td>
							<input class="text" type="text" name="timeout" maxlength="20"
								size="10" value="5000" />
						</td>
					</tr>
					<tr>
						<td>Soap action (deviating from standard)</td>
						<td>
							<input class="text" type="text" name="soapAction" maxlength="200"
								size="200" value="" />
						</td>
					</tr>
					<tr>
						<td>Message</td>
						<td>
							<textarea class="normal" name="message" cols="580" rows="10" />
						</td>
					</tr>
					<!--tr> <td /> <td> <input class="file" type="file" name="file" value="" 
						/> </td> </tr -->
					<tr>
						<td>Wrap message in SOAP envelope</td>
						<td>
							<input class="checkbox" type="checkbox" name="wrap" value="on" />
						</td>
					</tr>
					<tr>
						<td>Common Message Header version</td>
						<td>
							<!--input class="text" type="text" name="cmhVersion" maxlength="10"
								size="5" value="1" /-->
							<select class="normal" name="cmhVersion">
								<option selected="selected" value="1">1</option>
								<option value="2">2</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>Add namespace</td>
						<td>
							<input class="checkbox" type="checkbox" name="addNamespace" value="on" />
						</td>
					</tr>
					<tr>
						<td />
						<td>
							<input type="submit" onmouseover="changeBg(this,true);"
								onmouseout="changeBg(this,false);" value="send" />
						</td>
					</tr>
				</table>
			</form>
		</page>
	</xsl:template>
</xsl:stylesheet>
